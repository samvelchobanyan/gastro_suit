import 'package:flutter/material.dart';

import '../../../design_system/ds_extensions.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Placeholder until the Order screen is built.
class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).tabOrder,
        style: DSTypography.h1.copyWith(color: context.colors.textPrimary),
      ),
    );
  }
}
