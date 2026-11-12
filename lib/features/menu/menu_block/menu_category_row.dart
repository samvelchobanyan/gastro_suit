import 'package:flutter/material.dart';

import '../../../design_system/components/image/ds_network_image.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/menu_category.dart';

/// The menu's top-level categories in a sideways-scrolling row (handoff
/// `MenuTabsVertical`): an image with the name under it, one selected.
class MenuCategoryRow extends StatelessWidget {
  const MenuCategoryRow({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<MenuCategory> categories;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: DSSpacing.md,
        vertical: DSSpacing.xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: DSSpacing.md,
        children: [
          for (final category in categories)
            _CategoryItem(
              category: category,
              selected: category.id == selectedId,
              onTap: () => onSelected(category.id),
            ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final MenuCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: DSSizes.menuCategoryItemWidth,
          child: Column(
            children: [
              DSNetworkImage(
                url: category.imageUrl,
                width: DSSizes.menuCategoryImage,
                height: DSSizes.menuCategoryImage,
              ),
              const SizedBox(height: DSSpacing.xs),
              Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style:
                    (selected
                            ? DSTypography.bodySmSemibold
                            : DSTypography.bodySm)
                        .copyWith(
                          color: selected
                              ? colors.textAccent
                              : colors.textSecondary,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
