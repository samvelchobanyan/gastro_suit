import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/network/app_exception.dart';
import '../../../design_system/components/buttons/ds_button.dart';
import '../../../design_system/components/inputs/ds_stepper.dart';
import '../../../design_system/components/overlays/ds_tall_sheet.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/state/cart_state.dart';
import '../../../domain/state/menu_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/login_screen/login_screen.dart';
import '../../cart/replace_cart_dialog/replace_cart_dialog.dart';
import '../../shared_widgets/error_text.dart';
import '../../shared_widgets/price_text.dart';
import 'product_selection_controller.dart';
import 'widgets/product_option_group.dart';
import 'widgets/product_sheet_photo.dart';
import 'widgets/product_size_row.dart';

/// Opens [productId] as [branchId] offers it, in a sheet over the whole
/// app that leaves only a strip of the screen above it.
///
/// The product is read from the branch's menu, which whoever opens the
/// sheet already shows.
Future<void> showProduct(
  BuildContext context, {
  required String branchId,
  required String productId,
}) => showDSTallSheet<void>(
  context: context,
  builder: (context, scroll) => ProductSheet(
    branchId: branchId,
    productId: productId,
    scrollController: scroll,
  ),
);

/// The plus on a product's card: adds the product to the cart as its sheet
/// would open it (the default size, the pre-selected options, one piece).
/// When that cannot be added as it is (a required group has nothing
/// chosen), the sheet is opened for the user to choose.
///
/// A failed add is said in a snack bar: the card has no place for it.
Future<void> quickAddProduct(
  BuildContext context,
  WidgetRef ref, {
  required String branchId,
  required Product product,
}) async {
  final provider = productSelectionProvider(product);
  if (!ref.read(provider).isComplete) {
    return showProduct(context, branchId: branchId, productId: product.id);
  }
  final choice = ref.read(provider.notifier).choice;
  if (!await ensureSignedIn(context, ref)) return;
  if (!context.mounted) return;
  if (!await confirmReplaceCart(context, ref, branchId: branchId)) return;
  try {
    await ref
        .read(cartProvider.notifier)
        .add(branchId: branchId, choice: choice);
  } on AppException catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(errorText(context, error))));
  }
}

/// A product with what can be chosen for it (handoff `ProductOverlay`):
/// its photo, name, price and description, the sizes and the groups of
/// options, all scrolling; the quantity and the add button stay at the
/// bottom.
///
/// Opened with [showProduct], in a `showDSTallSheet`.
class ProductSheet extends ConsumerWidget {
  const ProductSheet({
    super.key,
    required this.branchId,
    required this.productId,
    required this.scrollController,
  });

  final String branchId;
  final String productId;

  /// The tall sheet's: the content scrolls with it.
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(menuProvider(branchId));
    final product = menu.value?.product(productId);
    return product != null
        ? _ProductContent(
            branchId: branchId,
            product: product,
            scrollController: scrollController,
          )
        : _NoProduct(loading: menu.isLoading);
  }
}

/// Shown when the menu has no such product: it is still loading, failed to
/// load, or the branch no longer offers the product.
class _NoProduct extends StatelessWidget {
  const _NoProduct({required this.loading});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: loading
          ? CircularProgressIndicator(color: colors.brandPrimary)
          : Padding(
              padding: const EdgeInsets.all(DSSpacing.base),
              child: Text(
                AppLocalizations.of(context).errorGeneric,
                textAlign: TextAlign.center,
                style: DSTypography.body.copyWith(color: colors.textSecondary),
              ),
            ),
    );
  }
}

class _ProductContent extends ConsumerStatefulWidget {
  const _ProductContent({
    required this.branchId,
    required this.product,
    required this.scrollController,
  });

  final String branchId;
  final Product product;
  final ScrollController scrollController;

