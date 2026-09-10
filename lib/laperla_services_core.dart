/// Core para consumir servicios La Perla desde Flutter/Dart.
///
/// Mismos *GeneralParams* que `backend-core-laperla`, más el [Transport]
/// ConnectRPC que usan los `*Client` generados por proto.
library;

export 'src/client.dart';
export 'src/errors.dart';
export 'src/general_params.dart';
export 'src/headers.dart';
export 'src/interceptors.dart';
export 'src/platforms.dart';
export 'src/response_info.dart';
export 'src/session_store.dart';
export 'src/transport.dart';
