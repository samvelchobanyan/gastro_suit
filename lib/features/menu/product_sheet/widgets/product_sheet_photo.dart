import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../design_system/components/buttons/ds_icon_button.dart';
import '../../../../design_system/components/image/ds_network_image.dart';
import '../../../../design_system/components/overlays/ds_tall_sheet.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// The top of the product sheet: the product's photo, whole, in a square
/// on a dark fill, with the sheet's handle over it and the heart in its
/// corner, filled when the product is a favourite.
class ProductSheetPhoto extends StatelessWidget {
  const ProductSheetPhoto({
    super.key,
    required this.url,
    required this.favorite,
    required this.onFavorite,
  });

  final String? url;
  final bool favorite;

  /// Makes the product a favourite, or takes it out.
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    return AspectRatio(
      aspectRatio: 1,
      child: ColoredBox(
        color: colors.bgInverse,
        child: Stack(
          fit: StackFit.expand,
          children: [
            LayoutBuilder(
              builder: (context, constraints) => DSNetworkImage(
                url: url,
                width: constraints.maxWidth,
                height: constraints.maxWidth,
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: DSSpacing.sm),
                child: DSSheetHandle(color: colors.handleOnDark),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Padding(
                padding: const EdgeInsets.all(DSSpacing.base),
                child: DSIconButton(
                  icon: PhosphorIcons.heart(),
                  onPressed: onFavorite,
                  semanticLabel: favorite
                      ? l10n.favoriteRemove
                      : l10n.favoriteAdd,
                  variant: favorite
                      ? DSIconButtonVariant.filled
                      : DSIconButtonVariant.tonal,
                  size: DSIconButtonSize.xs,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
