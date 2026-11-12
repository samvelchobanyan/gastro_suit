import 'package:flutter/material.dart';

import '../../../design_system/components/feedback/ds_skeleton.dart';
import '../../../design_system/ds_extensions.dart';
import '../widgets/menu_product_card.dart';

/// The loading placeholder of a `MenuBlock`: its title, a row of categories
/// and the first cards of the grid. Also shown by a screen that does not
/// know yet which branch's menu to ask for.
class MenuBlockSkeleton extends StatelessWidget {
  const MenuBlockSkeleton({super.key});

  static const _categories = 5;
  static const _cardRows = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = (constraints.maxWidth - DSLayout.gutter) / 2;
          final cardHeight = MenuProductCard.heightFor(
            cardWidth,
            MediaQuery.textScalerOf(context),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DSSkeleton.box(
                width: DSSizes.menuCategoryItemWidth,
                height: DSSpacing.lg,
                radius: DSRadius.xs,
              ),
              const SizedBox(height: DSSpacing.md),
              // Runs off the edge on a narrow screen, as the real row does.
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  spacing: DSSpacing.md,
                  children: [
                    for (var i = 0; i < _categories; i++)
                      const DSSkeleton.circle(
                        diameter: DSSizes.menuCategoryImage,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: DSSpacing.lg),
              for (var row = 0; row < _cardRows; row++) ...[
                if (row > 0) const SizedBox(height: DSLayout.gutter),
                Row(
                  spacing: DSLayout.gutter,
                  children: [
                    for (var i = 0; i < 2; i++)
                      DSSkeleton.box(width: cardWidth, height: cardHeight),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
