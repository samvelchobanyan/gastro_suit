import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// A price as shown everywhere: "֏1,450", digits grouped as the app's locale
/// does.
///
/// The dram sign is fixed: the only client so far sells in drams. The
/// currency arrives from `/config` when a client needs another one.
String formatPrice(BuildContext context, int amount) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return '֏${NumberFormat.decimalPattern(locale).format(amount)}';
}
