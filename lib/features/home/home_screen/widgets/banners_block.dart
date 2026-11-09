import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../design_system/components/feedback/ds_skeleton.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/app_link.dart';
import '../../../../domain/entities/promo_banner.dart';
import '../banners_controller.dart';
import 'banner_card.dart';

/// Home's row of promo banners. Hidden when there are none or they fail to
/// load: they are promotion, Home works without them.
class BannersBlock extends ConsumerWidget {
  const BannersBlock({super.key});

  static const _padding = EdgeInsets.only(bottom: DSSpacing.lg);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bannersControllerProvider);
    final banners = state.value;

    if (banners == null) {
      return state.hasError ? const SizedBox.shrink() : const _Skeleton();
    }
    if (banners.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: _padding,
      child: SizedBox(
        height: BannerCard.height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          // Lets the card shadows show past the row's edges.
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
          itemCount: banners.length,
          separatorBuilder: (_, _) => const SizedBox(width: DSSpacing.sm),
          itemBuilder: (_, i) =>
              BannerCard(banner: banners[i], onTap: _tapAction(banners[i])),
        ),
      ),
    );
  }

  /// Web addresses open in the browser. Links to a product or a category
  /// open the menu, which is not built yet; until then such a banner is not
  /// tappable.
  static VoidCallback? _tapAction(PromoBanner banner) {
    final link = banner.link;
    if (link == null || link.type != AppLinkType.url) return null;
    final uri = Uri.tryParse(link.target);
    if (uri == null) return null;
    return () => launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: BannersBlock._padding,
      child: SizedBox(
        height: BannerCard.height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
          itemCount: 2,
          separatorBuilder: (_, _) => const SizedBox(width: DSSpacing.sm),
          itemBuilder: (_, _) => const DSSkeleton.box(
            width: DSSizes.bannerWidth,
            height: BannerCard.height,
          ),
        ),
      ),
    );
  }
}
