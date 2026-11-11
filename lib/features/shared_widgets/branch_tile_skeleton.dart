import 'package:flutter/material.dart';

import '../../design_system/components/feedback/ds_skeleton.dart';
import '../../design_system/ds_extensions.dart';

/// The loading placeholder of a `BranchTile`: its photo and three lines.
class BranchTileSkeleton extends StatelessWidget {
  const BranchTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        DSSkeleton.box(width: DSSizes.branchImage, height: DSSizes.branchImage),
        SizedBox(width: DSSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name, address and hours lines, as parts of the width.
              _Line(widthFactor: 0.5),
              SizedBox(height: DSSpacing.sm),
              _Line(widthFactor: 0.8),
              SizedBox(height: DSSpacing.sm),
              _Line(widthFactor: 0.4),
            ],
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: const DSSkeleton.box(
        width: double.infinity,
        height: DSSpacing.md,
        radius: DSRadius.xs,
      ),
    );
  }
}
