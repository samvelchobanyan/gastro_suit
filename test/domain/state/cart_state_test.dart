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
  Future<Cart> changeLine(
    String lineId, {
    required ProductChoice choice,
    required int quantity,
    required ContentLanguage language,
  }) async {
    if (error case final error?) throw error;
    final cart = stored!;
    return stored = _with(cart.branchId, [
      for (final line in cart.lines)
        line.id == lineId
            ? line.copyWith(
                choice: choice,
                quantity: quantity,
                total: line.unitPrice * quantity,
              )
            : line,
    ]);
  }

  @override
  Future<Cart> removeLine(String lineId, {required ContentLanguage language}) =>
      setQuantity(lineId, quantity: 0, language: language);

  /// Every branch the cart was moved to.
  final moved = <String>[];

  @override
  Future<Cart> moveTo({
    required String branchId,
    required ContentLanguage language,
  }) async {
    if (error case final error?) throw error;
    moved.add(branchId);
    return stored = _with(branchId, stored?.lines ?? const []);
  }

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

  test('moving takes the cart to the new active branch', () async {
    final (container, repository) = setUp();
    await container.read(cartProvider.future);
    final controller = container.read(cartProvider.notifier);
    await controller.add(branchId: 'b1', choice: latte, quantity: 2);

    await controller.moveTo('b2');

    expect(repository.moved, ['b2']);
    expect(container.read(branchPickProvider), 'b2');
    final cart = await container.read(cartProvider.future);
    expect(cart?.branchId, 'b2');
    expect(cart?.itemCount, 2);
  });

  test('an empty cart is not moved: only the branch changes', () async {
    final (container, repository) = setUp();
    await container.read(cartProvider.future);

    await container.read(cartProvider.notifier).moveTo('b2');

    expect(repository.moved, isEmpty);
    expect(container.read(branchPickProvider), 'b2');
  });

  test('a guest changes the branch without a cart', () async {
    final (container, repository) = setUp(auth: AuthStatus.signedOut);
    await container.read(cartProvider.future);

    await container.read(cartProvider.notifier).moveTo('b2');

    expect(repository.moved, isEmpty);
    expect(container.read(branchPickProvider), 'b2');
  });

  test('a refused move throws and keeps the cart and the branch', () async {
    final (container, repository) = setUp();
    await container.read(cartProvider.future);
    final controller = container.read(cartProvider.notifier);
    await controller.add(branchId: 'b1', choice: latte);
    repository.error = const AppException(
      AppExceptionKind.server,
      code: 'location_not_found',
    );

    await expectLater(controller.moveTo('b2'), throwsA(isA<AppException>()));

    expect(container.read(branchPickProvider), isNull);
    expect(container.read(cartProvider).value?.branchId, 'b1');
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

  test('a line takes a new choice and quantity', () async {
    final (container, repository) = setUp();
    await container.read(cartProvider.future);
    final controller = container.read(cartProvider.notifier);
    await controller.add(branchId: 'b1', choice: latte);
    final lineId = container.read(cartProvider).value!.lines.single.id;
    const large = ProductChoice(
      productId: 'latte',
      productName: 'Latte',
      size: ChosenSize(id: 'l', name: 'Large'),
      options: [],
    );

    await controller.changeLine(lineId, choice: large, quantity: 3);

    final line = container.read(cartProvider).value!.lines.single;
    expect(line.id, lineId);
    expect(line.choice, large);
    expect(line.quantity, 3);

    // A refused change throws and leaves the line as it was.
    repository.error = const AppException(
      AppExceptionKind.server,
      code: 'option_quantity_too_many',
    );
    await expectLater(
      controller.changeLine(lineId, choice: latte, quantity: 1),
      throwsA(isA<AppException>()),
    );
    expect(container.read(cartProvider).value!.lines.single.choice, large);
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

  test('taking one piece of a product takes it from its last line', () async {
    final (container, _) = setUp();
    await container.read(cartProvider.future);
    final controller = container.read(cartProvider.notifier);
    const muffin = ProductChoice(
      productId: 'muffin',
      productName: 'Muffin',
      options: [],
    );
    final large = latte.copyWith(
      size: const ChosenSize(id: 'large', name: 'Large'),
    );
    await controller.add(branchId: 'b1', choice: latte, quantity: 2);
    await controller.add(branchId: 'b1', choice: muffin);
    await controller.add(branchId: 'b1', choice: large, quantity: 2);
    Map<String, int> quantities() =>
        container.read(cartQuantitiesProvider('b1'));
    List<(ProductChoice, int)> lines() => [
      for (final line in container.read(cartProvider).value!.lines)
        (line.choice, line.quantity),
    ];
    expect(quantities(), {'latte': 4, 'muffin': 1});
    // The cart is at b1: the menu of another branch counts nothing.
    expect(container.read(cartQuantitiesProvider('b2')), isEmpty);

    await controller.removeOne('latte');
    expect(lines(), [(latte, 2), (muffin, 1), (large, 1)]);

    // Its only piece: the line goes.
    await controller.removeOne('latte');
    expect(lines(), [(latte, 2), (muffin, 1)]);

    await controller.removeOne('latte');
    expect(lines(), [(latte, 1), (muffin, 1)]);
    expect(quantities(), {'latte': 1, 'muffin': 1});

    // Not in the cart: nothing happens.
    await controller.removeOne('tea');
    expect(lines(), [(latte, 1), (muffin, 1)]);
  });

  test('a change is on its way until the server has answered, refused '
      'or not', () async {
    final (container, repository) = setUp();
    await container.read(cartProvider.future);
    final controller = container.read(cartProvider.notifier);
    expect(controller.isChanging, isFalse);

    final adding = controller.add(branchId: 'b1', choice: latte);
    expect(controller.isChanging, isTrue);
    await adding;
    expect(controller.isChanging, isFalse);

    final taking = controller.removeOne('latte');
    expect(controller.isChanging, isTrue);
    await taking;
    expect(controller.isChanging, isFalse);

    repository.error = const AppException(AppExceptionKind.server);
    final refused = controller.add(branchId: 'b1', choice: latte);
    expect(controller.isChanging, isTrue);
    await expectLater(refused, throwsA(isA<AppException>()));
    expect(controller.isChanging, isFalse);
  });
}
