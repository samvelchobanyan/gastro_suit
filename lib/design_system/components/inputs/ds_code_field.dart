import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ds_extensions.dart';

/// A code of [length] digits, one square cell per digit (handoff
/// `InputCode`, placed side by side): the code from an SMS.
///
/// One field behind the cells takes the typing, so a code pasted or filled
/// in by the system from the SMS lands in all the cells at once, and
/// backspace takes the last digit back. The cell the next digit goes to is
/// outlined while the field has the focus.
///
/// The cells are 48 wide and shrink together on a screen too narrow for
/// them.
class DSCodeField extends StatefulWidget {
  const DSCodeField({
    super.key,
    required this.controller,
    required this.length,
    required this.semanticLabel,
    this.focusNode,
    this.onChanged,
    this.onCompleted,
    this.error = false,
    this.enabled = true,
    this.autofocus = false,
  });

  /// Holds the digits typed so far; owned by whoever uses the field.
  final TextEditingController controller;
  final int length;

  /// What the field is, for screen readers.
  final String semanticLabel;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  /// Called with the whole code when its last digit is entered.
  final ValueChanged<String>? onCompleted;

  /// Every cell is outlined as wrong.
  final bool error;

  /// A disabled field is dimmed and takes no typing.
  final bool enabled;
  final bool autofocus;

  @override
  State<DSCodeField> createState() => _DSCodeFieldState();
}

class _DSCodeFieldState extends State<DSCodeField> {
  FocusNode? _ownFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_redraw);
    _focusNode.addListener(_redraw);
  }

  @override
  void didUpdateWidget(DSCodeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_redraw);
      widget.controller.addListener(_redraw);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_redraw);
      _focusNode.addListener(_redraw);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_redraw);
    _focusNode.removeListener(_redraw);
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _redraw() => setState(() {});

  void _changed(String code) {
    widget.onChanged?.call(code);
    if (code.length == widget.length) widget.onCompleted?.call(code);
  }

  @override
  Widget build(BuildContext context) {
    final code = widget.controller.text;
    final focused = _focusNode.hasFocus;

    final cells = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0) const SizedBox(width: DSSpacing.sm),
          Flexible(
            child: _Cell(
              digit: i < code.length ? code[i] : '',
              // The last cell stays outlined while the code is whole.
              active:
                  focused &&
                  (i == code.length ||
                      (i == widget.length - 1 && code.length == widget.length)),
              error: widget.error,
            ),
          ),
        ],
      ],
    );

    final field = Stack(
      children: [
        cells,
        // The field itself is not seen: the cells show what it holds.
        Positioned.fill(
          child: Semantics(
            label: widget.semanticLabel,
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              onChanged: _changed,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.length),
              ],
              showCursor: false,
              enableInteractiveSelection: false,
              style: const TextStyle(color: Colors.transparent),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
              expands: true,
              maxLines: null,
            ),
          ),
        ),
      ],
    );

    return widget.enabled
        ? field
        : Opacity(opacity: DSOpacity.disabled, child: field);
  }
}

/// One digit's square.
class _Cell extends StatelessWidget {
  const _Cell({required this.digit, required this.active, required this.error});

  final String digit;
  final bool active;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DSSizes.inputHeightFixed),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.bgMain,
            borderRadius: BorderRadius.circular(DSRadius.input),
            border: Border.all(
              color: error
                  ? colors.statusError
                  : active
                  ? colors.borderInteractive
                  : colors.borderDefault,
              width: active
                  ? DSSizes.borderWidthFocus
                  : DSSizes.borderWidthDefault,
            ),
          ),
          child: ExcludeSemantics(
            child: Text(
              digit,
              style: DSTypography.h3.copyWith(color: colors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
