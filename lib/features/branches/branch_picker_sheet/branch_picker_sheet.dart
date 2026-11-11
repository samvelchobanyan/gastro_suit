import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/components/buttons/ds_button.dart';
import '../../../design_system/components/inputs/ds_chip_tabs.dart';
import '../../../design_system/components/inputs/ds_dropdown.dart';
import '../../../design_system/components/inputs/ds_option.dart';
import '../../../design_system/components/overlays/ds_bottom_sheet.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/branch.dart';
import '../../../domain/entities/city.dart';
import '../../../domain/state/active_branch_state.dart';
import '../../../domain/state/branches_state.dart';
import '../../../domain/state/cities_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../shared_widgets/branch_select_tile.dart';

/// Opens the branch picker in a sheet. Choosing a branch makes it the active
/// branch for the session.
Future<void> showBranchPicker(BuildContext context) => showDSBottomSheet<void>(
  context: context,
  title: AppLocalizations.of(context).chooseBranch,
  child: const BranchPickerSheet(),
);

/// Picks a branch: a city, its district, then a branch in it.
///
/// Opens on the active branch's city and district with that branch marked.
/// The mark applies only on "Choose"; closing the sheet keeps the active
/// branch.
class BranchPickerSheet extends ConsumerStatefulWidget {
  const BranchPickerSheet({super.key});

  @override
  ConsumerState<BranchPickerSheet> createState() => _BranchPickerSheetState();
}

class _BranchPickerSheetState extends ConsumerState<BranchPickerSheet> {
  /// The "Other" district tab's value; district ids are UUIDs, so it never
  /// clashes with one.
  static const _otherTab = '';

  // Null until the user changes them; the active branch's are used till then.
  String? _cityId;
  String? _districtId;
  String? _markedId;

  void _choose(String branchId) {
    ref.read(branchPickProvider.notifier).pick(branchId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final citiesState = ref.watch(citiesControllerProvider);
    final branchesState = ref.watch(branchesControllerProvider);
    final active = ref.watch(activeBranchProvider).value;
    final cities = citiesState.value;
    final branches = branchesState.value;

    if (cities == null || branches == null) {
      if (citiesState.hasError || branchesState.hasError) {
        return _Error(
          onRetry: () {
            if (citiesState.hasError) ref.invalidate(citiesControllerProvider);
            if (branchesState.hasError) {
              ref.invalidate(branchesControllerProvider);
            }
          },
        );
      }
      return const _Loading();
    }

    final cityId = _cityId ?? active?.cityId;
    final city =
        cities.where((c) => c.id == cityId).firstOrNull ?? cities.firstOrNull;
    final markedId = _markedId ?? active?.id;

    // Without cities from the server every branch is listed.
    final inCity = [
      for (final item in branches)
        if (city == null || item.branch.cityId == city.id) item,
    ];

    // A city split into districts gets a tab per district, and an "Other"
    // tab for its branches that name no district of it.
    final districts = city?.districts ?? const <District>[];
    final districtIds = {for (final d in districts) d.id};
    bool isOther(Branch b) => !districtIds.contains(b.districtId);
    final tabs = [
      for (final d in districts) DSOption(value: d.id, label: d.name),
      if (districts.isNotEmpty && inCity.any((b) => isOther(b.branch)))
        DSOption(
          value: _otherTab,
          label: AppLocalizations.of(context).otherDistrict,
        ),
    ];

    // The active branch's tab, while the sheet shows its city.
    final activeTab = active == null || active.cityId != city?.id
        ? null
        : isOther(active)
        ? _otherTab
        : active.districtId;
    final wanted = _districtId ?? activeTab;
    final tab = tabs.any((t) => t.value == wanted)
        ? wanted
        : tabs.firstOrNull?.value;

    final shown = [
      for (final item in inCity)
        if (tab == null ||
            (tab == _otherTab
                ? isOther(item.branch)
                : item.branch.districtId == tab))
          item,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (city != null) ...[
          DSDropdown<String>(
            options: [
              for (final c in cities) DSOption(value: c.id, label: c.name),
            ],
            value: city.id,
            onChanged: (id) => setState(() {
              _cityId = id;
              // The new city opens on its first district.
              _districtId = null;
            }),
          ),
          const SizedBox(height: DSSpacing.base),
        ],
        if (tab != null) ...[
          DSChipTabs<String>(
            options: tabs,
            value: tab,
            onChanged: (id) => setState(() => _districtId = id),
          ),
          const SizedBox(height: DSSpacing.base),
        ],
        // Gives up height first when the sheet does not fit the screen.
        Flexible(
          child: _List(
            branches: shown,
            markedId: markedId,
            onMark: (id) => setState(() => _markedId = id),
          ),
        ),
        const SizedBox(height: DSSpacing.base),
        DSButton(
          label: AppLocalizations.of(context).choose,
          size: DSButtonSize.sm,
          fullWidth: true,
          onPressed: () {
            if (markedId != null) _choose(markedId);
          },
        ),
      ],
    );
  }
}

/// The branches with hairlines between them; grows up to a limit, then
/// scrolls.
class _List extends StatelessWidget {
  const _List({
    required this.branches,
    required this.markedId,
    required this.onMark,
  });

  final List<NearbyBranch> branches;
  final String? markedId;
  final ValueChanged<String> onMark;

  /// The gap, hairline and gap between two rows.
  static const _separatorHeight = DSSpacing.md * 2 + DSSizes.borderWidthDefault;

  @override
  Widget build(BuildContext context) {
    // A short list is measured to take just its rows' height. A list that
    // fills the limit anyway is built lazily, only the rows in view. A row is
    // at least its photo high; a larger font only makes it taller.
    final count = branches.length;
    final leastHeight =
        count * DSSizes.branchImageSm + (count - 1) * _separatorHeight;
    final shrink = leastHeight < DSSizes.branchPickerListMaxHeight;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: DSSizes.branchPickerListMaxHeight,
      ),
      child: ListView.separated(
        shrinkWrap: shrink,
        padding: EdgeInsets.zero,
        itemCount: branches.length,
        separatorBuilder: (context, _) => Padding(
          padding: const EdgeInsets.symmetric(vertical: DSSpacing.md),
          child: Divider(
            height: DSSizes.borderWidthDefault,
            thickness: DSSizes.borderWidthDefault,
            color: context.colors.borderMuted,
          ),
        ),
        itemBuilder: (context, i) {
          final item = branches[i];
          return BranchSelectTile(
            branch: item.branch,
            distanceKm: item.distanceKm,
            selected: item.branch.id == markedId,
            onTap: () => onMark(item.branch.id),
          );
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DSSpacing.xl),
      child: Center(
        child: CircularProgressIndicator(color: context.colors.brandPrimary),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.errorGeneric,
            style: DSTypography.body.copyWith(color: colors.textSecondary),
          ),
        ),
        const SizedBox(width: DSSpacing.sm),
        TextButton(
          onPressed: onRetry,
          style: TextButton.styleFrom(
            foregroundColor: colors.brandPrimary,
            textStyle: DSTypography.bodySemibold,
          ),
          child: Text(l10n.retry),
        ),
      ],
    );
  }
}
