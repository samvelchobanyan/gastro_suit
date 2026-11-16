import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../design_system/ds_extensions.dart';
import '../../../../domain/state/loyalty_card_state.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../loyalty/loyalty_card_sheet/loyalty_card_sheet.dart';

/// Home's loyalty card (handoff `LoyaltyPointsCard`): the points, the tier
/// and the card's code. Opens the card for the cashier to scan.
///
/// Takes no room for a guest, without a loyalty programme, while the card
/// loads, or when it fails to load.
class LoyaltyCardBlock extends ConsumerWidget {
  const LoyaltyCardBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(loyaltyCardProvider).value;
    if (card == null) return const SizedBox.shrink();

    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final tier = card.tier;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DSLayout.margin,
        0,
        DSLayout.margin,
        DSSpacing.base,
      ),
      child: Semantics(
        button: true,
        label: l10n.loyaltyShowCard,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => showLoyaltyCard(context),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: DSSizes.loyaltyCardHeight,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.bgInverse,
              borderRadius: BorderRadius.circular(DSRadius.lg),
              image: const DecorationImage(
                image: AssetImage('assets/brand/loyalty_card_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              DSSpacing.base,
              DSSpacing.base,
              DSSpacing.lg,
              DSSpacing.base,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.loyaltyPointsLabel,
                        style: DSTypography.bodySm.copyWith(
                          color: colors.textInverse.withValues(
                            alpha: DSOpacity.quietOnDark,
                          ),
                        ),
                      ),
                      Text(
                        NumberFormat.decimalPattern(locale).format(card.points),
                        style: DSTypography.h1.copyWith(
                          color: colors.textInverse,
                        ),
                      ),
                      if (tier != null) ...[
                        const SizedBox(height: DSSpacing.xs),
                        _TierPill(name: tier),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: DSSpacing.md),
                ExcludeSemantics(
                  child: QrImageView(
                    data: card.number,
                    size: DSSizes.loyaltyCardQr,
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: colors.textInverse,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: colors.textInverse,
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

/// The user's tier on the card (handoff `MembershipTierPill`). Only its
/// name: the API gives a tier no percent.
class _TierPill extends StatelessWidget {
  const _TierPill({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DSSpacing.md,
        vertical: DSSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.textInverse.withValues(alpha: DSOpacity.surfaceOnDark),
        borderRadius: BorderRadius.circular(DSRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PhosphorIcons.crown(PhosphorIconsStyle.fill),
            size: DSSizes.iconXs,
            color: colors.textInverse,
          ),
          const SizedBox(width: DSSpacing.xs),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DSTypography.bodyXs.copyWith(color: colors.textInverse),
            ),
          ),
        ],
      ),
    );
  }
}
