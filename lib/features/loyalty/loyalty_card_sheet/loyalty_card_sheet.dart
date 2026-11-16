import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../design_system/ds_extensions.dart';
import '../../../domain/state/loyalty_card_state.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Opens the user's loyalty card over the whole app, for the cashier to
/// scan.
Future<void> showLoyaltyCard(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    barrierColor: context.colors.bgScrim,
    builder: (_) => const LoyaltyCardSheet(),
  );
}

/// The user's loyalty card (handoff `LoyaltyCardSheet`): a dark sheet with
/// the brand's logo, the card's code and the points.
///
/// The handoff's progress to the next tier and its "how it works" sheet are
/// left out: the API has no data for them.
class LoyaltyCardSheet extends ConsumerWidget {
  const LoyaltyCardSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final card = ref.watch(loyaltyCardProvider).value;
    // Opened from a card on screen; gone only if the user signed out.
    if (card == null) return const SizedBox.shrink();

    final quiet = colors.textInverse.withValues(alpha: DSOpacity.quietOnDark);
    final locale = Localizations.localeOf(context).toLanguageTag();
    const corners = BorderRadius.vertical(top: Radius.circular(DSRadius.sheet));

    return ClipRRect(
      borderRadius: corners,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: DSSizes.darkSheetBlur,
          sigmaY: DSSizes.darkSheetBlur,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.bgInverse.withValues(alpha: DSOpacity.darkGlass),
            borderRadius: corners,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              DSSpacing.base,
              DSSpacing.sm,
              DSSpacing.base,
              DSSpacing.lg + MediaQuery.paddingOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: DSSizes.sheetHandleWidth,
                  height: DSSizes.sheetHandleHeight,
                  decoration: BoxDecoration(
                    color: colors.handleOnDark,
                    borderRadius: BorderRadius.circular(DSRadius.full),
                  ),
                ),
                const SizedBox(height: DSSpacing.lg),
                SvgPicture.asset(
                  'assets/brand/logo.svg',
                  width: DSSizes.buttonHeightMd,
                  height: DSSizes.buttonHeightMd,
                  excludeFromSemantics: true,
                ),
                const SizedBox(height: DSSpacing.lg),
                // Dark on a light plate, not the handoff's light on dark:
                // not every scanner reads a code with its colours swapped.
                Semantics(
                  image: true,
                  label: l10n.loyaltyQrLabel,
                  child: Container(
                    padding: const EdgeInsets.all(DSSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.textInverse,
                      borderRadius: BorderRadius.circular(DSRadius.md),
                    ),
                    child: QrImageView(
                      data: card.number,
                      size: DSSizes.loyaltyQr - DSSpacing.md * 2,
                      padding: EdgeInsets.zero,
                      backgroundColor: colors.textInverse,
                      eyeStyle: QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: colors.bgInverse,
                      ),
                      dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: colors.bgInverse,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: DSSpacing.sm),
                Text(
                  l10n.loyaltyScanHint,
                  textAlign: TextAlign.center,
                  style: DSTypography.bodySm.copyWith(color: quiet),
                ),
                const SizedBox(height: DSSpacing.lg),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(DSSpacing.base),
                  decoration: BoxDecoration(
                    color: colors.textInverse.withValues(
                      alpha: DSOpacity.surfaceOnDark,
                    ),
                    borderRadius: BorderRadius.circular(DSRadius.lg),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/loyalty_balance_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.loyaltyBalanceLabel,
                        style: DSTypography.bodySm.copyWith(color: quiet),
                      ),
                      const SizedBox(height: DSSpacing.xxs),
                      Text(
                        l10n.loyaltyPoints(
                          NumberFormat.decimalPattern(
                            locale,
                          ).format(card.points),
                        ),
                        style: DSTypography.display.copyWith(
                          color: colors.textInverse,
                        ),
                      ),
                    ],
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
