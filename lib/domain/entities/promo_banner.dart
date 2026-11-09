import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_link.dart';

part 'promo_banner.freezed.dart';

/// A promotional picture on Home (DOMAIN_SPEC §7, "Banner"). Named
/// `PromoBanner` because Flutter already has a `Banner` widget.
@freezed
abstract class PromoBanner with _$PromoBanner {
  const factory PromoBanner({
    required String id,
    required String imageUrl,

    /// The picture's text for accessibility; not shown.
    String? title,

    /// No link — the banner is not tappable.
    AppLink? link,
  }) = _PromoBanner;
}
