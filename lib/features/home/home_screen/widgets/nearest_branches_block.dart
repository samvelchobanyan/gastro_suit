import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_routes.dart';

import '../../../../design_system/components/layout/ds_section_header.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/state/branches_state.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../shared_widgets/branch_tile.dart';
import '../../../shared_widgets/branch_tile_skeleton.dart';
import '../../../shared_widgets/load_error_row.dart';

/// Home's three nearest branches. Unlike the promotion rows, a failed load
/// shows an error with a retry: branches are what the user orders from.
class NearestBranchesBlock extends ConsumerWidget {
  const NearestBranchesBlock({super.key});

  static const _count = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(branchesControllerProvider);
    final branches = state.value;

    if (branches == null) {
      return _Section(
        child: state.hasError
            ? LoadErrorRow(
                onRetry: () => ref.invalidate(branchesControllerProvider),
              )
            : const _Skeleton(),
      );
    }
    if (branches.isEmpty) return const SizedBox.shrink();

    final nearest = branches.take(_count).toList();
    return _Section(
      child: _Rows(
        children: [
          for (final item in nearest)
            BranchTile(
              branch: item.branch,
              distanceKm: item.distanceKm,
              onTap: () => context.push(AppRoutes.branchOf(item.branch.id)),
            ),
        ],
      ),
    );
  }
}

/// The section's title and padding around its content.
class _Section extends StatelessWidget {
  const _Section({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DSLayout.margin,
        0,
        DSLayout.margin,
        DSSpacing.base,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DSSectionHeader(title: AppLocalizations.of(context).nearestBranches),
          const SizedBox(height: DSSpacing.md),
          child,
        ],
      ),
    );
  }
}

/// Rows with a hairline between them.
class _Rows extends StatelessWidget {
  const _Rows({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final divider = Padding(
      padding: const EdgeInsets.symmetric(vertical: DSSpacing.md),
      child: Divider(
        height: DSSizes.borderWidthDefault,
        thickness: DSSizes.borderWidthDefault,
        color: context.colors.borderMuted,
      ),
    );
    return Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) divider,
          children[i],
        ],
      ],
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return _Rows(
      children: [
        for (var i = 0; i < NearestBranchesBlock._count; i++)
          const BranchTileSkeleton(),
      ],
    );
  }
}
