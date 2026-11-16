import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/data/dto/loyalty_dto.dart';
import 'package:gastro_suit/data/dto/server_config_dto.dart';
import 'package:gastro_suit/data/dto/wallet_dto.dart';

void main() {
  // As the dev server answers.
  test('a wallet has its parts and what expires next', () {
    final wallet = WalletDto.fromJson({
      'total': 15000,
      'ownTopUp': 10000,
      'giftCard': 5000,
      'promo': 0,
      'expiring': 2000,
      'expiryDate': '2026-12-16T17:23:18.577Z',
    }).toDomain();

    expect(wallet.total, 15000);
    expect(wallet.ownTopUp, 10000);
    expect(wallet.gifts, 5000);
    expect(wallet.expiring, 2000);
    expect(wallet.expiresAt!.isUtc, isFalse);
    expect(
      wallet.expiresAt!.toUtc(),
      DateTime.utc(2026, 12, 16, 17, 23, 18, 577),
    );
  });

  test('a date with nothing to expire is no date', () {
    final wallet = WalletDto.fromJson({
      'total': 3000,
      'ownTopUp': 3000,
      'giftCard': 0,
      'expiring': 0,
      'expiryDate': '2026-12-16T17:23:18.577Z',
    }).toDomain();

    expect(wallet.expiring, 0);
    expect(wallet.expiresAt, isNull);
  });

  test('an empty answer is an empty wallet', () {
    final wallet = WalletDto.fromJson({}).toDomain();

    expect(wallet.total, 0);
    expect(wallet.expiresAt, isNull);
  });

  test('the loyalty balance has the points and the tier\'s name', () {
    final balance = LoyaltyBalanceDto.fromJson({
      'points': 1250,
      'cashback': 500,
      'categories': <Object>[],
      'wallets': <Object>[],
      'tier': 'Mock Rung Two',
    });

    expect(balance.points, 1250);
    expect(balance.tier, 'Mock Rung Two');
  });

  test('the card the cashier scans is its number', () {
    final qr = CounterQrDto.fromJson({
      'qr': 'data:image/png;base64,AAAA',
      'cardNumber': '3805642771084531',
    });

    expect(qr.cardNumber, '3805642771084531');
  });

  test('the instance says which modules it has; unnamed ones are off', () {
    final config = ServerConfigDto.fromJson({
      'modules': {'loyalty': true, 'wallet': false},
    }).toDomain();
    expect(config.loyaltyEnabled, isTrue);
    expect(config.walletEnabled, isFalse);

    final bare = ServerConfigDto.fromJson({}).toDomain();
    expect(bare.loyaltyEnabled, isFalse);
    expect(bare.walletEnabled, isFalse);
  });

  test('the instance says how much a top-up can be', () {
    final config = ServerConfigDto.fromJson({
      'wallet': {'minTopUp': 500, 'maxTopUp': 500000},
    }).toDomain();
    expect(config.minTopUp, 500);
    expect(config.maxTopUp, 500000);

    final bare = ServerConfigDto.fromJson({}).toDomain();
    expect(bare.minTopUp, isNull);
    expect(bare.maxTopUp, isNull);
  });
}
