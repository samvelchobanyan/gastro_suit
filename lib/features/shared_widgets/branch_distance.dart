import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';

/// A branch's distance from the user as shown on branch rows: "1.2 km", one
/// decimal, in the app's locale.
String formatBranchDistance(BuildContext context, double km) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final number = NumberFormat('0.0', locale).format(km);
  return AppLocalizations.of(context).distanceKm(number);
}
