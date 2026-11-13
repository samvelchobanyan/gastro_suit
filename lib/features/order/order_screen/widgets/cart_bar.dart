import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../design_system/components/buttons/ds_icon_button.dart';
import '../../../../design_system/components/feedback/ds_badge.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/state/active_branch_state.dart';
import '../../../../domain/state/cart_state.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../branches/branch_picker_sheet/branch_picker_sheet.dart';
import '../../../cart/cart_sheet/cart_sheet.dart';

/// The bar that floats over the bottom of the menu (the handoff's Order
/// page, "Cart bar"): the branch the menu is of, which opens the branch
/// picker, and the cart button with how many pieces the cart holds.
///
/// A sheet of frosted glass: the menu shows through it, blurred.
class CartBar extends ConsumerWidget {
  const CartBar({super.key});

  /// What the bar takes of the screen's height, its bottom margin
  /// included: the room a scroll view under it leaves at its end.
  static const height =
      DSSpacing.sm * 2 +
      DSSizes.cartBarLabelHeight +
      DSSpacing.xs +
      DSSizes.inputHeightCompact +
      DSSpacing.base;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final branch = ref.watch(activeBranchProvider).value;
    final count = ref.watch(cartProvider).value?.itemCount ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DSSpacing.base,
        0,
        DSSpacing.base,
        DSSpacing.base,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DSRadius.md),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: DSSizes.glassBlur,
            sigmaY: DSSizes.glassBlur,
          ),
          child: Container(
            padding: const EdgeInsets.all(DSSpacing.sm),
            decoration: BoxDecoration(
              color: colors.glassBg,
              borderRadius: BorderRadius.circular(DSRadius.md),
              border: Border.all(
                color: colors.glassBorder,
                width: DSSizes.borderWidthDefault,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _BranchField(
                    label: l10n.cartBarBranch,
                    name: branch?.name ?? '',
                    onTap: () => showBranchPicker(context),
                  ),
                ),
                const SizedBox(width: DSSpacing.sm),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    DSIconButton(
                      icon: PhosphorIcons.shoppingCartSimple(),
                      semanticLabel: l10n.cartOpen,
                      variant: count > 0
                          ? DSIconButtonVariant.filled
                          : DSIconButtonVariant.tonal,
                      size: DSIconButtonSize.sm,
                      shape: DSIconButtonShape.rounded,
                      onPressed: () => showCart(context),
                    ),
                    if (count > 0)
                      PositionedDirectional(
                        top: -DSSpacing.xs,
                        end: 0,
                        child: IgnorePointer(child: DSBadge(count: count)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The branch as a field with a label over it and a caret at its end; a
/// tap opens the branch picker.
class _BranchField extends StatelessWidget {
  const _BranchField({
    required this.label,
    required this.name,
    required this.onTap,
  });

  final String label;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: DSSizes.cartBarLabelHeight,
              child: Text(
                label,
                maxLines: 1,
                style: DSTypography.bodySm.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: DSSpacing.xs),
            Container(
              height: DSSizes.inputHeightCompact,
              padding: const EdgeInsetsDirectional.only(
                start: DSSpacing.base,
                end: DSSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colors.bgMain,
                borderRadius: BorderRadius.circular(DSRadius.input),
                border: Border.all(
                  color: colors.borderDefault,
                  width: DSSizes.borderWidthDefault,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DSTypography.bodySm.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    PhosphorIcons.caretDown(),
                    size: DSSizes.iconSm,
                    color: colors.textTertiary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
