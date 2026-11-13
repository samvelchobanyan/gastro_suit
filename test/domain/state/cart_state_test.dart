import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/auth/auth_status.dart';
import 'package:gastro_suit/core/di/repositories.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/core/network/app_exception.dart';
import 'package:gastro_suit/domain/entities/branch.dart';
import 'package:gastro_suit/domain/entities/cart.dart';
import 'package:gastro_suit/domain/entities/product_choice.dart';
import 'package:gastro_suit/domain/repositories/cart_repository.dart';
import 'package:gastro_suit/domain/state/active_branch_state.dart';
import 'package:gastro_suit/domain/state/cart_state.dart';
import 'package:gastro_suit/domain/state/server_config_state.dart';

/// A server that keeps one cart, tied to one branch.
class _FakeRepository implements CartRepository {
  Cart? stored;
  Object? error;
  final asked = <String>[];

  Cart _empty(String branchId) =>
      Cart(branchId: branchId, lines: const [], total: 0);

  Cart _with(String branchId, List<CartLine> lines) => Cart(
    id: 'cart',
    branchId: branchId,
    lines: lines,
    total: lines.fold(0, (sum, line) => sum + line.total),
  );

  @override
  Future<Cart> getCart({
    required String branchId,
    required ContentLanguage language,
  }) async {
    asked.add(branchId);
    if (error case final error?) throw error;
    final cart = stored;
    return cart != null && cart.branchId == branchId ? cart : _empty(branchId);
  }

  @override
  Future<Cart> addItem({
    required String branchId,
    required ProductChoice choice,
    required int quantity,
    required ContentLanguage language,
  }) async {
    if (error case final error?) throw error;
    final cart = stored;
    final kept = cart != null && cart.branchId == branchId
        ? cart.lines
        : const <CartLine>[];
    return stored = _with(branchId, [
      ...kept,
      CartLine(
        id: 'line-${kept.length + 1}',
        choice: choice,
        quantity: quantity,
        unitPrice: 1000,
        total: 1000 * quantity,
        isAvailable: true,
      ),
    ]);
  }

  @override
  Future<Cart> setQuantity(
    String lineId, {
    required int quantity,
    required ContentLanguage language,
  }) async {
    final cart = stored!;
    return stored = _with(cart.branchId, [
      for (final line in cart.lines)
        if (line.id != lineId)
          line
        else if (quantity > 0)
          line.copyWith(quantity: quantity, total: line.unitPrice * quantity),
    ]);
  }

  @override
  Future<Cart> removeLine(String lineId, {required ContentLanguage language}) =>
      setQuantity(lineId, quantity: 0, language: language);

  @override
  Future<Cart> clear({
    required String branchId,
    required ContentLanguage language,
  }) async => stored = _empty(branchId);
}

void main() {
  const latte = ProductChoice(
    productId: 'latte',
    productName: 'Latte',
    options: [],
  );

  Branch branch(String id) =>
      Branch(id: id, name: id, address: '', isTemporarilyClosed: false);

  /// The cart of a user whose active branch is `b1` unless they pick
  /// another.
  (ProviderContainer, _FakeRepository) setUp({
    AuthStatus auth = AuthStatus.signedIn,
  }) {
    final repository = _FakeRepository();
    final container = ProviderContainer(
      overrides: [
        authStatusProvider.overrideWithValue(auth),
        cartRepositoryProvider.overrideWithValue(repository),
        contentLanguageProvider.overrideWith(
          (ref) async => const ContentLanguage(current: 'en'),
        ),
        activeBranchProvider.overrideWith(
          (ref) async => branch(ref.watch(branchPickProvider) ?? 'b1'),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(cartProvider, (_, _) {});
    return (container, repository);
  }

  test('a guest has no cart, and the server is not asked', () async {
    final (container, repository) = setUp(auth: AuthStatus.signedOut);

    expect(await container.read(cartProvider.future), isNull);
    expect(repository.asked, isEmpty);
  });

  test('a signed-in user gets the cart of the active branch', () async {
    final (container, repository) = setUp();

    final cart = await container.read(cartProvider.future);

    expect(cart?.branchId, 'b1');
    expect(cart?.isEmpty, isTrue);
    expect(repository.asked, ['b1']);
  });

  test('adding puts the cart the server answers with in place', () async {
    final (container, _) = setUp();
    await container.read(cartProvider.future);

    await container
        .read(cartProvider.notifier)
        .add(branchId: 'b1', choice: latte, quantity: 2);

    final cart = container.read(cartProvider).value!;
    expect(cart.itemCount, 2);
    expect(cart.total, 2000);
    expect(cart.lines.single.choice, latte);
    // The branch was the active one already: nothing to pick.
    expect(container.read(branchPickProvider), isNull);
  });

  test('adding at another branch makes it the active one', () async {
    final (container, repository) = setUp();
    await container.read(cartProvider.future);
    await container
        .read(cartProvider.notifier)
        .add(branchId: 'b1', choice: latte);

    await container
        .read(cartProvider.notifier)
        .add(branchId: 'b2', choice: latte);

    expect(container.read(branchPickProvider), 'b2');
    // Loaded again for the new active branch: the one product added there.
    final cart = await container.read(cartProvider.future);
    expect(cart?.branchId, 'b2');
    expect(cart?.itemCount, 1);
    expect(repository.asked.last, 'b2');
  });

  test('a refused add throws and leaves the cart as it was', () async {
    final (container, repository) = setUp();
    await container.read(cartProvider.future);
    await container
        .read(cartProvider.notifier)
        .add(branchId: 'b1', choice: latte);
    repository.error = const AppException(
      AppExceptionKind.server,
      code: 'item_unavailable',
    );

    await expectLater(
      container.read(cartProvider.notifier).add(branchId: 'b1', choice: latte),
      throwsA(isA<AppException>()),
    );

    expect(container.read(cartProvider).value?.itemCount, 1);
  });

  test('the quantity of a line changes, and zero removes the line', () async {
    final (container, _) = setUp();
    await container.read(cartProvider.future);
    final controller = container.read(cartProvider.notifier);
    await controller.add(branchId: 'b1', choice: latte);
    final lineId = container.read(cartProvider).value!.lines.single.id;

    await controller.setQuantity(lineId, 3);
    expect(container.read(cartProvider).value?.itemCount, 3);
    expect(container.read(cartProvider).value?.total, 3000);

    await controller.setQuantity(lineId, 0);
    expect(container.read(cartProvider).value?.isEmpty, isTrue);
  });

  test('removing a line and clearing empty the cart', () async {
    final (container, _) = setUp();
    await container.read(cartProvider.future);
    final controller = container.read(cartProvider.notifier);
    await controller.add(branchId: 'b1', choice: latte);
    await controller.removeLine(
      container.read(cartProvider).value!.lines.single.id,
    );
    expect(container.read(cartProvider).value?.isEmpty, isTrue);

    await controller.add(branchId: 'b1', choice: latte);
    await controller.clear();
    expect(container.read(cartProvider).value?.isEmpty, isTrue);
    expect(container.read(cartProvider).value?.branchId, 'b1');
  });
}
