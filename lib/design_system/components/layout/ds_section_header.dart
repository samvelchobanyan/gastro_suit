import 'package:flutter/material.dart';

import '../../ds_extensions.dart';

/// The title over a section of a screen (handoff `SectionHeader`).
class DSSectionHeader extends StatelessWidget {
  const DSSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        title,
        style: DSTypography.h3.copyWith(color: context.colors.textPrimary),
      ),
    );
  }
}
