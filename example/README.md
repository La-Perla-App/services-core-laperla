# Ejemplo

No hay stubs de auth en este paquete. Tras `buf generate` en `auth-backend-laperla`:

```dart
import 'package:connectrpc/http2.dart';
import 'package:laperla_services_core/laperla_services_core.dart';
import 'package:auth_dart/auth.connect.client.dart'; // tu paquete generado

void main() async {
  final store = MemorySessionStore();
  final services = LaperlaServices(
    baseUrl: 'https://dev.laperlaapp.biz',
    sessionStore: store,
    params: () => const GeneralParams(
      lang: 'es',
      platform: LaperlaPlatform.android,
      clientVersion: '0.0.1',
    ),
  );
  final auth = AuthServiceClient(services.transport(createHttpClient()));
  final login = await auth.credentialsLogin(
    CredentialsLoginRequest(email: 'a@b.c', password: 'secret123'),
  );
  print(login.user);
}
```
