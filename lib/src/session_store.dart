/// Persist the access token. Flutter: `flutter_secure_storage`.
/// Tests / CLI: [MemorySessionStore].
abstract class SessionStore {
  Future<String?> readToken();

  Future<void> writeToken(String token);

  Future<void> clear();
}

class MemorySessionStore implements SessionStore {
  String? _token;

  @override
  Future<String?> readToken() async => _token;

  @override
  Future<void> writeToken(String token) async => _token = token;

  @override
  Future<void> clear() async => _token = null;
}
