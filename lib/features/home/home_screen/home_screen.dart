import 'package:flutter/material.dart';

import '../../../design_system/ds_extensions.dart';
import '../../../l10n/generated/app_localizations.dart';

/// The Home tab: one vertical scroll of blocks, top to bottom — header,
/// stories, banners, nearest branches (loyalty, wallet, vouchers and the
/// buy-again / favourites rails come later).
///
/// Each block loads, fails and refreshes on its own; this screen only places
/// them.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.bgSurface,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Blocks replace this as they are built.
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(DSLayout.margin),
                child: Text(
                  AppLocalizations.of(context).tabHome,
                  style: DSTypography.h1.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
