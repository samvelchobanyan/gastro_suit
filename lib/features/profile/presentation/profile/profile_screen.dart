import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_status.dart';
import '../../../../core/di/repositories.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Placeholder until the Profile screen is built. Holds the temporary sign-in
/// entry point until the app opens on the login screen.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final signedIn = ref.watch(authStatusProvider) == AuthStatus.signedIn;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.tabProfile,
            style: DSTypography.h1.copyWith(color: context.colors.textPrimary),
          ),
          const SizedBox(height: DSSpacing.lg),
          if (signedIn)
            OutlinedButton(
              onPressed: () => ref.read(authRepositoryProvider).logout(),
              child: Text(l10n.signOut),
            )
          else
            FilledButton(
              onPressed: () => context.push(AppRoutes.login),
              child: Text(l10n.signIn),
            ),
        ],
      ),
    );
  }
}
