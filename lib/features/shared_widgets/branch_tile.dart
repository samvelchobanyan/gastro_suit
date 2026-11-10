import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../design_system/components/feedback/ds_status_pill.dart';
import '../../design_system/components/image/ds_network_image.dart';
import '../../design_system/ds_extensions.dart';
import '../../domain/entities/branch.dart';
import '../../l10n/generated/app_localizations.dart';

/// One branch in a list (handoff `BranchCard`): photo, name, distance,
/// address, today's hours and whether it is open. Home's nearest branches
/// and the Order tab's branch list.
class BranchTile extends StatelessWidget {
  const BranchTile({
    super.key,
    required this.branch,
    this.distanceKm,
    this.onTap,
  });

  final Branch branch;

  /// Not shown when null.
  final double? distanceKm;

  /// With a handler the card shows a chevron and reacts to taps.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final distanceKm = this.distanceKm;

    final card = Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(DSRadius.md),
          child: DSNetworkImage(
            url: branch.photoUrl,
            width: DSSizes.branchImage,
            height: DSSizes.branchImage,
          ),
        ),
        const SizedBox(width: DSSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(
                      branch.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DSTypography.body.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  if (distanceKm != null) ...[
                    const SizedBox(width: DSSpacing.sm),
                    Text(
                      _distance(context, distanceKm),
                      style: DSTypography.caption.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: DSSpacing.xs),
              Row(
                children: [
                  Icon(
                    PhosphorIcons.mapPin(),
                    size: DSSizes.iconXs,
                    color: colors.textTertiary,
                  ),
                  const SizedBox(width: DSSpacing.xs),
                  Expanded(
                    child: Text(
                      branch.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DSTypography.bodySm.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              ?_hoursRow(context),
            ],
          ),
        ),
        if (onTap != null) ...[
          const SizedBox(width: DSSpacing.sm),
          Icon(
            PhosphorIcons.caretRight(),
            size: DSSizes.iconSm,
            color: colors.textTertiary,
          ),
        ],
      ],
    );

    if (onTap == null) return card;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: card,
    );
  }

  /// Today's hours and the open / closed pill. Nothing when the branch has
  /// no hours entered and is not closed for now: its state is unknown.
  Widget? _hoursRow(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    final hours = switch (branch.today) {
      TodayOpen(:final opens, :final closes) => '$opens – $closes',
      TodayClosed() => l10n.branchClosedToday,
      null => null,
    };
    // A day off already says "closed" in the hours text.
    final showPill = branch.isTemporarilyClosed || branch.today is TodayOpen;
    if (hours == null && !showPill) return null;

    final isOpen = branch.isOpenNow ?? false;
    return Padding(
      padding: const EdgeInsets.only(top: DSSpacing.xs),
      child: Row(
        children: [
          if (hours != null) ...[
            Icon(
              PhosphorIcons.clock(),
              size: DSSizes.iconXs,
              color: colors.textTertiary,
            ),
            const SizedBox(width: DSSpacing.xs),
            Text(
              hours,
              style: DSTypography.bodyXs.copyWith(color: colors.textTertiary),
            ),
            const SizedBox(width: DSSpacing.sm),
          ],
          if (showPill)
            DSStatusPill(
              label: isOpen ? l10n.branchOpen : l10n.branchClosed,
              tone: isOpen ? DSStatusTone.success : DSStatusTone.error,
            ),
        ],
      ),
    );
  }

  static String _distance(BuildContext context, double km) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final number = NumberFormat('0.0', locale).format(km);
    return AppLocalizations.of(context).distanceKm(number);
  }
}
