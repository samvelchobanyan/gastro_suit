import 'package:flutter/material.dart';

import '../../../../design_system/components/image/ds_network_image.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/story.dart';

/// One story in Home's row (handoff `Stories`): the cover in a ring — brand
/// colour while new, grey once seen — and the title under it.
class StoryCircle extends StatelessWidget {
  const StoryCircle({super.key, required this.story, this.onTap});

  final Story story;
  final VoidCallback? onTap;

  /// Height of the whole item: circle, gap, one line of title at the
  /// system's text scale.
  static double height(BuildContext context) =>
      DSSizes.storyCircle + DSSpacing.xs + labelLineHeight(context);

  static double labelLineHeight(BuildContext context) {
    const style = DSTypography.bodySm;
    return MediaQuery.textScalerOf(context).scale(style.fontSize!) *
        style.height!;
  }

  /// The ring and the white gap inside it, each this wide.
  static const double _ring = DSSizes.borderWidthThick;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = story.title;
    const imageSize = DSSizes.storyCircle - _ring * 4;

    return Semantics(
      button: onTap != null,
      label: title,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: DSSizes.storyItemWidth,
          child: Column(
            children: [
              Container(
                width: DSSizes.storyCircle,
                height: DSSizes.storyCircle,
                padding: const EdgeInsets.all(_ring),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: story.isSeen
                      ? colors.borderDefault
                      : colors.brandPrimary,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.bgSurface, width: _ring),
                  ),
                  child: ClipOval(
                    child: DSNetworkImage(
                      url: story.coverUrl,
                      width: imageSize,
                      height: imageSize,
                    ),
                  ),
                ),
              ),
              if (title != null) ...[
                const SizedBox(height: DSSpacing.xs),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: DSTypography.bodySm.copyWith(
                    color: story.isSeen
                        ? colors.textTertiary
                        : colors.textPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
