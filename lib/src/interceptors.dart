import 'package:connectrpc/connect.dart';

import 'errors.dart';
import 'general_params.dart';
import 'headers.dart';
import 'response_info.dart';
import 'session_store.dart';

/// Injects [GeneralParams] (and the token from [sessionStore], if any).
Interceptor generalParamsInterceptor({
  required GeneralParams Function() params,
  SessionStore? sessionStore,
}) {
  return <I extends Object, O extends Object>(next) {
    return (req) async {
      var current = params();
      if (current.sessionToken.isEmpty && sessionStore != null) {
        final stored = await sessionStore.readToken();
        if (stored != null && stored.isNotEmpty) {
          current = current.copyWith(sessionToken: stored);
        }
      }
      applyGeneralParams(req.headers, current);
      return next(req);
    };
  };
}

/// Persists `sessionToken` from `Response-Info-Bin` and maps Connect errors.
Interceptor sessionAndErrorInterceptor({SessionStore? sessionStore}) {
  return <I extends Object, O extends Object>(next) {
    return (req) async {
      try {
        final res = await next(req);
        final info = ResponseInfo.tryParse(res.headers);
        if (sessionStore != null &&
            info != null &&
            info.sessionToken.isNotEmpty) {
          await sessionStore.writeToken(info.sessionToken);
        }
        return res;
      } on ConnectException catch (e) {
        ResponseInfo? info;
        try {
          info = ResponseInfo.tryParse(e.metadata);
        } catch (_) {}
        throw LaperlaException.fromConnect(e, info: info);
      }
    };
  };
}
