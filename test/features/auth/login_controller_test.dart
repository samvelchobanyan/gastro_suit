import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/domain/repositories/auth_repository.dart';
import 'package:gastro_suit/features/auth/presentation/login/login_controller.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository([this.error]);

  final AppException? error;
  String? lastLogin;

  @override
  Future<void> login({required String login, required String password}) async {
    lastLogin = login;
    if (error case final e?) throw e;
  }

  @override
  Future<void> logout() async {}
}

void main() {
  ProviderContainer containerWith(AuthRepository repository) {
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    // Keep the auto-dispose controller alive, as the screen does.
    container.listen(loginControllerProvider, (_, _) {});
    return container;
  }

  test('signs in and trims the login', () async {
    final repository = FakeAuthRepository();
    final container = containerWith(repository);

    final ok = await container
        .read(loginControllerProvider.notifier)
        .submit(login: '  user@example.test ', password: 'secret');

    expect(ok, isTrue);
    expect(repository.lastLogin, 'user@example.test');
    expect(container.read(loginControllerProvider), isA<AsyncData<void>>());
  });

  test('keeps the server refusal for the screen', () async {
    const refusal = AppException(
      AppExceptionKind.unauthorized,
      code: 'invalid_credentials',
      message: 'Invalid credentials',
    );
    final container = containerWith(FakeAuthRepository(refusal));

    final ok = await container
        .read(loginControllerProvider.notifier)
        .submit(login: 'user', password: 'wrong');

    expect(ok, isFalse);
    expect(container.read(loginControllerProvider).error, refusal);
  });

  test('keeps a connection failure for the screen', () async {
    const offline = AppException(AppExceptionKind.noConnection);
    final container = containerWith(FakeAuthRepository(offline));

    await container
        .read(loginControllerProvider.notifier)
        .submit(login: 'user', password: 'secret');

    expect(container.read(loginControllerProvider).error, offline);
  });
}
