import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../design_system/components/feedback/ds_skeleton.dart';
import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/entities/branch.dart';
import '../../../../domain/state/active_branch_state.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../branches/branch_picker_sheet/branch_picker_sheet.dart';

/// Home's header: the brand logo, the active branch, and the notifications
/// bell. Tapping the branch opens the branch sheet.
///
/// While the active branch loads its lines are a skeleton; without one (an
/// error, or no branches) only the logo and the bell are shown.
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(activeBranchProvider);
    final branch = state.value;

    final Widget middle;
    if (branch != null) {
      middle = _BranchButton(
        branch: branch,
        label: l10n.chooseBranch,
        onTap: () => showBranchPicker(context),
      );
    } else if (state.isLoading) {
      middle = const _BranchSkeleton();
    } else {
      middle = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(DSSpacing.base),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(DSRadius.md),
            child: SvgPicture.asset(
              'assets/brand/logo.svg',
              width: DSSizes.headerLogo,
              height: DSSizes.headerLogo,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: DSSpacing.md),
          Expanded(child: middle),
          const SizedBox(width: DSSpacing.md),
          // The unread dot and the notifications screen come later.
          _Bell(label: l10n.notifications, hasUnread: false, onTap: () {}),
        ],
      ),
    );
  }
}

/// The active branch's name and address with a caret: the branch picker.
class _BranchButton extends StatelessWidget {
  const _BranchButton({
    required this.branch,
    required this.label,
    required this.onTap,
  });

  final Branch branch;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              branch.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DSTypography.caption.copyWith(color: colors.textTertiary),
            ),
            const SizedBox(height: DSSpacing.xxs),
            Row(
              children: [
                Flexible(
                  child: Text(
                    branch.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DSTypography.bodySemibold.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: DSSpacing.xs),
                Icon(
                  PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
                  size: DSSizes.iconXs,
                  color: colors.textPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BranchSkeleton extends StatelessWidget {
  const _BranchSkeleton();

  @override
  Widget build(BuildContext context) {
    // Name and address lines, as parts of the width.
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Line(widthFactor: 0.4),
        SizedBox(height: DSSpacing.sm),
        _Line(widthFactor: 0.7),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: const DSSkeleton.box(
        width: double.infinity,
        height: DSSpacing.md,
        radius: DSRadius.xs,
      ),
    );
  }
}

class _Bell extends StatelessWidget {
  const _Bell({required this.label, required this.hasUnread, this.onTap});

  final String label;
  final bool hasUnread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox.square(
          dimension: DSSizes.headerAction,
          child: Center(
            // The dot sits on the icon's top-right corner.
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  PhosphorIcons.bell(),
                  size: DSSizes.iconMd,
                  color: colors.textPrimary,
                ),
                if (hasUnread)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: DSSizes.notificationDot,
                      height: DSSizes.notificationDot,
                      decoration: BoxDecoration(
                        color: colors.brandPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.bgSurface,
                          width: DSSizes.borderWidthThick,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
