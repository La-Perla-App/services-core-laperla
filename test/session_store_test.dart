import 'package:laperla_services_core/laperla_services_core.dart';
import 'package:test/test.dart';

void main() {
  test('MemorySessionStore round-trip', () async {
    final store = MemorySessionStore();
    expect(await store.readToken(), isNull);
    await store.writeToken('abc');
    expect(await store.readToken(), 'abc');
    await store.clear();
    expect(await store.readToken(), isNull);
  });

  test('copyWith keeps destination and swaps token', () {
    const base = GeneralParams(
      lang: 'es',
      destinationId: 'dest-1',
      platform: LaperlaPlatform.web,
    );
    final next = base.copyWith(sessionToken: 't');
    expect(next.destinationId, 'dest-1');
    expect(next.sessionToken, 't');
    expect(next.lang, 'es');
  });
}
