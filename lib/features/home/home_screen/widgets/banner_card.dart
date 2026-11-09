import 'package:flutter/material.dart';

import '../../../../design_system/components/image/ds_network_image.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/promo_banner.dart';

/// One promo banner on Home: a rounded picture on a card shadow.
class BannerCard extends StatelessWidget {
  const BannerCard({super.key, required this.banner, this.onTap});

  final PromoBanner banner;

  /// Null — the banner is not tappable.
  final VoidCallback? onTap;

  /// The API's banner pictures are 512:264.
  static const double aspectRatio = 512 / 264;
  static const double height = DSSizes.bannerWidth / aspectRatio;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(DSRadius.md);
    return Semantics(
      image: true,
      button: onTap != null,
      label: banner.title,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: DSElevation.card,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: DSNetworkImage(
              url: banner.imageUrl,
              width: DSSizes.bannerWidth,
              height: height,
            ),
          ),
        ),
      ),
    );
  }
}
