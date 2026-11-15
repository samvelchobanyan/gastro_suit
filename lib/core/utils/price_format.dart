import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// The sign of the currency prices are in.
///
/// The dram sign is fixed: the only client so far sells in drams. The
/// currency arrives from `/config` when a client needs another one.
const currencySign = '֏';

/// A price as shown everywhere: "֏1,450", digits grouped as the app's locale
/// does.
String formatPrice(BuildContext context, int amount) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return '$currencySign${NumberFormat.decimalPattern(locale).format(amount)}';
}
