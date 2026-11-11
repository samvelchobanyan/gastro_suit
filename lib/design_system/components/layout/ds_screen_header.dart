import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// The title at the top of a screen (handoff `ScreenHeader`). The handoff's
/// back button and trailing action are added when a screen needs them.
class DSScreenHeader extends StatelessWidget {
  const DSScreenHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DSSpacing.base),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Semantics(
          header: true,
          child: Text(
            title,
            style: DSTypography.h1.copyWith(color: context.colors.textPrimary),
          ),
        ),
      ),
    );
  }
}
