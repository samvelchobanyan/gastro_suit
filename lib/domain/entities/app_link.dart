import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_link.freezed.dart';

enum AppLinkType { product, category, url }

/// Where a tap leads (a story's button, a banner): a product, a menu category
/// or a web address. Shared by stories and banners.
@freezed
abstract class AppLink with _$AppLink {
  const factory AppLink({
    required AppLinkType type,

    /// The product's or category's id, or the web address.
    required String target,
  }) = _AppLink;
}
