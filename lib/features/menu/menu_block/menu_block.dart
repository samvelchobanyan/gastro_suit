import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/components/inputs/ds_chip_tabs.dart';
import '../../../design_system/components/layout/ds_section_header.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/menu.dart';
import '../../../domain/entities/menu_category.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/state/menu_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../shared_widgets/load_error_row.dart';
import '../widgets/menu_product_card.dart';
import 'menu_block_skeleton.dart';
import 'menu_category_row.dart';

/// The menu of one branch, for a screen to embed: its title, the row of
/// categories and the products of the selected category in a grid, split
/// into sections when the category has subcategories.
///
/// A sliver: it goes into the screen's own scroll view and scrolls with the
/// rest of the page. The chips of the subcategories stay at the top of the
/// scroll view while the sections pass under them; a chip scrolls to its
/// section and the chip of the section on top is the selected one.
///
/// Loads and fails on its own; pull-to-refresh belongs to the screen, which
/// refreshes `menuProvider` of the same branch.
class MenuBlock extends ConsumerStatefulWidget {
  const MenuBlock({super.key, required this.branchId});

  final String branchId;

  @override
  ConsumerState<MenuBlock> createState() => _MenuBlockState();
}

class _MenuBlockState extends ConsumerState<MenuBlock> {
  /// Null until the user picks one: the first category is shown till then.
  String? _categoryId;

  /// The section whose chip is selected; null stands for the first one.
  String? _sectionId;

  /// The sections on screen, in order, with the key of each one's title.
  var _sections = const <_Section>[];
  final _sectionKeys = <String, GlobalKey>{};

  /// The scroll view the block sits in.
  ScrollPosition? _position;

