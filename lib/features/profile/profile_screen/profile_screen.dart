import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_status.dart';
import '../../../design_system/components/buttons/ds_button.dart';
import '../../../design_system/components/layout/ds_screen_header.dart';
import '../../../design_system/components/layout/ds_section_header.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/state/payment_cards_state.dart';
import '../../../domain/state/profile_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/login_sheet/login_sheet.dart';
import 'widgets/account_actions.dart';
import 'widgets/invite_card.dart';
import 'widgets/language_choice.dart';
import 'widgets/profile_menu.dart';
import 'widgets/profile_user_card.dart';

/// The Profile tab: the user, the way to invite a friend, the list that
/// leads to their cards, history and favourites, the app's language, and
/// signing out or deleting the account.
///
/// A guest sees what needs no account: the way to sign in, the language and
/// the links.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  /// Reloads what the screen shows of the user. Data on screen stays until
  /// the new data arrives.
  Future<void> _refresh(WidgetRef ref) async {
    try {
      await Future.wait<Object?>([
        ref.refresh(profileProvider.future),
        ref.refresh(paymentCardsProvider.future),
      ]);
    } catch (_) {
      // Each part shows its own outcome; the spinner only needs to stop.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final signedIn = ref.watch(authStatusProvider) == AuthStatus.signedIn;

    const gap = SizedBox(height: DSSpacing.base);
    final language = <Widget>[
      DSSectionHeader(title: l10n.profileLanguage),
      const SizedBox(height: DSSpacing.sm),
      const LanguageChoice(),
      gap,
    ];

    return ColoredBox(
      color: colors.bgSurface,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DSScreenHeader(title: l10n.tabProfile),
            Expanded(
              child: RefreshIndicator(
                color: colors.brandPrimary,
                onRefresh: () => _refresh(ref),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // The bottom is the room to scroll clear of the
                  // navigation floating over the tab.
                  padding: EdgeInsets.fromLTRB(
                    DSLayout.margin,
                    0,
                    DSLayout.margin,
                    MediaQuery.paddingOf(context).bottom,
                  ),
                  children: [
                    if (signedIn) ...[
                      const ProfileUserCard(),
                      gap,
                      const InviteCard(),
                      gap,
                      const ProfileMenu(),
                      gap,
                      ...language,
                      DSSectionHeader(title: l10n.profileDangerZone),
                      const SizedBox(height: DSSpacing.sm),
                      const AccountActions(),
                      gap,
                    ] else ...[
                      DSButton(
                        label: l10n.signIn,
                        size: DSButtonSize.md,
                        fullWidth: true,
                        onPressed: () => showLoginSheet(context),
                      ),
                      gap,
                      ...language,
                    ],
                    const _Links(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The links under the profile. They lead nowhere yet: whether they open a
/// page in the app or a site is not decided.
class _Links extends StatelessWidget {
  const _Links();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = DSTypography.body.copyWith(
      color: context.colors.textSecondary,
      decoration: TextDecoration.underline,
      decorationColor: context.colors.textSecondary,
    );
    return Padding(
      padding: const EdgeInsets.only(top: DSSpacing.sm, bottom: DSSpacing.lg),
      child: Column(
        children: [
          Text(l10n.profileTerms, style: style),
          const SizedBox(height: DSSpacing.sm),
          Text(l10n.profileAboutDeveloper, style: style),
        ],
      ),
    );
  }
}
