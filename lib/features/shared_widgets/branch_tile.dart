import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../design_system/components/image/ds_network_image.dart';
import '../../design_system/ds_extensions.dart';
import '../../domain/entities/branch.dart';
import 'branch_distance.dart';
import 'branch_hours_row.dart';

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
                      formatBranchDistance(context, distanceKm),
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
              if (BranchHoursRow.hasContentFor(branch))
                Padding(
                  padding: const EdgeInsets.only(top: DSSpacing.xs),
                  child: BranchHoursRow(branch: branch),
                ),
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
}
