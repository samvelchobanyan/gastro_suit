import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/network/app_exception.dart';
import '../../../design_system/components/buttons/ds_button.dart';
import '../../../design_system/components/inputs/ds_amount_field.dart';
import '../../../design_system/components/inputs/ds_time_picker.dart';
import '../../../design_system/components/inputs/ds_tip_selector.dart';
import '../../../design_system/components/layout/ds_section_header.dart';
import '../../../design_system/components/overlays/ds_tall_sheet.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/cart.dart';
import '../../../domain/state/active_branch_state.dart';
import '../../../domain/state/cart_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../branches/branch_picker_sheet/branch_picker_sheet.dart';
import '../../shared_widgets/error_text.dart';
import '../../shared_widgets/load_error_row.dart';
import '../../shared_widgets/price_text.dart';
import 'cart_checkout_controller.dart';
import 'widgets/cart_line_tile.dart';

/// Opens the cart in a sheet over the whole app.
Future<void> showCart(BuildContext context) => showDSTallSheet<void>(
  context: context,
  builder: (context, scroll) => CartSheet(scrollController: scroll),
);

/// The cart at the active branch (handoff `BasketOverlay`): the branch,
/// when the order is wanted, the products with their quantities, and the
/// tip where the branch takes one; all scrolling over the order button.
///
/// Placing the order is not built yet: the button shows the total and
/// takes no taps. The design's payment method comes with it.
class CartSheet extends ConsumerStatefulWidget {
  const CartSheet({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  ConsumerState<CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends ConsumerState<CartSheet> {
  final _customTip = TextEditingController();

  /// A change of the cart is on its way to the server: the lines take no
  /// taps till it answers.
  var _changing = false;

  /// Why the last change was not accepted.
  String? _error;

  @override
  void dispose() {
    _customTip.dispose();
    super.dispose();
  }

  /// Runs one change of the cart; a failed one leaves the cart as it was
  /// and says why over the order button.
  Future<void> _change(
    Future<void> Function(CartController cart) change,
  ) async {
    setState(() {
      _changing = true;
      _error = null;
    });
    try {
      await change(ref.read(cartProvider.notifier));
      if (mounted) setState(() => _changing = false);
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() {
        _changing = false;
        _error = errorText(context, error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final cartState = ref.watch(cartProvider);
    final cart = cartState.value;
    final branch = ref.watch(activeBranchProvider).value;
    final lines = cart?.lines ?? const <CartLine>[];

    final Widget body;
    if (cartState.hasError && cart == null) {
      body = Padding(
        padding: const EdgeInsets.symmetric(horizontal: DSSpacing.base),
        child: LoadErrorRow(onRetry: () => ref.invalidate(cartProvider)),
      );
    } else if (cartState.isLoading && cart == null) {
      body = Padding(
        padding: const EdgeInsets.all(DSSpacing.xl),
        child: Center(
          child: CircularProgressIndicator(color: colors.brandPrimary),
        ),
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(
            icon: PhosphorIcons.mapPin(),
            title: l10n.cartSectionBranch,
          ),
          if (branch != null)
            _BranchRow(
              name: branch.name,
              onTap: () => showBranchPicker(context),
            ),
          if (lines.isNotEmpty) ...[
            _SectionTitle(
              icon: PhosphorIcons.clock(),
              title: l10n.cartSectionTime,
            ),
            const _TimeRow(),
          ],
          _SectionTitle(
            icon: PhosphorIcons.bag(),
            title: l10n.cartSectionOrder(cart?.itemCount ?? 0),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              DSSpacing.base,
              0,
              DSSpacing.base,
              DSSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (lines.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: DSSpacing.sm),
                    child: Text(
                      l10n.cartEmpty,
                      style: DSTypography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                IgnorePointer(
                  ignoring: _changing,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final line in lines)
                        Padding(
                          padding: const EdgeInsets.only(bottom: DSSpacing.sm),
                          child: CartLineTile(
                            line: line,
                            onQuantityChanged: (quantity) => _change(
                              (cart) => cart.setQuantity(line.id, quantity),
                            ),
                            onRemove: () =>
                                _change((cart) => cart.removeLine(line.id)),
                          ),
                        ),
                    ],
                  ),
                ),
                Center(
                  child: _AddProductsLink(
                    label: l10n.cartAddProducts,
                    // Back to the menu the cart was opened over.
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
          if (lines.isNotEmpty && (branch?.acceptsTips ?? false)) ...[
            _SectionTitle(
              icon: PhosphorIcons.handCoins(),
              title: l10n.cartSectionTip,
            ),
            _TipRow(customTip: _customTip),
          ],
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: DSSpacing.sm),
          child: DSSheetHandle(color: colors.borderStrong),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(DSSpacing.base),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            l10n.cartTitle,
                            style: DSTypography.h1.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        PhosphorIcons.shoppingCartSimple(),
                        size: DSSizes.iconMd,
                        color: colors.textPrimary,
                      ),
                    ],
                  ),
                ),
                body,
              ],
            ),
          ),
        ),
        _OrderBar(total: cart?.total ?? 0, error: _error),
      ],
    );
  }
}

