/// Component dimensions, icon sizes and strokes. Source: handoff `tokens/sizing.css`.
abstract final class DSSizes {
  /// Minimum size of anything tappable.
  static const double touchTargetMin = 48;

  // Button heights
  static const double buttonHeightLg = 56;
  static const double buttonHeightMd = 48;
  static const double buttonHeightSm = 40;
  static const double buttonHeightXs = 36;
  static const double buttonHeightXxs = 32;

  /// `--button-height-2xs` in the handoff.
  static const double buttonHeight2xs = 24;

  // Inputs
  static const double inputHeightFloating = 56;
  static const double inputHeightFixed = 48;
  static const double inputPaddingX = 16;
  static const double inputPaddingY = 12;

  // Bars
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 48;

  // Home header (handoff `Greeting`)
  static const double headerLogo = 44;
  static const double headerAction = 44;

  /// The unread dot on a notification icon.
  static const double notificationDot = 9;

  // Home rails (handoff `Stories`, Home promo banners)
  static const double storyCircle = 64;

  /// A story's circle plus room for its label.
  static const double storyItemWidth = 72;
  static const double bannerWidth = 280;

  /// The photo on a branch card (`BranchCard`).
  static const double branchImage = 72;

  /// The photo on a branch row in the branch picker (`BranchSelectorCard`).
  static const double branchImageSm = 44;

  /// The branch picker's list grows up to this, then scrolls.
  static const double branchPickerListMaxHeight = 320;

  /// The photo header of a branch's screen (`RestaurantHeader`).
  static const double branchHeaderHeight = 260;

  // Menu (handoff `MenuTabsVertical`, `ProductVerticalCard`)
  static const double menuCategoryImage = 56;

  /// A category's image plus room for its label.
  static const double menuCategoryItemWidth = 64;

  /// A product card in a sideways rail.
  static const double productRailCardWidth = 128;

  /// The height of a count badge (`Badge`).
  static const double badge = 18;

  // Dropdown (handoff `Dropdown`)
  static const double inputHeightCompact = 40;
  static const double menuItemHeight = 44;
  static const double menuMaxHeight = 240;

  // Radio (handoff `RadioButton`)
  static const double radio = 20;
  static const double radioDot = 10;

  // Bottom sheet (handoff `BottomSheet`)
  static const double sheetHandleWidth = 36;
  static const double sheetHandleHeight = 4;

  /// The most of the screen's height a sheet takes.
  static const double sheetMaxHeightFraction = 0.88;

  // Rows and list items
  static const double rowHeightCompact = 48;
  static const double rowHeightIcon = 56;
  static const double rowHeightTwoLine = 72;
  static const double rowHeightMulti = 88;
  static const double listItemHeight = 56;
  static const double listItemHeightTwoLine = 72;

  // Icons
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 40;

  // Strokes
  static const double borderWidthDefault = 1;
  static const double borderWidthFocus = 2;
  static const double borderWidthThick = 2;
  static const double focusRingOffset = 2;

  /// Diameter of a voucher's side cut-out.
  static const double notchSize = 20;
}
