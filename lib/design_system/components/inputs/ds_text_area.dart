import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ds_extensions.dart';

/// A text field several lines high (handoff `Textarea`, four rows). Longer
/// text scrolls inside it.
///
/// The handoff's label, helper text, error state and counter are added when
/// a screen needs them.
class DSTextArea extends StatelessWidget {
  const DSTextArea({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLength,
    this.enabled = true,
  });

  /// Holds the text; owned by whoever uses the field.
  final TextEditingController controller;

  /// Shown while the field is empty.
  final String? hintText;

  /// The most characters the field takes; typing stops there. No counter is
  /// shown.
  final int? maxLength;

  /// A disabled field is dimmed and cannot be edited.
  final bool enabled;

  static const _lines = 4;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxLength = this.maxLength;

    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(DSRadius.input),
      borderSide: BorderSide(color: color, width: width),
    );
    final idle = border(colors.borderDefault, DSSizes.borderWidthDefault);

    final field = TextField(
      controller: controller,
      enabled: enabled,
      minLines: _lines,
      maxLines: _lines,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ],
      style: DSTypography.bodySm.copyWith(color: colors.textPrimary),
      cursorColor: colors.borderInteractive,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: colors.bgMain,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DSSpacing.base,
          vertical: DSSpacing.sm,
        ),
        hintText: hintText,
        hintStyle: DSTypography.bodySm.copyWith(color: colors.textTertiary),
        enabledBorder: idle,
        disabledBorder: idle,
        focusedBorder: border(
          colors.borderInteractive,
          DSSizes.borderWidthFocus,
        ),
      ),
    );

    return enabled ? field : Opacity(opacity: DSOpacity.disabled, child: field);
  }
}
