import 'package:flutter/material.dart';

import '../../../../design_system/ds_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Placeholder until the Gifts screen is built.
class GiftsScreen extends StatelessWidget {
  const GiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).tabGifts,
        style: DSTypography.h1.copyWith(color: context.colors.textPrimary),
      ),
    );
  }
}
