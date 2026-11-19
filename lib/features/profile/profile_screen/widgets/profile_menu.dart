import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../design_system/components/inputs/ds_toggle.dart';
import '../../../../design_system/components/layout/ds_list_item.dart';
import '../../../../domain/state/favorites_state.dart';
import '../../../../domain/state/payment_cards_state.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// The profile's list: the saved cards, the history, the favourite products
/// and the switch of push notifications.
///
/// The cards lead nowhere until their screen is built, and the switch only
/// moves: what it turns on is not decided (DESIGN_PRODUCT_QUESTIONS §16).
class ProfileMenu extends ConsumerStatefulWidget {
  const ProfileMenu({super.key});

  @override
  ConsumerState<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends ConsumerState<ProfileMenu> {
  var _push = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final card = ref.watch(paymentCardProvider);
    final favorites = ref.watch(favoritesProvider).value;

    return DSListGroup(
      children: [
        DSListItem(
          icon: PhosphorIcons.creditCard(),
          title: l10n.profileBankCards,
          subtitle: card == null ? null : '**** ${card.lastDigits}',
          chevron: true,
        ),
        DSListItem(
          icon: PhosphorIcons.receipt(),
          title: l10n.profileHistory,
          subtitle: l10n.profileHistorySubtitle,
          chevron: true,
          onTap: () => context.push(AppRoutes.history),
        ),
        DSListItem(
          icon: PhosphorIcons.heart(),
          title: l10n.profileFavorites,
          subtitle: favorites == null
              ? null
              : l10n.profileFavoritesCount(favorites.length),
          chevron: true,
          onTap: () => context.push(AppRoutes.favorites),
        ),
        DSListItem(
          icon: PhosphorIcons.bell(),
          title: l10n.profilePush,
          trailing: DSToggle(
            value: _push,
            onChanged: (value) => setState(() => _push = value),
            semanticLabel: l10n.profilePush,
          ),
        ),
      ],
    );
  }
}
