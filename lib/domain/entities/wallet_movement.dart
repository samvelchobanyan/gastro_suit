import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_movement.freezed.dart';

/// Which way money moved through the wallet.
enum WalletMovementKind {
  /// Into the wallet.
  topUp,

  /// Out of it, towards an order.
  spend,
}

/// Money that moved into or out of the user's wallet.
@freezed
abstract class WalletMovement with _$WalletMovement {
  const factory WalletMovement({
    required String id,
    required WalletMovementKind kind,

    /// How much moved, always positive.
    required int amount,

    /// When the user made it.
    required DateTime at,
  }) = _WalletMovement;
}
