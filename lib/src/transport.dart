import 'package:connectrpc/connect.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;

import 'general_params.dart';
import 'interceptors.dart';
import 'session_store.dart';

/// Builds the [Transport] that generated `*Client(transport)` classes need.
///
/// Pass a platform HTTP client:
/// - VM / Flutter mobile: `createHttpClient()` from `package:connectrpc/http2.dart`
/// - Web: `createHttpClient()` from `package:connectrpc/web.dart`
Transport createLaperlaServicesTransport({
  required String baseUrl,
  required HttpClient httpClient,
  required GeneralParams Function() params,
  SessionStore? sessionStore,
  Codec? codec,
  List<Interceptor> extraInterceptors = const [],
}) {
  return protocol.Transport(
    baseUrl: baseUrl,
    codec: codec ?? const ProtoCodec(),
    httpClient: httpClient,
    interceptors: [
      ...extraInterceptors,
      generalParamsInterceptor(params: params, sessionStore: sessionStore),
      sessionAndErrorInterceptor(sessionStore: sessionStore),
    ],
  );
}
