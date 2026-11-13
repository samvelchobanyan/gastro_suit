import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// Opens a sheet over the whole app that leaves only a strip of the screen
/// above it (handoff `ProductOverlay`, `BasketOverlay`): the surface with
/// rounded top corners, as tall as the screen allows.
///
/// [builder] gets the scroll controller its scrolling content must use:
/// dragged down from the top of that content, or flung down, the sheet
/// closes; a short drag lets it come back. What the content keeps outside
/// the scroll view (a bar at the bottom) stays in place.
Future<T?> showDSTallSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext context, ScrollController scroll)
  builder,
}) {
  // The status bar's height as the screen has it: the caller's own
  // `MediaQuery` may have had it taken out by a `SafeArea` above.
  final screen = MediaQueryData.fromView(View.of(context));
  final colors = context.colors;
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    barrierColor: colors.bgScrim,
    constraints: BoxConstraints(
      maxHeight: screen.size.height - screen.padding.top - DSSpacing.xl,
    ),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 1,
      minChildSize: _closeBelow,
      snap: true,
      builder: (context, scroll) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(DSRadius.lg),
        ),
        child: ColoredBox(
          color: colors.bgSurface,
          child: builder(context, scroll),
        ),
      ),
    ),
  );
}

/// How much of its height the sheet keeps before a drag down closes it.
const _closeBelow = 0.5;

/// The short bar at the top of a sheet that says it can be dragged.
class DSSheetHandle extends StatelessWidget {
  const DSSheetHandle({super.key, required this.color});

  /// `borderStrong` on the surface; `handleOnDark` over a photo.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DSSizes.sheetHandleWidth,
      height: DSSizes.sheetHandleHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(DSRadius.full),
      ),
    );
  }
}
