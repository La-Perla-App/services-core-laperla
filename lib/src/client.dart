import 'package:connectrpc/connect.dart';

import 'general_params.dart';
import 'session_store.dart';
import 'transport.dart';

/// Config + sesión para todos los clientes Connect generados de los servicios.
///
/// ```dart
/// final services = LaperlaServices(
///   baseUrl: 'https://dev.laperlaapp.biz',
///   params: () => GeneralParams(lang: 'es', platform: LaperlaPlatform.ios),
///   sessionStore: MemorySessionStore(),
/// );
/// final transport = services.transport(httpClient);
/// final auth = AuthServiceClient(transport);
/// ```
class LaperlaServices {
  LaperlaServices({
    required this.baseUrl,
    required this.params,
    this.sessionStore,
    this.codec,
    this.extraInterceptors = const [],
  });

  final String baseUrl;
  final GeneralParams Function() params;
  final SessionStore? sessionStore;
  final Codec? codec;
  final List<Interceptor> extraInterceptors;

  Transport transport(HttpClient httpClient) {
    return createLaperlaServicesTransport(
      baseUrl: baseUrl,
      httpClient: httpClient,
      params: params,
      sessionStore: sessionStore,
      codec: codec,
      extraInterceptors: extraInterceptors,
    );
  }

  Future<void> signOut() async {
    await sessionStore?.clear();
  }
}
