import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_category.freezed.dart';

/// A category of a menu. Categories form at most two levels: a category and
/// its subcategories (DOMAIN_SPEC §2).
@freezed
abstract class MenuCategory with _$MenuCategory {
  const factory MenuCategory({
    required String id,
    required String name,
    String? imageUrl,

    /// The category this one is a subcategory of; null for a top-level one.
    String? parentId,
  }) = _MenuCategory;
}
