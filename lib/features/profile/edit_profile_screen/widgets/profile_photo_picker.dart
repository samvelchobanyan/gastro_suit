import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/network/app_exception.dart';
import '../../../../core/utils/error_text.dart';
import '../../../../design_system/components/buttons/ds_icon_button.dart';
import '../../../../design_system/components/image/ds_avatar.dart';
import '../../../../design_system/components/layout/ds_list_item.dart';
import '../../../../design_system/components/overlays/ds_bottom_sheet.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/state/profile_state.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// The user's photo with the way to change it: a tap asks where to take a
/// picture from, and the chosen one is saved at once, apart from the form
/// under it.
class ProfilePhotoPicker extends ConsumerStatefulWidget {
  const ProfilePhotoPicker({super.key});

  @override
  ConsumerState<ProfilePhotoPicker> createState() => _ProfilePhotoPickerState();
}

class _ProfilePhotoPickerState extends ConsumerState<ProfilePhotoPicker> {
  /// A photo shown in a circle this small needs no more; it also keeps the
  /// file far under the server's limit and makes it a JPEG or a PNG, which
  /// the server takes.
  static const _maxSide = 1024.0;
  static const _quality = 85;

  var _saving = false;

  Future<void> _change() async {
    final l10n = AppLocalizations.of(context);
    final source = await showDSBottomSheet<ImageSource>(
      context: context,
      title: l10n.profileChangePhoto,
      child: const _PhotoSources(),
    );
    if (source == null || !mounted) return;

    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: _maxSide,
        maxHeight: _maxSide,
        imageQuality: _quality,
      );
      if (picked == null || !mounted) return;
      setState(() => _saving = true);
      await ref.read(profileProvider.notifier).setPhoto(picked.path);
    } on AppException catch (error) {
      if (mounted) _say(errorText(context, error));
    } on PlatformException {
      // No camera, or the user has not let the app use it or the gallery.
      if (mounted) _say(l10n.profilePhotoUnavailable);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _say(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(profileProvider).value;

    return Semantics(
      button: true,
      label: l10n.profileChangePhoto,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _saving ? null : _change,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DSSpacing.base,
            vertical: DSSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: colors.bgCanvas,
            borderRadius: BorderRadius.circular(DSRadius.md),
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Opacity(
                    opacity: _saving ? DSOpacity.disabled : 1,
                    child: DSAvatar(
                      name: profile?.fullName ?? '',
                      photoUrl: profile?.photoUrl,
                      size: DSAvatarSize.xl,
                    ),
                  ),
                  if (_saving)
                    Positioned.fill(
                      child: Center(
                        child: SizedBox.square(
                          dimension: DSSizes.iconMd,
                          child: CircularProgressIndicator(
                            strokeWidth: DSSizes.borderWidthThick,
                            color: colors.brandPrimary,
                          ),
                        ),
                      ),
                    ),
                  PositionedDirectional(
                    end: -DSSpacing.sm,
                    bottom: -DSSpacing.sm,
                    // Drawn only: the whole card takes the tap.
                    child: IgnorePointer(
                      child: DSIconButton(
                        icon: PhosphorIcons.pencilSimple(),
                        onPressed: () {},
                        semanticLabel: l10n.profileChangePhoto,
                        variant: DSIconButtonVariant.filled,
                        size: DSIconButtonSize.xxs,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DSSpacing.sm),
              Text(
                l10n.profileChangePhoto,
                style: DSTypography.bodySmSemibold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Where to take the photo from; the sheet closes with the choice.
class _PhotoSources extends StatelessWidget {
  const _PhotoSources();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DSLayout.margin,
        0,
        DSLayout.margin,
        DSSpacing.base,
      ),
      child: DSListGroup(
        children: [
          DSListItem(
            icon: PhosphorIcons.image(),
            title: l10n.profilePhotoFromGallery,
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
          DSListItem(
            icon: PhosphorIcons.camera(),
            title: l10n.profilePhotoFromCamera,
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
        ],
      ),
    );
  }
}
