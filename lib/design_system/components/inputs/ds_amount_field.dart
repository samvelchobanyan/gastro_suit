import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ds_extensions.dart';

/// A one-line field for a whole amount of money (handoff `Input`, 40 high,
/// with the currency sign at its end): digits only, on the main
/// background, a hairline border that turns to the interactive colour when
/// focused.
class DSAmountField extends StatelessWidget {
  const DSAmountField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.suffix,
    this.hintText,
    this.maxDigits = 6,
  });

  /// Holds the text; owned by whoever uses the field.
  final TextEditingController controller;

  /// Called with the amount typed; null while the field is empty.
  final ValueChanged<int?> onChanged;

  /// The currency sign, shown at the field's end.
  final String suffix;
  final String? hintText;
  final int maxDigits;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(DSRadius.input),
      borderSide: BorderSide(color: color, width: width),
    );

    return SizedBox(
      height: DSSizes.inputHeightCompact,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(maxDigits),
        ],
        onChanged: (text) => onChanged(int.tryParse(text)),
        style: DSTypography.body.copyWith(color: colors.textPrimary),
        cursorColor: colors.borderInteractive,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: colors.bgMain,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DSSpacing.base,
          ),
          hintText: hintText,
          hintStyle: DSTypography.body.copyWith(color: colors.textTertiary),
          suffixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(end: DSSpacing.base),
            child: Text(
              suffix,
              style: DSTypography.bodySm.copyWith(color: colors.textTertiary),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(),
          enabledBorder: border(
            colors.borderDefault,
            DSSizes.borderWidthDefault,
          ),
          focusedBorder: border(
            colors.borderInteractive,
            DSSizes.borderWidthFocus,
          ),
        ),
      ),
    );
  }
}
