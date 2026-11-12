import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../design_system/components/buttons/ds_icon_button.dart';
import '../../design_system/components/inputs/ds_stepper.dart';
import '../../l10n/generated/app_localizations.dart';

/// The control on a product card that puts the product in the cart: a plus
/// while the cart holds none of it, a stepper with the quantity after.
///
/// Keeps no quantity of its own; see [DSStepper].
class ProductQuantityButton extends StatelessWidget {
  const ProductQuantityButton({
    super.key,
    required this.quantity,
    required this.onChanged,
    required this.addButtonSize,
  });

  /// How many of the product the cart holds.
  final int quantity;

  /// Called with the quantity the user asked for: 1 from the plus, one more
  /// or one less from the stepper.
  final ValueChanged<int> onChanged;

  /// The size of the plus; the stepper has one size.
  final DSIconButtonSize addButtonSize;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (quantity < 1) {
      return DSIconButton(
        icon: PhosphorIcons.plus(),
        semanticLabel: l10n.addToCart,
        variant: DSIconButtonVariant.filled,
        size: addButtonSize,
        onPressed: () => onChanged(1),
      );
    }
    return DSStepper(
      value: quantity,
      onChanged: onChanged,
      decreaseLabel: l10n.quantityDecrease,
      increaseLabel: l10n.quantityIncrease,
    );
  }
}
