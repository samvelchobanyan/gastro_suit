import 'package:gastro_suit/core/config/server_config.dart';
import 'package:gastro_suit/domain/entities/loyalty_card.dart';
import 'package:gastro_suit/domain/entities/wallet.dart';
import 'package:gastro_suit/domain/entities/wallet_movement.dart';
import 'package:gastro_suit/domain/repositories/loyalty_repository.dart';
import 'package:gastro_suit/domain/repositories/server_config_repository.dart';
import 'package:gastro_suit/domain/repositories/wallet_repository.dart';

/// An instance with the loyalty programme and the wallet on or off.
class FakeServerConfigRepository implements ServerConfigRepository {
  FakeServerConfigRepository({this.loyalty = true, this.wallet = true});

  final bool loyalty;
  final bool wallet;

  @override
  Future<ServerConfig> getConfig() async => ServerConfig(
    defaultLanguage: 'en',
    loyaltyEnabled: loyalty,
    walletEnabled: wallet,
    minTopUp: 500,
    maxTopUp: 500000,
  );
}

/// The user's loyalty [card].
class FakeLoyaltyRepository implements LoyaltyRepository {
  FakeLoyaltyRepository(this.card);

  LoyaltyCard card;

  /// How many times the card was read.
  var reads = 0;

  /// Thrown by the next reads when set.
  Object? error;

  @override
  Future<LoyaltyCard> getCard({required String restaurantId}) async {
    reads++;
    if (error case final error?) throw error;
    return card;
  }
}

/// The user's [wallet].
class FakeWalletRepository implements WalletRepository {
  FakeWalletRepository(this.wallet);

  Wallet wallet;

  /// How many times the wallet was read.
  var reads = 0;

  /// Thrown by the next reads when set.
  Object? error;

  @override
  Future<Wallet> getWallet({required String restaurantId}) async {
    reads++;
    if (error case final error?) throw error;
    return wallet;
  }

  /// What moved through the wallet; [getMovements] answers with it.
  var movements = <WalletMovement>[];

  @override
  Future<List<WalletMovement>> getMovements({
    required String restaurantId,
  }) async {
    if (error case final error?) throw error;
    return movements;
  }

  /// Every amount the wallet was topped up by.
  final toppedUp = <int>[];

  /// Whether a top-up comes back done; false for one left to be paid on
  /// the bank's page.
  var topUpDone = true;

  /// Thrown by the next top-ups when set.
  Object? topUpError;

  @override
  Future<bool> topUp(int amount) async {
    if (topUpError case final error?) throw error;
    toppedUp.add(amount);
    if (topUpDone) wallet = wallet.copyWith(total: wallet.total + amount);
    return topUpDone;
  }
}
