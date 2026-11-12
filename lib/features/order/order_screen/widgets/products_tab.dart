import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/state/active_branch_state.dart';
import '../../../../domain/state/branches_state.dart';
import '../../../../domain/state/menu_state.dart';
import '../../../menu/menu_block/menu_block.dart';
import '../../../menu/menu_block/menu_block_skeleton.dart';
import '../../../shared_widgets/load_error_row.dart';
import 'featured_products_rail.dart';

/// The Order screen's Products view: the active branch's featured products
/// and its menu in one scroll.
class ProductsTab extends ConsumerWidget {
  const ProductsTab({super.key});

  /// The menu already on screen stays until the new one arrives; a failed
  /// refresh keeps it.
  Future<void> _refresh(WidgetRef ref, String branchId) async {
    ref.invalidate(menuProvider(branchId));
    try {
      await ref.read(menuProvider(branchId).future);
    } catch (_) {
      // The menu block shows the outcome; the spinner only needs to stop.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchState = ref.watch(activeBranchProvider);
    final branch = branchState.value;

    if (branch == null) {
      // Loading, failed, or an organisation without branches.
      if (branchState.isLoading) return const MenuBlockSkeleton();
      if (!branchState.hasError) return const SizedBox.shrink();
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
          child: LoadErrorRow(
            onRetry: () => ref.invalidate(branchesControllerProvider),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: context.colors.brandPrimary,
      onRefresh: () => _refresh(ref, branch.id),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: FeaturedProductsRail(branchId: branch.id)),
          MenuBlock(branchId: branch.id),
        ],
      ),
    );
  }
}
