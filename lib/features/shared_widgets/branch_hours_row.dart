import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../design_system/components/feedback/ds_status_pill.dart';
import '../../design_system/ds_extensions.dart';
import '../../domain/entities/branch.dart';
import '../../l10n/generated/app_localizations.dart';

/// A branch's hours for today and the open / closed pill, in one line. The
/// branch card and the branch screen.
class BranchHoursRow extends StatelessWidget {
  const BranchHoursRow({super.key, required this.branch});

  final Branch branch;

  /// False when the branch has no hours entered and is not closed for now:
  /// its state is unknown and the row has nothing to show.
  static bool hasContentFor(Branch branch) =>
      branch.today != null || branch.isTemporarilyClosed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    final hours = switch (branch.today) {
      TodayOpen(:final opens, :final closes) => '$opens – $closes',
      TodayClosed() => l10n.branchClosedToday,
      null => null,
    };
    // A day off already says "closed" in the hours text.
    final showPill = branch.isTemporarilyClosed || branch.today is TodayOpen;
    final isOpen = branch.isOpenNow ?? false;

    return Row(
      children: [
        if (hours != null) ...[
          Icon(
            PhosphorIcons.clock(),
            size: DSSizes.iconXs,
            color: colors.textTertiary,
          ),
          const SizedBox(width: DSSpacing.xs),
          Text(
            hours,
            style: DSTypography.bodyXs.copyWith(color: colors.textTertiary),
          ),
          const SizedBox(width: DSSpacing.sm),
        ],
        if (showPill)
          DSStatusPill(
            label: isOpen ? l10n.branchOpen : l10n.branchClosed,
            tone: isOpen ? DSStatusTone.success : DSStatusTone.error,
          ),
      ],
    );
  }
}
