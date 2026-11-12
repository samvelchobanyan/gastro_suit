import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../ds_extensions.dart';

/// Opens [child] in a [DSBottomSheet] over the whole app, tab bar included.
/// Completes with what the sheet is closed with (`Navigator.pop(context, x)`).
///
/// [enableDrag] is turned off for content that takes drags itself (a map):
/// the sheet then closes with its close button or a tap outside.
Future<T?> showDSBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  bool enableDrag = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    enableDrag: enableDrag,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    barrierColor: context.colors.bgScrim,
    constraints: BoxConstraints(
      maxHeight:
          MediaQuery.sizeOf(context).height * DSSizes.sheetMaxHeightFraction,
    ),
    builder: (_) => DSBottomSheet(title: title, child: child),
  );
}

/// The frame every sheet shares (handoff `BottomSheet`): a handle, a title
/// with a close button, and the content. Opened with [showDSBottomSheet].
///
/// The frame does not scroll: the content gets the height left under the
/// title and decides itself what scrolls, so a list can shrink to fit a
/// small screen instead of scrolling inside a scrolling sheet. Content that
/// may be taller than that wraps itself in a scroll view.
class DSBottomSheet extends StatelessWidget {
  const DSBottomSheet({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.bgSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(DSRadius.sheet),
        ),
        boxShadow: DSElevation.sheet,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: DSSpacing.md),
            child: Container(
              width: DSSizes.sheetHandleWidth,
              height: DSSizes.sheetHandleHeight,
              decoration: BoxDecoration(
                color: colors.borderStrong,
                borderRadius: BorderRadius.circular(DSRadius.full),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DSSpacing.lg,
              vertical: DSSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: DSTypography.h3.copyWith(
                        fontWeight: DSTypography.semibold,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
                Semantics(
                  button: true,
                  label: MaterialLocalizations.of(context).closeButtonTooltip,
                  excludeSemantics: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.pop(context),
                    child: SizedBox.square(
                      dimension: DSSizes.buttonHeightSm,
                      child: Icon(
                        PhosphorIcons.x(),
                        size: DSSizes.iconMd,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                DSSpacing.lg,
                0,
                DSSpacing.lg,
                DSSpacing.lg + bottomInset,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
