/// Copy into the Flutter app. This package stays pure Dart (no Flutter SDK).
///
/// ```yaml
/// dependencies:
///   flutter_secure_storage: ^9.2.2
/// ```
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laperla_services_core/laperla_services_core.dart';

class FlutterSecureSessionStore implements SessionStore {
  FlutterSecureSessionStore({
    FlutterSecureStorage? storage,
    this.tokenKey = 'laperla.session_token',
  }) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  final String tokenKey;

  @override
  Future<String?> readToken() => _storage.read(key: tokenKey);

  @override
  Future<void> writeToken(String token) =>
      _storage.write(key: tokenKey, value: token);

  @override
  Future<void> clear() => _storage.delete(key: tokenKey);
}
