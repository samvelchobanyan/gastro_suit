import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../design_system/components/buttons/ds_icon_button.dart';
import '../../../../design_system/components/feedback/ds_rating_stars.dart';
import '../../../../design_system/components/image/ds_network_image.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/branch.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// The top of a branch's screen (handoff `RestaurantHeader`): its photo
/// with the name, the description and the rating over it, and the buttons
/// to go back, rate the branch and see it on the map.
///
/// The photo runs under the status bar: the header is [heightFor] high, the
/// handoff's height below the status bar and [topInset] more under it.
class BranchHeader extends StatelessWidget {
  const BranchHeader({
    super.key,
    required this.branch,
    required this.topInset,
    required this.onBack,
    required this.onRate,
    required this.onMap,
  });

  final Branch branch;

  /// The height of the status bar over the photo.
  final double topInset;
  final VoidCallback onBack;
  final VoidCallback onRate;

  /// Null when the branch cannot be shown on the map: no button then.
  final VoidCallback? onMap;

  static double heightFor(double topInset) =>
      DSSizes.branchHeaderHeight + topInset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final description = branch.description;
    // Text over the photo that is a step quieter than the name.
    final quiet = colors.textInverse.withValues(alpha: 0.8);

    return SizedBox(
      height: heightFor(topInset),
      child: Stack(
        fit: StackFit.expand,
        children: [
          LayoutBuilder(
            builder: (context, constraints) => DSNetworkImage(
              url: branch.photoUrl,
              width: constraints.maxWidth,
              height: constraints.maxHeight,
            ),
          ),
          // Keeps the text readable on any photo.
          DecoratedBox(decoration: BoxDecoration(gradient: colors.scrimHero)),
          PositionedDirectional(
            top: topInset + DSSpacing.md,
            start: DSSpacing.md,
            child: DSIconButton(
              icon: PhosphorIcons.arrowLeft(),
              semanticLabel: l10n.back,
              variant: DSIconButtonVariant.tonal,
              size: DSIconButtonSize.xs,
              onPressed: onBack,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(DSSpacing.base),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DSIconButton(
                    icon: PhosphorIcons.star(),
                    semanticLabel: l10n.rateBranch,
                    variant: DSIconButtonVariant.tonal,
                    size: DSIconButtonSize.xs,
                    onPressed: onRate,
                  ),
                  const SizedBox(width: DSSpacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          branch.name,
                          textAlign: TextAlign.center,
                          style: DSTypography.h2.copyWith(
                            fontWeight: DSTypography.semibold,
                            color: colors.textInverse,
                          ),
                        ),
                        if (description != null) ...[
                          const SizedBox(height: DSSpacing.xs),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: DSTypography.bodySm.copyWith(color: quiet),
                          ),
                        ],
                        const SizedBox(height: DSSpacing.sm),
                        _Rating(rating: branch.rating, countColor: quiet),
                      ],
                    ),
                  ),
                  const SizedBox(width: DSSpacing.sm),
                  if (onMap case final onMap?)
                    DSIconButton(
                      icon: PhosphorIcons.mapPin(),
                      semanticLabel: l10n.showOnMap,
                      variant: DSIconButtonVariant.tonal,
                      size: DSIconButtonSize.xs,
                      onPressed: onMap,
                    )
                  else
                    // Keeps the name centred.
                    const SizedBox(width: DSSizes.buttonHeightXs),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The stars, the average and how many guests rated the branch. Empty stars
/// alone while nobody has: a zero would read as a bad rating.
class _Rating extends StatelessWidget {
  const _Rating({required this.rating, required this.countColor});

  final BranchRating? rating;
  final Color countColor;

  @override
  Widget build(BuildContext context) {
    final rating = this.rating;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DSRatingStars(value: rating?.average ?? 0),
        if (rating != null) ...[
          const SizedBox(width: DSSpacing.xs),
          Text(
            NumberFormat('0.0', locale).format(rating.average),
            style: DSTypography.bodySmSemibold.copyWith(
              color: context.colors.textInverse,
            ),
          ),
          const SizedBox(width: DSSpacing.xs),
          Text(
            '(${rating.count})',
            style: DSTypography.bodySm.copyWith(color: countColor),
          ),
        ],
      ],
    );
  }
}
