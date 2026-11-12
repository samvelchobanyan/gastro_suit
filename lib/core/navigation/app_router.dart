import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen/login_screen.dart';
import '../../features/branches/branch_screen/branch_screen.dart';
import '../../features/gifts/gifts_screen/gifts_screen.dart';
import '../../features/home/home_screen/home_screen.dart';
import '../../features/order/order_screen/order_screen.dart';
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
      // Outside the shell: sign-in belongs to no tab and covers the tab bar.
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // Outside the shell: a branch's screen covers the tab bar and has its
      // own checkout bar in its place.
      GoRoute(
        path: AppRoutes.branch,
        builder: (context, state) =>
            BranchScreen(branchId: state.pathParameters['id']!),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
