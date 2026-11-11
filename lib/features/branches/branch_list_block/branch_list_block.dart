import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/components/feedback/ds_skeleton.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/state/active_branch_state.dart';
import '../../../domain/state/branches_state.dart';
import '../../../domain/state/cities_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../shared_widgets/branch_tile.dart';
import '../../shared_widgets/branch_tile_skeleton.dart';
import '../branch_filter.dart';
import '../widgets/branch_area_filter.dart';

/// The organisation's branches filtered by city and district, for a screen
/// to embed (the Order tab). Fills the space it is given and scrolls in it,
/// the filter included.
///
/// Loads, fails and refreshes on its own. Opens on the active branch's city
/// and district.
class BranchListBlock extends ConsumerStatefulWidget {
  const BranchListBlock({super.key});

  @override
  ConsumerState<BranchListBlock> createState() => _BranchListBlockState();
}

class _BranchListBlockState extends ConsumerState<BranchListBlock> {
  // Null until the user changes them; the active branch's are used till then.
  String? _cityId;
  String? _districtId;

  /// Data already on screen stays until the new data arrives; a failed
  /// refresh keeps it.
  Future<void> _refresh() async {
    try {
      await Future.wait<Object>([
        ref.refresh(citiesControllerProvider.future),
        // Also reads the position again.
        ref.refresh(branchesControllerProvider.future),
      ]);
    } catch (_) {
      // The spinner only needs to stop.
    }
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
      return const _Skeleton();
    }

    final filter = filterBranches(
      cities: cities,
      branches: branches,
      otherLabel: AppLocalizations.of(context).otherDistrict,
      cityId: _cityId,
      districtId: _districtId,
      active: active,
    );
    final shown = filter.branches;

    return RefreshIndicator(
      color: context.colors.brandPrimary,
      onRefresh: _refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (filter.city != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: DSSpacing.lg),
                child: BranchAreaFilter(
                  filter: filter,
                  margin: DSLayout.margin,
                  onCityChanged: (id) => setState(() {
                    _cityId = id;
                    // The new city opens on its first district.
                    _districtId = null;
                  }),
                  onDistrictChanged: (id) => setState(() => _districtId = id),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              DSLayout.margin,
              0,
              DSLayout.margin,
              DSSpacing.base,
            ),
            sliver: SliverList.separated(
              itemCount: shown.length,
              separatorBuilder: (context, _) => const _Hairline(),
              itemBuilder: (context, i) => BranchTile(
                branch: shown[i].branch,
                distanceKm: shown[i].distanceKm,
                // The branch screen is not built yet.
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The line between two rows, with room above and below.
class _Hairline extends StatelessWidget {
  const _Hairline();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DSSpacing.md),
      child: Divider(
        height: DSSizes.borderWidthDefault,
        thickness: DSSizes.borderWidthDefault,
        color: context.colors.borderMuted,
      ),
    );
  }
}

/// The city select and a few rows while the first load runs.
class _Skeleton extends StatelessWidget {
  const _Skeleton();

  static const _rows = 5;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
      child: Column(
        children: [
          const DSSkeleton.box(
            width: double.infinity,
            height: DSSizes.inputHeightCompact,
            radius: DSRadius.input,
          ),
          const SizedBox(height: DSSpacing.lg),
          for (var i = 0; i < _rows; i++) ...[
            if (i > 0) const _Hairline(),
            const BranchTileSkeleton(),
          ],
        ],
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
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DSLayout.margin),
        child: Row(
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
        ),
      ),
    );
  }
}
