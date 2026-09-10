import 'dart:convert';

import 'package:laperla_services_core/laperla_services_core.dart';
import 'package:test/test.dart';

void main() {
  test('parses Response-Info-Bin with Go json tags', () {
    final bin = encodeConnectBin(
      utf8.encode(
        jsonEncode({
          'type': 'success',
          'message': 'Success',
          'sessionToken': 'jwt-2',
          'apiErrorCode': 0,
          'ClientId': 'c-99',
        }),
      ),
    );

    final info = ResponseInfo.tryParseBin(bin)!;
    expect(info.type, 'success');
    expect(info.message, 'Success');
    expect(info.sessionToken, 'jwt-2');
    expect(info.clientId, 'c-99');
    expect(info.isError, isFalse);
  });

  test('parses custom API error codes', () {
    final info = ResponseInfo.fromJson({
      'type': 'error',
      'message': 'token_invalid_or_expired',
      'apiErrorCode': 427,
    });
    expect(info.isError, isTrue);
    expect(info.apiErrorCode, LaperlaErrorCode.tokenInvalidOrExpired);
  });
}
