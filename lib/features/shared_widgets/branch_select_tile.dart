import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../design_system/components/image/ds_network_image.dart';
import '../../design_system/components/inputs/ds_radio.dart';
import '../../design_system/ds_extensions.dart';
import '../../domain/entities/branch.dart';
import 'branch_distance.dart';

/// A branch row with a radio mark, for picking one branch out of a list
/// (handoff `BranchSelectorCard`): photo, name, distance, address.
class BranchSelectTile extends StatelessWidget {
  const BranchSelectTile({
    super.key,
    required this.branch,
    required this.selected,
    required this.onTap,
    this.distanceKm,
  });

  final Branch branch;
  final bool selected;
  final VoidCallback onTap;

  /// Not shown when null.
  final double? distanceKm;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final distanceKm = this.distanceKm;

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(DSRadius.md),
              child: DSNetworkImage(
                url: branch.photoUrl,
                width: DSSizes.branchImageSm,
                height: DSSizes.branchImageSm,
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
                          style: DSTypography.bodySm.copyWith(
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
            const SizedBox(width: DSSpacing.md),
            DSRadio(selected: selected),
          ],
        ),
      ),
    );
  }
}
