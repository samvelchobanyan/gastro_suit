import '../entities/wallet.dart';

/// The signed-in user's wallet. Throws only `AppException`.
abstract interface class WalletRepository {
  /// The user's wallet at the organisation [restaurantId].
  Future<Wallet> getWallet({required String restaurantId});
}
