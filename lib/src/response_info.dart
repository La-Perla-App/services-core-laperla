import 'dart:convert';

import 'package:connectrpc/connect.dart';

import 'headers.dart';
import 'platforms.dart';

/// Go `api.ResponseInfo` as sent in `Response-Info-Bin`.
class ResponseInfo {
  const ResponseInfo({
    this.type = '',
    this.message = '',
    this.sessionToken = '',
    this.clientId = '',
    this.apiErrorCode = 0,
  });

  final String type;
  final String message;
  final String sessionToken;
  final String clientId;
  final int apiErrorCode;

  bool get isError => type == 'error';

  static ResponseInfo fromJson(Map<String, dynamic> map) {
    return ResponseInfo(
      type: map['type'] as String? ?? '',
      message: map['message'] as String? ?? '',
      sessionToken: map['sessionToken'] as String? ??
          map['SessionToken'] as String? ??
          '',
      clientId: map['ClientId'] as String? ?? map['clientId'] as String? ?? '',
      apiErrorCode: (map['apiErrorCode'] as num?)?.toInt() ?? 0,
    );
  }

  static ResponseInfo? tryParse(Headers headers) {
    return tryParseBin(headers[LaperlaHeaders.responseInfoBin]);
  }

  static ResponseInfo? tryParseBin(String? raw) {
    final bytes = decodeConnectBin(raw);
    if (bytes == null) {
      return null;
    }
    final map = jsonDecode(utf8.decode(bytes));
    if (map is! Map<String, dynamic>) {
      return null;
    }
    return fromJson(map);
  }
}
