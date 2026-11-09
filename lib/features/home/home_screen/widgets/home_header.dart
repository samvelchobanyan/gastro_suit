import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../design_system/ds_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Home's header: the brand logo, a greeting with the user's name, and the
/// notifications bell.
///
/// A guest has no name: only the greeting line is shown.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.name,
    this.hasUnread = false,
    this.onNotificationsTap,
  });

  final String? name;
  final bool hasUnread;
  final VoidCallback? onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = this.name;
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.homeGreeting,
                  style: DSTypography.caption.copyWith(
                    color: context.colors.textTertiary,
                  ),
                ),
                if (name != null) ...[
                  const SizedBox(height: DSSpacing.xxs),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DSTypography.h3.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: DSSpacing.md),
          _Bell(
            label: l10n.notifications,
            hasUnread: hasUnread,
            onTap: onNotificationsTap,
          ),
        ],
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
