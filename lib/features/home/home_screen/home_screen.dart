import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/ds_extensions.dart';
import '../../../domain/state/active_orders_state.dart';
import '../../../domain/state/branches_state.dart';
import '../../../domain/state/buy_again_state.dart';
import '../../../domain/state/favorites_state.dart';
import '../../../domain/state/loyalty_card_state.dart';
import '../../../domain/state/wallet_state.dart';
import 'banners_controller.dart';
import 'stories_controller.dart';
import 'widgets/banners_block.dart';
import 'widgets/home_header.dart';
import 'widgets/loyalty_card_block.dart';
import 'widgets/nearest_branches_block.dart';
import 'widgets/order_status_block.dart';
import 'widgets/quick_order_block.dart';
import 'widgets/stories_block.dart';
import 'widgets/wallet_block.dart';

/// The Home tab: one vertical scroll of blocks, top to bottom — header,
/// stories, the status of orders on their way, the loyalty card, the wallet,
/// the buy-again and favourites rails, banners, nearest branches (vouchers
/// later).
///
/// Each block loads, fails and refreshes on its own; this screen only places
/// them and refreshes them all on pull-to-refresh.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Reloads every block. Data already on screen stays until the new data
  /// arrives; a failed refresh keeps it.
  Future<void> _refresh(WidgetRef ref) async {
    try {
      await Future.wait<Object?>([
        ref.refresh(storiesControllerProvider.future),
        ref.refresh(bannersControllerProvider.future),
        ref.refresh(activeOrdersProvider.future),
        ref.refresh(loyaltyCardProvider.future),
        ref.refresh(walletProvider.future),
        ref.refresh(buyAgainProvider.future),
        ref.refresh(favoritesProvider.future),
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
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: HomeHeader()),
              const SliverToBoxAdapter(child: StoriesBlock()),
              const SliverToBoxAdapter(child: OrderStatusBlock()),
              const SliverToBoxAdapter(child: LoyaltyCardBlock()),
              const SliverToBoxAdapter(child: WalletBlock()),
              const SliverToBoxAdapter(child: QuickOrderBlock()),
              const SliverToBoxAdapter(child: BannersBlock()),
              const SliverToBoxAdapter(child: NearestBranchesBlock()),
              // Room to scroll clear of the navigation floating over the
              // tab.
              SliverToBoxAdapter(
                child: SizedBox(
                  height: DSSpacing.base + MediaQuery.paddingOf(context).bottom,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
