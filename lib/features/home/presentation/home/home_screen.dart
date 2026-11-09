import 'package:flutter/material.dart';

import '../../../../design_system/ds_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Placeholder until the Home screen is built.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).tabHome,
        style: DSTypography.h1.copyWith(color: context.colors.textPrimary),
      ),
    );
  }
}
