import 'package:flutter/material.dart';

import '../../../design_system/components/inputs/ds_chip_tabs.dart';
import '../../../design_system/components/inputs/ds_dropdown.dart';
import '../../../design_system/ds_extensions.dart';
import '../branch_filter.dart';

/// The controls of a branch filter: the city select and, for a city split
/// into districts, the district chips under it.
///
/// Draws [filter] and reports taps; whoever shows it keeps the user's
/// choices and computes the filter (`filterBranches`). Nothing is drawn when
/// the server has no cities.
class BranchAreaFilter extends StatelessWidget {
  const BranchAreaFilter({
    super.key,
    required this.filter,
    required this.onCityChanged,
    required this.onDistrictChanged,
    this.margin = 0,
  });

  final BranchFilter filter;
  final ValueChanged<String> onCityChanged;
  final ValueChanged<String> onDistrictChanged;

  /// Space on the left and right. The chips scroll under it, edge to edge.
  final double margin;

  @override
  Widget build(BuildContext context) {
    final city = filter.city;
    final district = filter.district;
    if (city == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: margin),
          child: DSDropdown<String>(
            options: [
              for (final c in filter.cities)
                DSDropdownOption(value: c.id, label: c.name),
            ],
            value: city.id,
            onChanged: onCityChanged,
          ),
        ),
        if (district != null) ...[
          const SizedBox(height: DSSpacing.base),
          DSChipTabs<String>(
            options: filter.districts,
            value: district,
            onChanged: onDistrictChanged,
            padding: EdgeInsets.symmetric(horizontal: margin),
          ),
        ],
      ],
    );
  }
}
