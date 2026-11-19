import 'package:freezed_annotation/freezed_annotation.dart';

part 'buy_again.freezed.dart';

/// Something the user ordered before, ready to be ordered again: a product
/// as it was chosen, at the branch it was ordered from.
///
/// Not tied to an order: the same choice ordered many times at one branch
/// is one of these; another choice or another branch is another. What was
/// chosen stays on the server, which puts it into the cart by [id].
@freezed
abstract class BuyAgainItem with _$BuyAgainItem {
  const factory BuyAgainItem({
    required String id,
    required String name,
    String? imageUrl,
    required String branchId,
    required String branchName,

    /// False: the branch cannot make it now, as it was chosen.
    required bool isAvailable,
  }) = _BuyAgainItem;
}
