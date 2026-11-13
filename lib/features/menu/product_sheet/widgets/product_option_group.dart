import 'package:flutter/material.dart';

import '../../../../design_system/components/inputs/ds_checkbox.dart';
import '../../../../design_system/components/inputs/ds_radio.dart';
import '../../../../design_system/components/layout/ds_section_header.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/product.dart';
import '../../../shared_widgets/price_text.dart';

/// One question of a product with its answers (handoff `CheckboxAddOn`,
/// `RadioAddOn` and their `Simple` variants): the group's name over a row
/// per option.
///
/// The group decides how its rows look: radios when one option may be
/// chosen, checkboxes otherwise; a surcharge under each name when any
/// option of the group costs extra. An option the branch has run out of is
/// dimmed and takes no taps.
class ProductOptionGroupSection extends StatelessWidget {
  const ProductOptionGroupSection({
    super.key,
    required this.group,
    required this.selectedIds,
    required this.onToggle,
  });

  final ProductOptionGroup group;

  /// The chosen options; those of other groups are ignored.
  final Set<String> selectedIds;
  final ValueChanged<ProductOption> onToggle;

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
            selected: selectedIds.contains(option.id),
            singleChoice: group.isSingleChoice,
            showPrice: group.isPaid,
            onTap: option.isAvailable ? () => onToggle(option) : null,
          ),
      ],
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.option,
    required this.selected,
    required this.singleChoice,
    required this.showPrice,
    required this.onTap,
  });

  final ProductOption option;
  final bool selected;
  final bool singleChoice;
  final bool showPrice;

  /// Null when the option cannot be chosen.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
