import 'dart:convert';

import 'package:laperla_services_core/laperla_services_core.dart';
import 'package:test/test.dart';

void main() {
  test('GeneralParams headers match the Go core contract', () {
    const params = GeneralParams(
      sessionToken: 'jwt-1',
      lang: 'es',
      clientId: 'c1',
      ianaTimezone: 'America/Caracas',
      platform: LaperlaPlatform.ios,
      clientVersion: '1.2.3',
      destinationId: 'dest-marga',
    );

    final map = {
      for (final e in generalParamsHeaderPairs(params)) e.name: e.value,
    };

    expect(map[LaperlaHeaders.authorization], 'Bearer jwt-1');
    expect(map[LaperlaHeaders.acceptLanguage], 'es');
    expect(map[LaperlaHeaders.timezone], 'America/Caracas');
    expect(map[LaperlaHeaders.platform], 'ios');
    expect(map[LaperlaHeaders.clientVersion], '1.2.3');
    expect(map[LaperlaHeaders.clientId], 'c1');
    expect(map[LaperlaHeaders.destinationId], 'dest-marga');
    expect(
      map[LaperlaHeaders.cookie],
      'laperla-access-token=jwt-1; laperla-client-id=c1',
    );

    final bin = jsonDecode(
      utf8.decode(decodeConnectBin(map[LaperlaHeaders.generalParamsBin])!),
    ) as Map<String, dynamic>;
    expect(bin['SessionToken'], 'jwt-1');
    expect(bin['Lang'], 'es');
    expect(bin['ClientId'], 'c1');
    expect(bin['IANATimezone'], 'America/Caracas');
    expect(bin['Platform'], 'ios');
    expect(bin['ClientVersion'], '1.2.3');
    expect(bin['DestinationId'], 'dest-marga');
  });

  test('anonymous call omits Authorization and cookie', () {
    const params = GeneralParams(lang: 'en', platform: LaperlaPlatform.android);
    final names = generalParamsHeaderPairs(params).map((e) => e.name).toSet();
    expect(names.contains(LaperlaHeaders.authorization), isFalse);
    expect(names.contains(LaperlaHeaders.cookie), isFalse);
  });
}