/// The title of a part of the cart: an icon on a small tile and the name
/// in capitals.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DSSpacing.base,
        0,
        DSSpacing.base,
        DSSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: DSSizes.buttonHeightXxs,
            height: DSSizes.buttonHeightXxs,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.bgCanvas,
              borderRadius: BorderRadius.circular(DSRadius.sm),
            ),
            child: Icon(icon, size: DSSizes.iconSm, color: colors.textPrimary),
          ),
          const SizedBox(width: DSSpacing.sm),
          Expanded(child: DSSectionHeader(title: title.toUpperCase())),
        ],
      ),
    );
  }
}

/// The branch the order is for; a tap opens the branch picker.
class _BranchRow extends StatelessWidget {
  const _BranchRow({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            DSSpacing.base,
            0,
            DSSpacing.base,
            DSSpacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: DSTypography.body.copyWith(color: colors.textPrimary),
                ),
              ),
              const SizedBox(width: DSSpacing.sm),
              Icon(
                PhosphorIcons.caretDown(),
                size: DSSizes.iconSm,
                color: colors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "As soon as possible" and the times after it, in a row that scrolls
/// sideways.
class _TimeRow extends ConsumerWidget {
  const _TimeRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final checkout = ref.watch(cartCheckoutProvider);
    final format = DateFormat.Hm(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        DSSpacing.base,
        0,
        DSSpacing.base,
        DSSpacing.lg,
      ),
      child: DSTimePicker<DateTime?>(
        slots: [
          DSTimeSlot(value: null, label: l10n.cartTimeAsap),
          for (final time in checkout.slots)
            DSTimeSlot(value: time, label: format.format(time)),
        ],
        value: checkout.time,
        onChanged: ref.read(cartCheckoutProvider.notifier).selectTime,
      ),
    );
  }
}

/// No tip, the offered amounts and "other", in a row that scrolls
/// sideways; under it the field for an amount of the user's own.
class _TipRow extends ConsumerWidget {
  const _TipRow({required this.customTip});

  final TextEditingController customTip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final checkout = ref.watch(cartCheckoutProvider);
    final controller = ref.read(cartCheckoutProvider.notifier);
    // The sign after the amount, as the design writes a tip: "100֏".
    final currency = formatPrice(context, 0).replaceAll('0', '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(
            DSSpacing.base,
            0,
            DSSpacing.base,
            DSSpacing.lg,
          ),
          child: Row(
            children: [
              DSTipSelector(
                label: l10n.cartTipNone,
                selected: !checkout.isCustomTip && checkout.tip == 0,
                onTap: () => controller.selectTip(0),
              ),
              for (final amount in CartCheckoutController.tipPresets) ...[
                const SizedBox(width: DSSpacing.sm),
                DSTipSelector(
                  label: '$amount$currency',
                  selected: !checkout.isCustomTip && checkout.tip == amount,
                  onTap: () => controller.selectTip(amount),
                ),
              ],
              const SizedBox(width: DSSpacing.sm),
              DSTipSelector(
                label: l10n.cartTipOther,
                selected: checkout.isCustomTip,
                onTap: () {
                  customTip.clear();
                  controller.selectCustomTip();
                },
              ),
            ],
          ),
        ),
        if (checkout.isCustomTip)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              DSSpacing.base,
              0,
              DSSpacing.base,
              DSSpacing.lg,
            ),
            // Closer to the row above than a part of its own.
            child: Transform.translate(
              offset: const Offset(0, -DSSpacing.md),
              child: DSAmountField(
                controller: customTip,
                onChanged: controller.setCustomTip,
                hintText: l10n.cartTipHint,
                suffix: currency,
              ),
            ),
          ),
      ],
    );
  }
}

class _AddProductsLink extends StatelessWidget {
  const _AddProductsLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: DSSizes.buttonHeightSm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                PhosphorIcons.plus(),
                size: DSSizes.iconXs,
                color: colors.textPrimary,
              ),
              const SizedBox(width: DSSpacing.xs),
              Text(
                label,
                style: DSTypography.bodySemibold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The bar under the scrolling content: the order button with the cart's
/// total. It takes no taps until placing an order is built.
class _OrderBar extends StatelessWidget {
  const _OrderBar({required this.total, required this.error});

  final int total;

  /// Why the last change of the cart was not accepted.
  final String? error;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
            DSButton(
              label: AppLocalizations.of(
                context,
              ).orderWithTotal(formatPrice(context, total)),
              size: DSButtonSize.sm,
              fullWidth: true,
              // TODO: place the order (the checkout stage).
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}
