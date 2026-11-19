import 'package:gastro_suit/domain/repositories/auth_repository.dart';

/// A server that signs users in by a code sent to their phone: it takes
/// [code] and refuses any other.
class FakeAuthRepository implements AuthRepository {
  /// The code the server "sent".
  var code = '123456';

  /// Thrown by the next requests for a code when set.
  Object? requestError;

  /// Thrown by the next sign-ins when set, whatever the code.
  Object? signInError;

  /// Every number a code was sent to, in order.
  final requested = <String>[];

  /// Every sign-in that went through: phone, code, organisation.
  final signedIn = <(String, String, String)>[];

  var logouts = 0;

  @override
  Future<void> requestCode(String phone) async {
    if (requestError case final error?) throw error;
    requested.add(phone);
  }

  @override
  Future<void> signInWithCode({
    required String phone,
    required String code,
    required String restaurantId,
  }) async {
    if (signInError case final error?) throw error;
    signedIn.add((phone, code, restaurantId));
  }

  @override
  Future<void> logout() async => logouts++;
}
