import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';

/// How tall a [DSTextField] is: the handoff `Input`'s `sm` (40) and `lg`
/// (48). Its `md` (44) is added when a screen needs it.
enum DSTextFieldSize { sm, lg }

/// A one-line text field (handoff `Input`), drawn like the dropdown it
/// stands next to.
///
/// The handoff's label, helper text and error state are added when a
/// screen needs them.
class DSTextField extends StatelessWidget {
  const DSTextField({
    super.key,
    required this.controller,
    this.size = DSTextFieldSize.sm,
    this.focusNode,
    this.onChanged,
    this.hintText,
    this.prefixText,
    this.leadingIcon,
    this.onClear,
    this.clearLabel,
    this.maxLength,
    this.digitsOnly = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
    this.autofocus = false,
    this.enabled = true,
  });

  /// Holds the text; owned by whoever uses the field.
  final TextEditingController controller;
  final DSTextFieldSize size;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  /// Shown while the field is empty and not being typed in.
  final String? hintText;

  /// Fixed text before what is typed (a phone number's country code); shown
  /// once the field has the focus or holds text.
  final String? prefixText;

  /// Drawn before the text.
  final IconData? leadingIcon;

  /// With a handler the field shows a cross at its end while it holds
  /// text. The handler empties the field; [clearLabel] names the cross for
  /// screen readers.
  final VoidCallback? onClear;
  final String? clearLabel;

  /// The most characters the field takes; typing stops there. No counter is
  /// shown.
  final int? maxLength;

  /// Anything but a digit is not taken.
  final bool digitsOnly;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final bool autofocus;

  /// A disabled field is dimmed and cannot be edited.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxLength = this.maxLength;
    final leadingIcon = this.leadingIcon;
    final onClear = this.onClear;
    final (height, verticalPadding) = switch (size) {
      DSTextFieldSize.sm => (DSSizes.inputHeightCompact, DSSpacing.sm),
      DSTextFieldSize.lg => (DSSizes.inputHeightFixed, DSSpacing.md),
    };

    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(DSRadius.input),
      borderSide: BorderSide(color: color, width: width),
    );
    final idle = border(colors.borderDefault, DSSizes.borderWidthDefault);
    final textStyle = DSTypography.bodySm.copyWith(color: colors.textPrimary);

    final field = ListenableBuilder(
      listenable: controller,
      builder: (context, _) => TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        enabled: enabled,
        autofocus: autofocus,
        autofillHints: autofillHints,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        inputFormatters: [
          if (digitsOnly) FilteringTextInputFormatter.digitsOnly,
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ],
        style: textStyle,
        cursorColor: colors.borderInteractive,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: colors.bgMain,
          constraints: BoxConstraints(minHeight: height),
          contentPadding: EdgeInsets.symmetric(
            horizontal: DSSpacing.base,
            vertical: verticalPadding,
          ),
          hintText: hintText,
          hintStyle: DSTypography.bodySm.copyWith(color: colors.textTertiary),
          prefixText: prefixText,
          prefixStyle: textStyle,
          prefixIcon: leadingIcon == null
              ? null
              : Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: DSSpacing.base,
                    end: DSSpacing.sm,
                  ),
                  child: Icon(
                    leadingIcon,
                    size: DSSizes.iconSm,
                    color: colors.textTertiary,
                  ),
                ),
          prefixIconConstraints: const BoxConstraints(),
          suffixIcon: onClear == null || controller.text.isEmpty
              ? null
              : Semantics(
                  button: true,
                  label: clearLabel,
                  excludeSemantics: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onClear,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: DSSpacing.xs,
                      ),
                      child: SizedBox.square(
                        dimension: DSSizes.buttonHeightXs,
                        child: Icon(
                          PhosphorIcons.x(),
                          size: DSSizes.iconSm,
                          color: colors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ),
          suffixIconConstraints: const BoxConstraints(),
          enabledBorder: idle,
          disabledBorder: idle,
          focusedBorder: border(
            colors.borderInteractive,
            DSSizes.borderWidthFocus,
          ),
        ),
      ),
    );

    return enabled ? field : Opacity(opacity: DSOpacity.disabled, child: field);
  }
}
