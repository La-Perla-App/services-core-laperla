# Cómo consumir servicios La Perla desde Flutter

## 1. Generar clientes Dart en el repo del **servicio**

Cada servicio B2C trae `buf.gen.dart.yaml`:

```bash
cd auth-backend-laperla   # ver lista completa en app-wiring.md
buf generate --template buf.gen.dart.yaml
# → gen/dart/services/.../*.connect.client.dart
```

Repos B2C actuales y orden de pantallas: [app-wiring.md](app-wiring.md).

```yaml
plugins:
  - remote: buf.build/protocolbuffers/dart
    out: gen/dart
  - remote: buf.build/connectrpc/dart
    out: gen/dart
```

Eso produce algo como `auth_service.connect.client.dart` con:

```dart
class AuthServiceClient {
  AuthServiceClient(this._transport);
  Future<LoginResponse> credentialsLogin(CredentialsLoginRequest input, {Headers? headers});
}
```

**No copies DTOs a mano.** El contrato es el `.proto`.

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

Los stubs generados: path / git al repo del servicio, o publica un paquete `laperla_auth` que solo reexporte `gen/dart`.

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
