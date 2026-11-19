import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';
import 'ds_network_image.dart';

/// The handoff's other sizes are added when used.
enum DSAvatarSize { md, xl }

/// A person in a circle (handoff `Avatar`): their photo, without one their
/// initials, without a name a person icon.
class DSAvatar extends StatelessWidget {
  const DSAvatar({
    super.key,
    required this.name,
    this.photoUrl,
    this.size = DSAvatarSize.md,
  });

  /// The person's full name; the initials are taken from it.
  final String name;
  final String? photoUrl;
  final DSAvatarSize size;

  /// The first letters of the first two words of [name], in upper case.
  static String initialsOf(String name) => name
      .split(' ')
      .where((word) => word.isNotEmpty)
      .take(2)
      .map((word) => word.characters.first.toUpperCase())
      .join();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final photoUrl = this.photoUrl;
    final initials = initialsOf(name);
    final (diameter, initialsStyle, iconSize) = switch (size) {
      DSAvatarSize.md => (
        DSSizes.avatarMd,
        DSTypography.bodySemibold,
        DSSizes.iconSm,
      ),
      DSAvatarSize.xl => (DSSizes.avatarXl, DSTypography.h1, DSSizes.iconLg),
    };
    return ExcludeSemantics(
      child: ClipOval(
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: photoUrl != null
              ? DSNetworkImage(url: photoUrl, width: diameter, height: diameter)
              : ColoredBox(
                  color: colors.brandSubtle,
                  child: Center(
                    child: initials.isNotEmpty
                        ? Text(
                            initials,
                            style: initialsStyle.copyWith(
                              color: colors.textAccent,
                            ),
                          )
                        : Icon(
                            PhosphorIcons.user(),
                            size: iconSize,
                            color: colors.textAccent,
                          ),
                  ),
                ),
        ),
      ),
    );
  }
}
