import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../design_system/components/buttons/ds_icon_button.dart';
import '../../../../design_system/components/feedback/ds_skeleton.dart';
import '../../../../design_system/components/image/ds_avatar.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/state/profile_state.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../shared_widgets/load_error_row.dart';

/// The user on a dark card (handoff `UserProfile`): the photo, the name,
/// what they sign in with, and the pencil that leads to editing.
///
/// Loads and fails on its own.
class ProfileUserCard extends ConsumerWidget {
  const ProfileUserCard({super.key});

  static const _height = DSSizes.avatarMd + DSSpacing.md * 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final profile = state.value;
    if (profile == null) {
      return state.hasError
          ? LoadErrorRow(onRetry: () => ref.invalidate(profileProvider))
          : const DSSkeleton.box(width: double.infinity, height: _height);
    }

    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final contact = profile.contact;
    // A user without a name is shown by what they sign in with.
    final title = profile.fullName.isNotEmpty ? profile.fullName : contact;
    final subtitle = profile.fullName.isNotEmpty ? contact : null;

    return Container(
      padding: const EdgeInsets.all(DSSpacing.md),
      decoration: BoxDecoration(
        color: colors.bgInverse,
        borderRadius: BorderRadius.circular(DSRadius.md),
      ),
      child: Row(
        children: [
          DSAvatar(name: profile.fullName, photoUrl: profile.photoUrl),
          const SizedBox(width: DSSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DSTypography.bodySemibold.copyWith(
                      color: colors.textInverse,
                    ),
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: DSSpacing.xxs),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DSTypography.bodySm.copyWith(
                      color: colors.textInverse.withValues(
                        alpha: DSOpacity.quietOnDark,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: DSSpacing.md),
          DSIconButton(
            icon: PhosphorIcons.pencilSimple(),
            onPressed: () => context.push(AppRoutes.editProfile),
            semanticLabel: l10n.profileEdit,
            variant: DSIconButtonVariant.tonal,
            size: DSIconButtonSize.sm,
          ),
        ],
      ),
    );
  }
}
