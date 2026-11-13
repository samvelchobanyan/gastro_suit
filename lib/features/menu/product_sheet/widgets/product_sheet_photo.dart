import 'package:flutter/material.dart';

import '../../../../design_system/components/image/ds_network_image.dart';
import '../../../../design_system/components/overlays/ds_tall_sheet.dart';
import '../../../../design_system/ds_extensions.dart';

/// The top of the product sheet: the product's photo, whole, in a square
/// on a dark fill, with the sheet's handle over it.
class ProductSheetPhoto extends StatelessWidget {
  const ProductSheetPhoto({super.key, required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
          ],
        ),
      ),
    );
  }
}
