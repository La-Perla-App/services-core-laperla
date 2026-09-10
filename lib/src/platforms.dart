/// Values the Go core accepts on `X-Platform` (`backend-core` catalogs).
abstract final class LaperlaPlatform {
  static const android = 'android';
  static const ios = 'ios';
  static const web = 'web';
  static const unknown = 'unknown';
}

/// Cookie / header names that must match the Go core.
abstract final class LaperlaHeaders {
  static const authorization = 'authorization';
  static const acceptLanguage = 'accept-language';
  static const timezone = 'x-timezone';
  static const platform = 'x-platform';
  static const clientVersion = 'x-client-version';
  static const clientId = 'x-client-id';
  static const destinationId = 'x-destination-id';
  static const generalParamsBin = 'general-params-bin';
  static const responseInfoBin = 'response-info-bin';
  static const cookie = 'cookie';
}

abstract final class LaperlaCookies {
  static const accessToken = 'laperla-access-token';
  static const clientId = 'laperla-client-id';
}

abstract final class LaperlaLang {
  static const es = 'es';
  static const en = 'en';
  static const supported = [es, en];
}

/// Default IANA zone: Caracas, Venezuela.
abstract final class LaperlaTimezone {
  static const caracas = 'America/Caracas';
}
