import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';

/// A picture from the network, cached on the device. One look for every
/// state without a picture: a recessed fill while loading, the same fill
/// with an image icon on error or without an address.
///
/// Fills the size it is given; the caller clips it (rounded corners, circle).
class DSNetworkImage extends StatelessWidget {
  const DSNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    if (url == null || url.isEmpty) return _placeholder(context, icon: true);

    // Decode at the displayed width only: giving both a width and a height
    // would decode to exactly that box and distort the picture.
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheWidth = width != null && width!.isFinite
        ? (width! * dpr).round()
        : null;

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: cacheWidth,
      placeholder: (context, _) => _placeholder(context, icon: false),
      errorWidget: (context, _, _) => _placeholder(context, icon: true),
    );
  }

  Widget _placeholder(BuildContext context, {required bool icon}) {
    final colors = context.colors;
    return Container(
      width: width,
      height: height,
      color: colors.bgSurfaceSunken,
      alignment: Alignment.center,
      child: icon
          ? Icon(
              PhosphorIcons.image(PhosphorIconsStyle.fill),
              size: DSSizes.iconMd,
              color: colors.textTertiary,
            )
          : null,
    );
  }
}
