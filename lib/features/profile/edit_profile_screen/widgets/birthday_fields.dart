import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../design_system/components/inputs/ds_dropdown.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// The birthday as three lists side by side: the day, the month, the year.
///
/// The days offered are those the chosen month has; the years go a hundred
/// back from this one.
class BirthdayFields extends StatelessWidget {
  const BirthdayFields({
    super.key,
    required this.day,
    required this.month,
    required this.year,
    required this.daysInMonth,
    required this.onDay,
    required this.onMonth,
    required this.onYear,
  });

  final int? day;
  final int? month;
  final int? year;

  /// How many days to offer.
  final int daysInMonth;
  final ValueChanged<int> onDay;
  final ValueChanged<int> onMonth;
  final ValueChanged<int> onYear;

  static const _years = 100;

  // The handoff's columns: 1 : 1.6 : 1.2.
  static const _dayFlex = 10;
  static const _monthFlex = 16;
  static const _yearFlex = 12;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // The month's name as it stands alone, not as in a date.
    final monthName = DateFormat(
      'LLLL',
      Localizations.localeOf(context).toLanguageTag(),
    );
    final thisYear = DateTime.now().year;

    return Row(
      children: [
        Expanded(
          flex: _dayFlex,
          child: DSDropdown<int>(
            value: day,
            placeholder: l10n.profileBirthdayDay,
            onChanged: onDay,
            options: [
              for (var d = 1; d <= daysInMonth; d++)
                DSDropdownOption(value: d, label: '$d'),
            ],
          ),
        ),
        const SizedBox(width: DSSpacing.sm),
        Expanded(
          flex: _monthFlex,
          child: DSDropdown<int>(
            value: month,
            placeholder: l10n.profileBirthdayMonth,
            onChanged: onMonth,
            options: [
              for (var m = 1; m <= DateTime.monthsPerYear; m++)
                DSDropdownOption(
                  value: m,
                  label: toBeginningOfSentenceCase(
                    monthName.format(DateTime(thisYear, m)),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: DSSpacing.sm),
        Expanded(
          flex: _yearFlex,
          child: DSDropdown<int>(
            value: year,
            placeholder: l10n.profileBirthdayYear,
            onChanged: onYear,
            options: [
              for (var y = thisYear; y > thisYear - _years; y--)
                DSDropdownOption(value: y, label: '$y'),
            ],
          ),
        ),
      ],
    );
  }
}
