import 'package:connectrpc/connect.dart';

import 'response_info.dart';

/// Codes the Go core puts on `Response-Info-Bin` / Connect.
abstract final class LaperlaErrorCode {
  static const internal = 13;
  static const unauthenticated = 16;
  static const notFound = 5;
  static const invalidArgument = 3;
  static const alreadyExists = 6;
  static const tokenInvalidOrExpired = 427;
  static const userDeactivated = 428;
  static const userNotVerified = 429;
}

class LaperlaException implements Exception {
  LaperlaException({
    required this.message,
    this.code = LaperlaErrorCode.internal,
    this.connectCode,
    this.responseInfo,
  });

  final String message;
  final int code;
  final Code? connectCode;
  final ResponseInfo? responseInfo;

  bool get isUnauthenticated =>
      code == LaperlaErrorCode.unauthenticated ||
      connectCode == Code.unauthenticated;

  @override
  String toString() => 'LaperlaException($code): $message';

  static LaperlaException fromConnect(
    ConnectException error, {
    ResponseInfo? info,
  }) {
    final code = info != null && info.apiErrorCode != 0
        ? info.apiErrorCode
        : error.code.value;
    final message = (info != null && info.message.isNotEmpty)
        ? info.message
        : error.message;
    return LaperlaException(
      message: message,
      code: code,
      connectCode: error.code,
      responseInfo: info,
    );
  }
}
