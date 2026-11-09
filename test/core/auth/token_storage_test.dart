import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/token_storage.dart';

void main() {
  test('a saved pair is read back after a restart', () async {
    FlutterSecureStorage.setMockInitialValues({});
    await TokenStorage().save((access: 'a-1', refresh: 'r-1'));

    final restarted = TokenStorage();
    await restarted.init();

    expect(restarted.accessToken, 'a-1');
    expect(restarted.refreshToken, 'r-1');
  });

  test('a cleared pair is gone after a restart', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final storage = TokenStorage();
    await storage.save((access: 'a-1', refresh: 'r-1'));
    await storage.clear();

    final restarted = TokenStorage();
    await restarted.init();

    expect(restarted.hasSession, isFalse);
  });

  test('an unreadable saved value means no session', () async {
    FlutterSecureStorage.setMockInitialValues({'auth_tokens': 'not json'});

    final storage = TokenStorage();
    await storage.init();

    expect(storage.hasSession, isFalse);
  });
}
