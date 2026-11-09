import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// A loading placeholder shape with a light band sweeping across it (handoff
/// `Skeleton`).
///
/// Only the shape: each block builds its own skeleton from these, matching
/// its real layout, so nothing jumps when the data arrives.
class DSSkeleton extends StatefulWidget {
  const DSSkeleton.box({
    super.key,
    required this.width,
    required this.height,
    this.radius = DSRadius.md,
  }) : _circle = false;

  const DSSkeleton.circle({super.key, required double diameter})
    : width = diameter,
      height = diameter,
      radius = 0,
      _circle = true;

  final double width;
  final double height;
  final double radius;
  final bool _circle;

  /// One sweep of the band, as in the handoff.
  static const _period = Duration(milliseconds: 1400);

  @override
  State<DSSkeleton> createState() => _DSSkeletonState();
}

class _DSSkeletonState extends State<DSSkeleton>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: DSSkeleton._period,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No sweep when the system asks for reduced motion.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shape = widget._circle
        ? const BoxDecoration(shape: BoxShape.circle)
        : BoxDecoration(borderRadius: BorderRadius.circular(widget.radius));
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Container(
          width: widget.width,
          height: widget.height,
          decoration: shape.copyWith(
            gradient: LinearGradient(
              colors: [
                colors.skeletonBase,
                colors.skeletonHighlight,
                colors.skeletonBase,
              ],
              stops: const [0.35, 0.5, 0.65],
              transform: _Sweep(_controller.value),
            ),
          ),
        ),
      ),
    );
  }
}

/// Moves the gradient from one shape-width left of the shape to one right.
class _Sweep extends GradientTransform {
  const _Sweep(this.progress);

  final double progress;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * (progress * 2 - 1), 0, 0);
}
