import 'platforms.dart';

/// Contraparte cliente de Go `api.GeneralParams` para llamar servicios.
///
/// Sent on every RPC as HTTP headers **and** `General-Params-Bin` (JSON the
/// Go core unmarshals). Extra Flutter-only fields (`destinationId`) go as
/// headers for product services; they are also included in the bin payload
/// so future Go versions can pick them up.
class GeneralParams {
  const GeneralParams({
    this.sessionToken = '',
    this.lang = LaperlaLang.es,
    this.clientId = '',
    this.ianaTimezone = LaperlaTimezone.caracas,
    this.platform = LaperlaPlatform.unknown,
    this.clientVersion = '1.0.0',
    this.destinationId = '',
  });

  /// JWT / cookie `laperla-access-token`. Empty = anonymous call.
  final String sessionToken;

  /// App locale. Server reads `Accept-Language` (`es` / `en`).
  final String lang;

  /// Stable install id. Cookie `laperla-client-id` + `X-Client-Id`.
  final String clientId;

  /// IANA zone for `X-Timezone`. Default: Caracas, Venezuela (`America/Caracas`).
  final String ianaTimezone;

  /// `android` | `ios` | `web`.
  final String platform;

  /// Semver of the app (`X-Client-Version`).
  final String clientVersion;

  /// Published destination the UI is browsing (Margarita, …).
  /// Header `X-Destination-Id`. Not used by auth; used by directory/pass.
  final String destinationId;

  GeneralParams copyWith({
    String? sessionToken,
    String? lang,
    String? clientId,
    String? ianaTimezone,
    String? platform,
    String? clientVersion,
    String? destinationId,
  }) {
    return GeneralParams(
      sessionToken: sessionToken ?? this.sessionToken,
      lang: lang ?? this.lang,
      clientId: clientId ?? this.clientId,
      ianaTimezone: ianaTimezone ?? this.ianaTimezone,
      platform: platform ?? this.platform,
      clientVersion: clientVersion ?? this.clientVersion,
      destinationId: destinationId ?? this.destinationId,
    );
  }

  /// JSON field names match Go `encoding/json` on `api.GeneralParams`
  /// (exported names; no struct tags on those fields).
  Map<String, dynamic> toGoJson() {
    return {
      if (sessionToken.isNotEmpty) 'SessionToken': sessionToken,
      'Lang': lang,
      if (clientId.isNotEmpty) 'ClientId': clientId,
      'IANATimezone': ianaTimezone,
      'Platform': platform,
      'ClientVersion': clientVersion,
      if (destinationId.isNotEmpty) 'DestinationId': destinationId,
    };
  }
}