  @override
  ConsumerState<_ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends ConsumerState<_ProductContent> {
  /// The add request is under way.
  var _adding = false;

  /// Why the last add was not accepted; null once the user tries again.
  String? _addError;

  /// Adds the selection to the cart and closes the sheet. A failed add
  /// leaves the sheet open with the selection and says why.
  Future<void> _add() async {
    final provider = productSelectionProvider(widget.product);
    final choice = ref.read(provider.notifier).choice;
    final quantity = ref.read(provider).quantity;
    setState(() => _addError = null);
    if (!await ensureSignedIn(context, ref)) return;
    if (!mounted) return;
    if (!await confirmReplaceCart(context, ref, branchId: widget.branchId)) {
      return;
    }
    if (!mounted) return;
    setState(() => _adding = true);
    try {
      await ref
          .read(cartProvider.notifier)
          .add(branchId: widget.branchId, choice: choice, quantity: quantity);
      if (mounted) Navigator.pop(context);
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() {
        _adding = false;
        _addError = errorText(context, error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final product = widget.product;
    final scrollController = widget.scrollController;
    final selection = ref.watch(productSelectionProvider(product));
    final controller = ref.read(productSelectionProvider(product).notifier);
    final description = product.description;
    // The API has one portion per product, not per size: with sizes it
    // would not follow the chosen one, so it is left out.
    final portion = product.sizes.isEmpty ? product.portion : null;
    final size = product.sizes
        .where((s) => s.id == selection.sizeId)
        .firstOrNull;
    final hasMore =
        description != null ||
        product.sizes.isNotEmpty ||
        product.optionGroups.isNotEmpty;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProductSheetPhoto(url: product.imageUrl),
                Padding(
                  padding: const EdgeInsets.all(DSSpacing.base),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        product.name,
                        style: DSTypography.h2.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: DSSpacing.xs),
                      Row(
                        children: [
                          Text(
                            formatPrice(context, size?.price ?? product.price),
                            style: DSTypography.h3.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          if (portion != null) ...[
                            const SizedBox(width: DSSpacing.xs),
                            Text(
                              '·',
                              style: DSTypography.h3.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: DSSpacing.xs),
                            Text(
                              _portionText(context, portion),
                              style: DSTypography.bodySm.copyWith(
                                color: colors.textTertiary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (hasMore)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: DSSpacing.base,
                          ),
                          child: ColoredBox(
                            color: colors.borderMuted,
                            child: const SizedBox(
                              height: DSSizes.borderWidthDefault,
                            ),
                          ),
                        ),
                      if (description != null)
                        Text(
                          description,
                          style: DSTypography.body.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                      if (product.sizes.isNotEmpty) ...[
                        if (description != null)
                          const SizedBox(height: DSSpacing.base),
                        ProductSizeRow(
                          sizes: product.sizes,
                          selectedId: selection.sizeId,
                          onSelected: (size) => controller.selectSize(size.id),
                        ),
                      ],
                      for (final (i, group) in product.optionGroups.indexed)
                        Padding(
                          // Nothing to stand off from when the groups come
                          // first under the line.
                          padding: EdgeInsets.only(
                            top:
                                i == 0 &&
                                    description == null &&
                                    product.sizes.isEmpty
                                ? 0
                                : DSSpacing.lg,
                          ),
                          child: ProductOptionGroupSection(
                            group: group,
                            selectedIds: selection.optionIds,
                            onToggle: (option) =>
                                controller.toggleOption(group.id, option.id),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _AddBar(
          selection: selection,
          onQuantityChanged: controller.setQuantity,
          adding: _adding,
          error: _addError,
          onAdd: _add,
        ),
      ],
    );
  }
}

/// The bar under the scrolling content: how many, and the add button with
/// what they cost together.
class _AddBar extends StatelessWidget {
  const _AddBar({
    required this.selection,
    required this.onQuantityChanged,
    required this.adding,
    required this.error,
    required this.onAdd,
  });

  final ProductSelection selection;
  final ValueChanged<int> onQuantityChanged;

  /// The add request is under way: the button shows it and the quantity
  /// takes no taps.
  final bool adding;

  /// Why the last add was not accepted, shown over the controls.
  final String? error;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.bgSurface,
        border: Border(
          top: BorderSide(
            color: colors.borderMuted,
            width: DSSizes.borderWidthDefault,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          DSSpacing.base,
          DSSpacing.base,
          DSSpacing.base,
          DSSpacing.base + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (error case final error?) ...[
              Text(
                error,
                style: DSTypography.bodySm.copyWith(color: colors.textError),
              ),
              const SizedBox(height: DSSpacing.sm),
            ],
            Row(
              children: [
                IgnorePointer(
                  ignoring: adding,
                  child: DSStepper(
                    size: DSStepperSize.md,
                    value: selection.quantity,
                    min: 1,
                    max: ProductSelectionController.maxQuantity,
                    onChanged: onQuantityChanged,
                    decreaseLabel: l10n.quantityDecrease,
                    increaseLabel: l10n.quantityIncrease,
                  ),
                ),
                const SizedBox(width: DSSpacing.sm),
                Expanded(
                  child: DSButton(
                    label: l10n.addWithTotal(
                      formatPrice(context, selection.total),
                    ),
                    icon: PhosphorIcons.shoppingCartSimple(),
                    size: DSButtonSize.sm,
                    fullWidth: true,
                    loading: adding,
                    onPressed: selection.isComplete ? onAdd : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A portion as shown next to the price: "300 ml".
String _portionText(BuildContext context, Portion portion) {
  final l10n = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context).toLanguageTag();
  final amount = NumberFormat.decimalPattern(locale).format(portion.amount);
  return switch (portion.unit) {
    PortionUnit.gram => l10n.portionGrams(amount),
    PortionUnit.kilogram => l10n.portionKilograms(amount),
    PortionUnit.milliliter => l10n.portionMilliliters(amount),
    PortionUnit.liter => l10n.portionLiters(amount),
  };
}
