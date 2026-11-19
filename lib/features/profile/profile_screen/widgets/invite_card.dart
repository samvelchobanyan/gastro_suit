import 'package:flutter/material.dart';

import '../../../../design_system/components/buttons/ds_button.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// The call to invite a friend (handoff `Invite`): a picture, two lines and
/// the button. The button leads nowhere until the invite screen is built.
class InviteCard extends StatelessWidget {
  const InviteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(DSSpacing.md),
      decoration: BoxDecoration(
        color: colors.bgCanvas,
        borderRadius: BorderRadius.circular(DSRadius.md),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/invite_plane.png',
            width: DSSizes.inviteImage,
            height: DSSizes.inviteImage,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
          const SizedBox(width: DSSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.inviteTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DSTypography.bodySemibold.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: DSSpacing.xxs),
                Text(
                  l10n.inviteDescription,
                  style: DSTypography.bodySm.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: DSSpacing.md),
          DSButton(
            label: l10n.inviteAction,
            size: DSButtonSize.xs,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
