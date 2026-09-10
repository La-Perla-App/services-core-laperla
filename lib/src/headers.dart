import 'dart:convert';

import 'package:connectrpc/connect.dart';

import 'general_params.dart';
import 'platforms.dart';

/// Applies [params] onto Connect [headers] the way the Go core expects.
void applyGeneralParams(Headers headers, GeneralParams params) {
  for (final e in generalParamsHeaderPairs(params)) {
    headers[e.name] = e.value;
  }
}

/// Pure pairs so tests do not need a Connect [Headers] instance.
List<({String name, String value})> generalParamsHeaderPairs(
  GeneralParams params,
) {
  final out = <({String name, String value})>[
    (name: LaperlaHeaders.acceptLanguage, value: params.lang),
    (name: LaperlaHeaders.timezone, value: params.ianaTimezone),
    (name: LaperlaHeaders.platform, value: params.platform),
    (name: LaperlaHeaders.clientVersion, value: params.clientVersion),
    (
      name: LaperlaHeaders.generalParamsBin,
      value: encodeConnectBin(utf8.encode(jsonEncode(params.toGoJson()))),
    ),
  ];

  if (params.sessionToken.isNotEmpty) {
    out.add((
      name: LaperlaHeaders.authorization,
      value: 'Bearer ${params.sessionToken}',
    ));
  }
  if (params.clientId.isNotEmpty) {
    out.add((name: LaperlaHeaders.clientId, value: params.clientId));
  }
  if (params.destinationId.isNotEmpty) {
    out.add((name: LaperlaHeaders.destinationId, value: params.destinationId));
  }

  final cookie = _cookieHeader(params);
  if (cookie.isNotEmpty) {
    out.add((name: LaperlaHeaders.cookie, value: cookie));
  }
  return out;
}

String _cookieHeader(GeneralParams params) {
  final parts = <String>[];
  if (params.sessionToken.isNotEmpty) {
    parts.add('${LaperlaCookies.accessToken}=${params.sessionToken}');
  }
  if (params.clientId.isNotEmpty) {
    parts.add('${LaperlaCookies.clientId}=${params.clientId}');
  }
  return parts.join('; ');
}

/// Connect `-Bin` headers: standard base64 (padding optional on decode).
String encodeConnectBin(List<int> bytes) => base64Encode(bytes);

List<int>? decodeConnectBin(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  try {
    return base64Decode(value);
  } on FormatException {
    try {
      return base64Url.decode(value);
    } on FormatException {
      return null;
    }
  }
}
