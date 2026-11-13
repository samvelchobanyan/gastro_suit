import 'package:flutter/material.dart';

import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/product.dart';
import '../../../shared_widgets/price_text.dart';

/// The sizes of a product side by side, equally wide, one of them selected
/// (handoff `SizeSelector`). A size the branch has run out of is dimmed and
/// takes no taps.
class ProductSizeRow extends StatelessWidget {
  const ProductSizeRow({
    super.key,
    required this.sizes,
    required this.selectedId,
    required this.onSelected,
  });

  final List<ProductSize> sizes;
  final String? selectedId;
  final ValueChanged<ProductSize> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, size) in sizes.indexed) ...[
          if (i > 0) const SizedBox(width: DSSpacing.sm),
          Expanded(
            child: _SizeTile(
              size: size,
              selected: size.id == selectedId,
              onTap: size.isAvailable ? () => onSelected(size) : null,
            ),
          ),
        ],
      ],
    );
  }
}

class _SizeTile extends StatelessWidget {
  const _SizeTile({
    required this.size,
    required this.selected,
    required this.onTap,
  });

  final ProductSize size;
  final bool selected;

  /// Null when the size cannot be chosen.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tile = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DSSpacing.md,
        vertical: DSSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: selected ? colors.brandSubtle : colors.bgMain,
        borderRadius: BorderRadius.circular(DSRadius.md),
        border: Border.all(
          color: selected ? colors.brandPrimary : colors.borderDefault,
          width: DSSizes.borderWidthDefault,
        ),
      ),
      child: Column(
        children: [
          Text(
            size.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DSTypography.bodyXs.copyWith(
              fontWeight: DSTypography.semibold,
              color: selected ? colors.textAccent : colors.textPrimary,
            ),
          ),
          const SizedBox(height: DSSpacing.xxs),
          Text(
            formatPrice(context, size.price),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DSTypography.bodySm.copyWith(
              color: selected ? colors.textAccent : colors.textSecondary,
            ),
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      enabled: onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Opacity(
          opacity: onTap != null ? 1 : DSOpacity.disabled,
          child: tile,
        ),
      ),
    );
  }
}
