import 'package:flutter/material.dart';

import '../../../../design_system/components/inputs/ds_select_tile.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/product.dart';
import '../../../../core/utils/price_format.dart';

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
    return DSSelectTile(
      selected: selected,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: DSSpacing.md,
        vertical: DSSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
  }
}
