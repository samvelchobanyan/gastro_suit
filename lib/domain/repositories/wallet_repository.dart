import '../entities/wallet.dart';
import '../entities/wallet_movement.dart';

/// The signed-in user's wallet. Throws only `AppException`.
abstract interface class WalletRepository {
  /// The user's wallet at the organisation [restaurantId].
  Future<Wallet> getWallet({required String restaurantId});

  /// Adds [amount] to the wallet. True when the money is in; false when it
  /// is still to be paid for on the bank's page, which the app does not
  /// open yet.
  Future<bool> topUp(int amount);

  /// The money that moved through the user's wallet at the organisation
  /// [restaurantId], newest first. Only what did move: a top-up that was
  /// not paid for, or failed, is left out.
  Future<List<WalletMovement>> getMovements({required String restaurantId});
}
