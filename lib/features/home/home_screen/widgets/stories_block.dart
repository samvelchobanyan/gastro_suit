import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/components/feedback/ds_skeleton.dart';
import '../../../../design_system/ds_extensions.dart';
import '../stories_controller.dart';
import 'story_circle.dart';

/// Home's row of stories. Hidden when there are none or they fail to load:
/// they are promotion, Home works without them.
class StoriesBlock extends ConsumerWidget {
  const StoriesBlock({super.key});

  static const _padding = EdgeInsets.only(
    top: DSSpacing.sm,
    bottom: DSSpacing.base,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storiesControllerProvider);
    final stories = state.value;

    if (stories == null) {
      return state.hasError ? const SizedBox.shrink() : const _Skeleton();
    }
    if (stories.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: _padding,
      child: SizedBox(
        height: StoryCircle.height(context),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
          itemCount: stories.length,
          separatorBuilder: (_, _) => const SizedBox(width: DSSpacing.sm),
          // The full-screen story viewer comes in its own step.
          itemBuilder: (_, i) => StoryCircle(story: stories[i]),
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: StoriesBlock._padding,
      child: SizedBox(
        height: StoryCircle.height(context),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
          itemCount: 5,
          separatorBuilder: (_, _) => const SizedBox(width: DSSpacing.sm),
          itemBuilder: (context, _) => SizedBox(
            width: DSSizes.storyItemWidth,
            child: Column(
              children: [
                const DSSkeleton.circle(diameter: DSSizes.storyCircle),
                const SizedBox(height: DSSpacing.xs),
                // A title line: a bar of text height, centred in the line.
                SizedBox(
                  height: StoryCircle.labelLineHeight(context),
                  child: const Center(
                    child: DSSkeleton.box(
                      width: DSSizes.storyItemWidth - DSSpacing.base,
                      height: DSSpacing.md,
                      radius: DSRadius.xs,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
