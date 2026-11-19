import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/branches/branch_screen/branch_screen.dart';
import '../../features/favorites/favorites_screen/favorites_screen.dart';
import '../../features/gifts/gifts_screen/gifts_screen.dart';
import '../../features/history/history_screen/history_screen.dart';
import '../../features/history/order_details_screen/order_details_screen.dart';
import '../../features/home/home_screen/home_screen.dart';
import '../../features/order/order_screen/order_screen.dart';
import '../../features/profile/edit_profile_screen/edit_profile_screen.dart';
import '../../features/profile/profile_screen/profile_screen.dart';
import 'app_routes.dart';
import 'main_shell.dart';

/// The app router. A provider, so redirects can later watch auth state.
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      // Each branch keeps its own navigation stack across tab switches.
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.order,
                builder: (context, state) => const OrderScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.gifts,
                builder: (context, state) => const GiftsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Outside the shell: a branch's screen covers the tab bar and has its
      // own checkout bar in its place.
      GoRoute(
        path: AppRoutes.branch,
        builder: (context, state) =>
            BranchScreen(branchId: state.pathParameters['id']!),
      ),
      // Outside the shell: editing the profile, the favourites, the history
      // and an order's details are opened over a tab and cover the tab bar.
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderDetails,
        builder: (context, state) =>
            OrderDetailsScreen(orderId: state.pathParameters['id']!),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
