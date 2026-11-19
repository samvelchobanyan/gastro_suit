import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/di/repositories.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/utils/error_text.dart';
import '../../../../design_system/components/layout/ds_list_item.dart';
import '../../../../design_system/components/overlays/ds_dialog.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// The profile's "danger zone": signing out and deleting the account.
///
/// Both end the session, and the profile then shows itself as a guest's.
/// Deleting is asked about first; a failed one is said in a snack bar.
class AccountActions extends ConsumerStatefulWidget {
  const AccountActions({super.key});

  @override
  ConsumerState<AccountActions> createState() => _AccountActionsState();
}

class _AccountActionsState extends ConsumerState<AccountActions> {
  /// True while one of the two is on its way: the rows take no taps.
  var _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    _busy = true;
    try {
      await action();
    } on AppException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorText(context, error))));
    } finally {
      _busy = false;
    }
  }

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDSConfirmDialog(
      context: context,
      title: l10n.profileDeleteTitle,
      message: l10n.profileDeleteMessage,
      confirmLabel: l10n.profileDeleteConfirm,
      cancelLabel: l10n.cancel,
    );
    if (!confirmed) return;
    await _run(() => ref.read(profileRepositoryProvider).deleteAccount());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DSListGroup(
      children: [
        DSListItem(
          icon: PhosphorIcons.signOut(),
          title: l10n.profileLogout,
          chevron: true,
          onTap: () => _run(() => ref.read(authRepositoryProvider).logout()),
        ),
        DSListItem(
          icon: PhosphorIcons.trash(),
          title: l10n.profileDeleteAccount,
          chevron: true,
          onTap: _deleteAccount,
        ),
      ],
    );
  }
}
