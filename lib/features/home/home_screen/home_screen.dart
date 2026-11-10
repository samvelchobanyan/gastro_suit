import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/ds_extensions.dart';
import '../../../domain/state/branches_state.dart';
import 'banners_controller.dart';
import 'stories_controller.dart';
import 'widgets/banners_block.dart';
import 'widgets/home_header.dart';
import 'widgets/nearest_branches_block.dart';
import 'widgets/stories_block.dart';

/// The Home tab: one vertical scroll of blocks, top to bottom — header,
/// stories, banners, nearest branches (loyalty, wallet, vouchers and the
/// buy-again / favourites rails later).
///
/// Each block loads, fails and refreshes on its own; this screen only places
/// them and refreshes them all on pull-to-refresh.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Reloads every block. Data already on screen stays until the new data
  /// arrives; a failed refresh keeps it.
  Future<void> _refresh(WidgetRef ref) async {
    try {
      await Future.wait<Object>([
        ref.refresh(storiesControllerProvider.future),
        ref.refresh(bannersControllerProvider.future),
        // Also reads the position again.
        ref.refresh(branchesControllerProvider.future),
      ]);
    } catch (_) {
      // Each block shows its own outcome; the spinner only needs to stop.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: context.colors.bgSurface,
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: context.colors.brandPrimary,
          onRefresh: () => _refresh(ref),
          child: const CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              // Guest version: the name and the unread dot arrive with the
              // profile; there is no notifications screen yet.
              SliverToBoxAdapter(child: HomeHeader()),
              SliverToBoxAdapter(child: StoriesBlock()),
              SliverToBoxAdapter(child: BannersBlock()),
              SliverToBoxAdapter(child: NearestBranchesBlock()),
            ],
          ),
        ),
      ),
    );
  }
}
