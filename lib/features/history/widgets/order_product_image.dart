import 'package:flutter/material.dart';

import '../../../design_system/components/image/ds_network_image.dart';
import '../../../design_system/ds_extensions.dart';

/// The photo of a product of a past order, as the order's line gives it;
/// the placeholder for a line without one.
class OrderProductImage extends StatelessWidget {
  const OrderProductImage({super.key, required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DSRadius.md),
      child: DSNetworkImage(
        url: url,
        width: DSSizes.cartLineImage,
        height: DSSizes.cartLineImage,
      ),
    );
  }
}
