import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/product.dart';
import '../../l10n/generated/app_localizations.dart';

/// A portion as shown next to a product: "300 ml", digits grouped as the
/// app's locale does.
String formatPortion(BuildContext context, Portion portion) {
  final l10n = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context).toLanguageTag();
  final amount = NumberFormat.decimalPattern(locale).format(portion.amount);
  return switch (portion.unit) {
    PortionUnit.gram => l10n.portionGrams(amount),
    PortionUnit.kilogram => l10n.portionKilograms(amount),
    PortionUnit.milliliter => l10n.portionMilliliters(amount),
    PortionUnit.liter => l10n.portionLiters(amount),
  };
}
