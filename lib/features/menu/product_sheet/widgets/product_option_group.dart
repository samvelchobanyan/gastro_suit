import 'package:flutter/material.dart';

import '../../../../core/utils/price_format.dart';
import '../../../../design_system/components/inputs/ds_checkbox.dart';
import '../../../../design_system/components/inputs/ds_radio.dart';
import '../../../../design_system/components/inputs/ds_stepper.dart';
import '../../../../design_system/components/layout/ds_section_header.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/product.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// One question of a product with its answers (handoff `CheckboxAddOn`,
/// `RadioAddOn` and their `Simple` variants): the group's name over a row
/// per option.
///
/// The group decides how its rows look: radios when one option may be
/// chosen, checkboxes otherwise; a surcharge under each name when any
/// option of the group costs extra. A chosen option that one product may
/// carry several of shows how many at its end. An option the branch has
/// run out of is dimmed and takes no taps.
class ProductOptionGroupSection extends StatelessWidget {
  const ProductOptionGroupSection({
    super.key,
    required this.group,
    required this.quantities,
    required this.maxQuantityOf,
    required this.onToggle,
    required this.onQuantityChanged,
  });

  final ProductOptionGroup group;

  /// The chosen options with how many of each; those of other groups are
  /// ignored.
  final Map<String, int> quantities;

  /// The most of an option that can be chosen now.
  final int Function(ProductOption option) maxQuantityOf;
  final ValueChanged<ProductOption> onToggle;

  /// Called with a chosen option and the quantity asked for, 1 or more.
  final void Function(ProductOption option, int quantity) onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DSSectionHeader(title: group.name),
        // Each row carries half of the gap between rows on either side, so
        // the gap takes taps too: `md` under the title, `sm` between rows.
        const SizedBox(height: DSSpacing.md - DSSpacing.xs),
        for (final option in group.options)
          _OptionRow(
            option: option,
            quantity: quantities[option.id] ?? 0,
            maxQuantity: maxQuantityOf(option),
            singleChoice: group.isSingleChoice,
            showPrice: group.isPaid,
            onTap: option.isAvailable ? () => onToggle(option) : null,
            onQuantityChanged: (quantity) =>
                onQuantityChanged(option, quantity),
          ),
      ],
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.option,
    required this.quantity,
    required this.maxQuantity,
    required this.singleChoice,
    required this.showPrice,
    required this.onTap,
    required this.onQuantityChanged,
  });

  final ProductOption option;

  /// 0 when the option is not chosen.
  final int quantity;
  final int maxQuantity;
  final bool singleChoice;
  final bool showPrice;

  /// Null when the option cannot be chosen.
  final VoidCallback? onTap;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final selected = quantity > 0;
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: DSSpacing.xs),
      child: Row(
        children: [
          if (singleChoice)
            DSRadio(selected: selected)
          else
            DSCheckbox(checked: selected),
          const SizedBox(width: DSSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.name,
                  style: DSTypography.body.copyWith(
                    color: selected ? colors.textPrimary : colors.textTertiary,
                  ),
                ),
                if (showPrice) ...[
                  const SizedBox(height: DSSpacing.xxs),
                  Text(
                    '+${formatPrice(context, option.price)}',
                    style: DSTypography.bodySm.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Taking the option back is the checkbox's: the quantity does not
          // go under one.
          if (selected && option.maxQuantity > 1) ...[
            const SizedBox(width: DSSpacing.md),
            // A tap on a button at its limit stays here: it must not
            // reach the row and take the option back.
            GestureDetector(
              onTap: () {},
              child: DSStepper(
                value: quantity,
                min: 1,
                max: maxQuantity,
                onChanged: onQuantityChanged,
                decreaseLabel: l10n.quantityDecrease,
                increaseLabel: l10n.quantityIncrease,
              ),
            ),
          ],
        ],
      ),
    );

    return Semantics(
      checked: selected,
      inMutuallyExclusiveGroup: singleChoice,
      enabled: onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Opacity(
          opacity: onTap != null ? 1 : DSOpacity.disabled,
          child: row,
        ),
      ),
    );
  }
}
