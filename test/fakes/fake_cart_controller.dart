import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastro_suit/domain/entities/cart.dart';
import 'package:gastro_suit/domain/entities/product_choice.dart';
import 'package:gastro_suit/domain/state/cart_state.dart';

/// A cart that lives in memory: starts as [initial] and records what is
/// added instead of asking a server.
class FakeCartController extends CartController {
  FakeCartController([this.initial]);

  final Cart? initial;

  /// Every add: branch, choice, quantity.
  final added = <(String, ProductChoice, int)>[];

  /// Thrown by the next adds when set.
  Object? addError;

  /// How many times the cart was cleared.
  int cleared = 0;

  @override
  Future<Cart?> build() async => initial;

  @override
  Future<void> add({
    required String branchId,
    required ProductChoice choice,
    int quantity = 1,
  }) async {
    if (addError case final error?) throw error;
    added.add((branchId, choice, quantity));
    // As the server does: a cart of another branch is replaced.
    final current = state.value;
    final kept = current != null && current.branchId == branchId
        ? current.lines
        : const <CartLine>[];
    state = AsyncData(
      Cart(
        id: 'cart',
        branchId: branchId,
        total: 0,
        lines: [
          ...kept,
          CartLine(
            id: 'line-${added.length}',
            choice: choice,
            quantity: quantity,
            unitPrice: 0,
            total: 0,
            isAvailable: true,
          ),
        ],
      ),
    );
  }

  /// Every change of a line's quantity: line, quantity.
  final quantities = <(String, int)>[];

  /// Every removed line.
  final removed = <String>[];

  /// Thrown by the next changes of a line when set.
  Object? changeError;

  @override
  Future<void> setQuantity(String lineId, int quantity) async {
    if (changeError case final error?) throw error;
    quantities.add((lineId, quantity));
    _replaceLines([
      for (final line in state.value!.lines)
        line.id == lineId
            ? line.copyWith(
                quantity: quantity,
                total: line.unitPrice * quantity,
              )
            : line,
    ]);
  }

  @override
  Future<void> removeLine(String lineId) async {
    if (changeError case final error?) throw error;
    removed.add(lineId);
    _replaceLines([
      for (final line in state.value!.lines)
        if (line.id != lineId) line,
    ]);
  }

  void _replaceLines(List<CartLine> lines) {
    state = AsyncData(
      state.value!.copyWith(
        lines: lines,
        total: lines.fold(0, (sum, line) => sum + line.total),
      ),
    );
  }

  @override
  Future<void> clear() async {
    final current = state.value;
    if (current == null) return;
    cleared++;
    state = AsyncData(
      Cart(branchId: current.branchId, lines: const [], total: 0),
    );
  }
}

/// A cart with one line of [quantity] pieces at [branchId].
Cart cartAt(String branchId, {int quantity = 1, int total = 1000}) => Cart(
  id: 'cart',
  branchId: branchId,
  total: total,
  lines: [
    CartLine(
      id: 'line-0',
      choice: const ProductChoice(
        productId: 'other',
        productName: 'Other',
        options: [],
      ),
      quantity: quantity,
      unitPrice: total ~/ quantity,
      total: total,
      isAvailable: true,
    ),
  ],
);