  /// True while the page scrolls to a tapped chip's section: the sections
  /// passing by on the way do not take the selection.
  var _scrollingToSection = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (identical(position, _position)) return;
    _position?.removeListener(_selectSectionOnTop);
    _position = position;
    position?.addListener(_selectSectionOnTop);
  }

  @override
  void didUpdateWidget(MenuBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.branchId != widget.branchId) {
      _categoryId = null;
      _sectionId = null;
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_selectSectionOnTop);
    super.dispose();
  }

  /// Where the page must be scrolled for [sectionId]'s title to sit right
  /// under the chips; null while the section is not laid out.
  double? _scrollOffsetOf(String sectionId) {
    final title = _sectionKeys[sectionId]?.currentContext?.findRenderObject();
    if (title == null || !title.attached) return null;
    // The viewport already leaves room for what is pinned above the title,
    // the chips included.
    return RenderAbstractViewport.of(title).getOffsetToReveal(title, 0).offset;
  }

  /// Selects the chip of the last section whose title has reached the chips.
  void _selectSectionOnTop() {
    final position = _position;
    if (position == null || _scrollingToSection || _sections.length < 2) {
      return;
    }
    // The position can also move while the page is being laid out (its
    // content got shorter); the sections are measured after that frame.
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) _selectSectionOnTop();
      });
      return;
    }
    var onTop = _sections.first.id;
    for (final section in _sections.skip(1)) {
      final offset = _scrollOffsetOf(section.id);
      // A title counts as reached a little before it touches the chips.
      if (offset == null || offset > position.pixels + DSSpacing.sm) break;
      onTop = section.id;
    }
    if (onTop != (_sectionId ?? _sections.first.id)) {
      setState(() => _sectionId = onTop);
    }
  }

  Future<void> _scrollToSection(String sectionId) async {
    setState(() => _sectionId = sectionId);
    final position = _position;
    final offset = _scrollOffsetOf(sectionId);
    if (position == null || offset == null) return;

    final target = offset.clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (MediaQuery.disableAnimationsOf(context)) {
      _scrollingToSection = true;
      position.jumpTo(target);
      _scrollingToSection = false;
      return;
    }
    _scrollingToSection = true;
    try {
      await position.animateTo(
        target,
        duration: DSMotion.base,
        curve: DSMotion.standard,
      );
    } finally {
      _scrollingToSection = false;
    }
  }

  void _selectCategory(String categoryId) => setState(() {
    _categoryId = categoryId;
    // The new category opens on its first section.
    _sectionId = null;
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final state = ref.watch(menuProvider(widget.branchId));
    final menu = state.value;

    if (menu == null) {
      _sections = const [];
      return SliverToBoxAdapter(
        child: state.hasError
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DSLayout.margin,
                ),
                child: LoadErrorRow(
                  onRetry: () => ref.invalidate(menuProvider(widget.branchId)),
                ),
              )
            : const MenuBlockSkeleton(),
      );
    }

    final categories = menu.rootCategories;
    final category =
        categories.where((c) => c.id == _categoryId).firstOrNull ??
        categories.firstOrNull;
    _sections = category == null ? const [] : _sectionsOf(menu, category);
    final selectedSectionId =
        _sections.where((s) => s.id == _sectionId).firstOrNull?.id ??
        _sections.firstOrNull?.id;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              DSLayout.margin,
              0,
              DSLayout.margin,
              DSSpacing.sm,
            ),
            child: DSSectionHeader(title: l10n.menuTitle),
          ),
        ),
        if (category != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: DSSpacing.sm),
              child: MenuCategoryRow(
                categories: categories,
                selectedId: category.id,
                onSelected: _selectCategory,
              ),
            ),
          ),
        if (_sections.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(DSLayout.margin),
              child: Text(
                l10n.menuEmpty,
                style: DSTypography.body.copyWith(color: colors.textTertiary),
              ),
            ),
          ),
        if (_sections.length > 1)
          PinnedHeaderSliver(
            child: ColoredBox(
              // Opaque: the sections pass under the chips.
              color: colors.bgSurface,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: DSSpacing.sm,
                  bottom: DSSpacing.base,
                ),
                child: DSChipTabs<String>(
                  options: [
                    for (final section in _sections)
                      DSChipTab(value: section.id, label: section.title),
                  ],
                  value: selectedSectionId,
                  onChanged: _scrollToSection,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DSLayout.margin,
                  ),
                ),
              ),
            ),
          ),
        for (final section in _sections) ...[
          SliverToBoxAdapter(
            child: Padding(
              key: _sectionKeys.putIfAbsent(section.id, GlobalKey.new),
              padding: const EdgeInsets.fromLTRB(
                DSLayout.margin,
                0,
                DSLayout.margin,
                DSSpacing.sm,
              ),
              child: Text(
                section.title,
                style: DSTypography.bodySemibold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          _ProductGrid(products: section.products),
        ],
      ],
    );
  }
}

/// One titled grid of the selected category: the category's own products,
/// or the products of one of its subcategories.
class _Section {
  const _Section({
    required this.id,
    required this.title,
    required this.products,
  });

  /// The id of the category or subcategory the products sit in.
  final String id;
  final String title;
  final List<Product> products;
}

/// The sections of [category]: its own products first, then each of its
/// subcategories. A section without products is left out.
List<_Section> _sectionsOf(Menu menu, MenuCategory category) => [
  for (final c in [category, ...menu.subcategoriesOf(category.id)])
    if (menu.productsIn(c.id) case final products when products.isNotEmpty)
      _Section(id: c.id, title: c.name, products: products),
];

/// Products in two columns; the cards are built as they scroll into view.
class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});

  final List<Product> products;

  static const _columns = 2;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        DSLayout.margin,
        0,
        DSLayout.margin,
        DSSpacing.base,
      ),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final cardWidth =
              (constraints.crossAxisExtent - DSLayout.gutter * (_columns - 1)) /
              _columns;
          return SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _columns,
              crossAxisSpacing: DSLayout.gutter,
              mainAxisSpacing: DSLayout.gutter,
              mainAxisExtent: MenuProductCard.heightFor(cardWidth, textScaler),
            ),
            itemCount: products.length,
            itemBuilder: (context, i) => MenuProductCard(
              product: products[i],
              // The product screen is not built yet.
              onTap: () {},
              // The cart is not built yet: the quantity stays at zero and
              // the control does nothing.
              quantity: 0,
              onQuantityChanged: (_) {},
            ),
          );
        },
      ),
    );
  }
}
