import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/locale/app_language.dart';
import '../../../../design_system/components/inputs/ds_select_tile.dart';
import '../../../../design_system/ds_extensions.dart';

/// The app's languages side by side, the current one selected (handoff
/// `LanguageSwitcher`). A tap changes the language of the whole app at once.
///
/// Each language is named in itself, so a user who landed in a language they
/// do not read still finds their own.
class LanguageChoice extends ConsumerWidget {
  const LanguageChoice({super.key});

  /// In the handoff's order.
  static const _languages = [
    (code: 'hy', name: 'Հայերեն'),
    (code: 'ru', name: 'Русский'),
    (code: 'en', name: 'English'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final current = ref.watch(appLanguageProvider);
    return Row(
      children: [
        for (final (i, language) in _languages.indexed) ...[
          if (i > 0) const SizedBox(width: DSSpacing.sm),
          Expanded(
            child: DSSelectTile(
              selected: language.code == current,
              onTap: () =>
                  ref.read(appLanguageStorageProvider).choose(language.code),
              padding: const EdgeInsets.all(DSSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: DSSizes.iconXs,
                    height: DSSizes.iconXs,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    foregroundDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.borderDefault,
                        width: DSSizes.borderWidthDefault,
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/flag_${language.code}.png',
                      fit: BoxFit.cover,
                      excludeFromSemantics: true,
                    ),
                  ),
                  const SizedBox(width: DSSpacing.xs),
                  Flexible(
                    child: Text(
                      language.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DSTypography.bodySmSemibold.copyWith(
                        color: language.code == current
                            ? colors.textAccent
                            : colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
