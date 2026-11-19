import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/components/image/ds_network_image.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/state/menu_state.dart';

/// The photo of a product of a past order.
///
/// An order keeps no photos, so the photo is the one the product has in the
/// branch's menu now; a product that left the menu, or a menu that did not
/// load, shows the placeholder.
class OrderProductImage extends ConsumerWidget {
  const OrderProductImage({
    super.key,
    required this.branchId,
    required this.productId,
  });

  final String branchId;
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = branchId.isEmpty || productId.isEmpty
        ? null
        : ref.watch(menuProvider(branchId)).value;
    return ClipRRect(
      borderRadius: BorderRadius.circular(DSRadius.md),
      child: DSNetworkImage(
        url: menu?.product(productId)?.imageUrl,
        width: DSSizes.cartLineImage,
        height: DSSizes.cartLineImage,
      ),
    );
  }
}
