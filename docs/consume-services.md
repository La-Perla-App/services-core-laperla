# Cómo consumir servicios La Perla desde Flutter

## 1. Los clientes Dart se generan en la **app**

`app-laperla` los genera desde los `.proto` de cada servicio, leyéndolos de git,
y los commitea en su propio `lib/gen/`:

```bash
cd app-laperla
./tool/proto.sh          # → lib/gen/services/.../*.connect.client.dart
./tool/proto_check.sh    # falla si lo commiteado no coincide con los .proto
```

Todo el contrato vive en `app-laperla/buf.gen.dart.yaml` y `tool/proto.sh`:
qué repos, qué se excluye y con qué versiones. Lo que hay que saber al tocarlo:

- **Sólo superficies públicas.** Los `service_internal.proto` son RPC de staff
  que sólo se alcanzan dentro del clúster; ni se generan.
- **Plugins locales con versión fija.** Ocho inputs contra los plugins remotos
  del BSR agotan el límite y la generación queda a medias. La versión del
  plugin tiene que seguir a la del runtime: este paquete pide
  `connectrpc ^1.0.0` (protobuf `>=3.1.0 <5.0.0`), así que `protoc_plugin`
  va en 22.5.0 — con 25.x el código generado no compila.
- **`--include-imports --include-wkt`.** En Dart los tipos bien conocidos
  (`Timestamp`, `Struct`, `HttpBody`) no vienen con ninguna dependencia.

Los repos de servicio ya **no** traen `buf.gen.dart.yaml` ni `gen/dart/`: eran
stubs que nadie compilaba y que se quedaron con una API de protobuf
incompatible.

**No copies DTOs a mano.** El contrato es el `.proto`.

Repos B2C y orden de pantallas: [app-wiring.md](app-wiring.md).

## 2. Dependencias en la app Flutter

```yaml
dependencies:
  laperla_services_core:
    git:
      url: https://github.com/La-Perla-App/services-core-laperla.git
      tag: v0.1.0
  connectrpc: ^1.0.0
  flutter_secure_storage: ^9.2.2
```

Los stubs no son una dependencia: viven en `lib/gen/` de la propia app.

## 3. Un Transport para todos los clientes

```dart
import 'package:connectrpc/http2.dart'; // o connectrpc/web.dart en Flutter web
import 'package:laperla_services_core/laperla_services_core.dart';
// import generated AuthServiceClient + requests

final store = FlutterSecureSessionStore(); // tu impl de SessionStore

final services = LaperlaServices(
  baseUrl: 'https://dev.laperlaapp.biz',
  sessionStore: store,
  params: () => GeneralParams(
    lang: 'es',
    platform: LaperlaPlatform.ios,
    clientVersion: '0.1.0',
    clientId: installId,
    ianaTimezone: 'America/Caracas',
    destinationId: currentDestinationId,
  ),
);

final transport = services.transport(createHttpClient());
final auth = AuthServiceClient(transport);
final directory = DirectoryServiceClient(transport); // cuando exista
```

No hace falta pasar `GeneralParams` a cada RPC: el interceptor los pone en **todos** los calls de ese transport.

## 4. Auth

```dart
final login = await auth.credentialsLogin(
  CredentialsLoginRequest(email: email, password: password),
);
// token: login.token y/o Response-Info-Bin → SessionStore

final profile = await auth.getProfile(GetProfileRequest());

await auth.logout(LogoutRequest());
await services.signOut();
```

Registro B2C: `register` **sin** token (store vacío). Invite staff: el dashboard web ya tiene sesión.

OAuth: `oAuthLogin(OAuthLoginRequest(provider: 'google', idToken: token))`.

## 5. Errores

Los fallos Connect salen como `LaperlaException`:

| `code` | Significado |
|---|---|
| 16 / unauthenticated | Sesión inválida o revocada en Redis → login |
| 427 | Token verify/reset usado |
| 428 | Usuario desactivado |
| 429 | Email no verificado |

## 6. Web vs mobile

- Mobile: `package:connectrpc/http2.dart` `createHttpClient()`
- Web: `package:connectrpc/web.dart` `createHttpClient()` (mismo origin / CORS en Traefik)

Cookie `laperla-access-token` la manda el interceptor también como `Cookie` por si el edge usa transcoding HTTP.

## 7. Qué no vive aquí

Pases, QR, points, Riverpod/Bloc, design system. Este paquete solo **transporte + identidad de request**.
