import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/buy_again.dart';
import '../../../shared_widgets/product_card.dart';

/// Something to order again in Home's rail (handoff `BuyAgainCard`): a
/// rounded photo with the product's name and the branch under it. As wide
/// as its parent makes it; see [heightFor].
///
/// One the branch cannot make now is greyed.
class BuyAgainCard extends StatelessWidget {
  const BuyAgainCard({super.key, required this.item, this.onTap});

  final BuyAgainItem item;
  final VoidCallback? onTap;

  /// The height of a card [width] wide: its square photo and two lines of
  /// text, at the user's text size. The branch's line is never lower than
  /// its pin.
  static double heightFor(double width, TextScaler textScaler) {
    double lineHeight(TextStyle style) =>
        (textScaler.scale(style.fontSize!) * style.height!).ceilToDouble();
    final branchLine = lineHeight(DSTypography.bodyXs);
    return width +
        DSSpacing.sm +
        lineHeight(DSTypography.bodySmSemibold) +
        DSSpacing.xxs +
        (branchLine > DSSizes.iconXs ? branchLine : DSSizes.iconXs);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      enabled: item.isAvailable,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Opacity(
          opacity: item.isAvailable ? 1 : DSOpacity.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(DSRadius.card),
                child: ProductPhoto(url: item.imageUrl),
              ),
              const SizedBox(height: DSSpacing.sm),
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DSTypography.bodySmSemibold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: DSSpacing.xxs),
              Row(
                children: [
                  Icon(
                    PhosphorIcons.mapPin(),
                    size: DSSizes.iconXs,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(width: DSSpacing.xs),
                  Expanded(
                    child: Text(
                      item.branchName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DSTypography.bodyXs.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
