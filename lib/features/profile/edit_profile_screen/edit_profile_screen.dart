import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_text.dart';
import '../../../design_system/components/buttons/ds_button.dart';
import '../../../design_system/components/inputs/ds_dropdown.dart';
import '../../../design_system/components/inputs/ds_radio.dart';
import '../../../design_system/components/inputs/ds_text_field.dart';
import '../../../design_system/components/layout/ds_screen_header.dart';
import '../../../design_system/components/layout/ds_section_header.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/profile.dart';
import '../../../domain/state/cities_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'edit_profile_controller.dart';
import 'widgets/birthday_fields.dart';
import 'widgets/profile_photo_picker.dart';

/// Where the user changes what the app knows about them: the photo, the
/// name, the birthday, the city and the gender. Opened from the profile's
/// user card; covers the tab bar.
///
/// The photo is saved the moment it is chosen; the rest is saved by the
/// button, which then goes back to the profile.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  /// The server's limit for a name.
  static const _nameMaxLength = 255;

  late final TextEditingController _name;
  late final TextEditingController _surname;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(editProfileProvider).draft;
    _name = TextEditingController(text: draft.name);
    _surname = TextEditingController(text: draft.surname);
  }

  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final saved = await ref.read(editProfileProvider.notifier).save();
    if (saved && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final state = ref.watch(editProfileProvider);
    final draft = state.draft;
    final form = ref.read(editProfileProvider.notifier);
    final cities = ref.watch(citiesControllerProvider).value ?? const [];
    final error = state.error;

    const gap = SizedBox(height: DSSpacing.base);
    const labelGap = SizedBox(height: DSSpacing.sm);

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DSScreenHeader(
              title: l10n.profileEdit,
              onBack: context.pop,
              backLabel: l10n.back,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  DSLayout.margin,
                  0,
                  DSLayout.margin,
                  DSSpacing.base,
                ),
                children: [
                  const ProfilePhotoPicker(),
                  gap,
                  DSSectionHeader(title: l10n.profileFirstName),
                  labelGap,
                  DSTextField(
                    controller: _name,
                    onChanged: form.setName,
                    maxLength: _nameMaxLength,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    enabled: !state.saving,
                  ),
                  gap,
                  DSSectionHeader(title: l10n.profileLastName),
                  labelGap,
                  DSTextField(
                    controller: _surname,
                    onChanged: form.setSurname,
                    maxLength: _nameMaxLength,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    enabled: !state.saving,
                  ),
                  gap,
                  DSSectionHeader(title: l10n.profileBirthday),
                  labelGap,
                  BirthdayFields(
                    day: draft.day,
                    month: draft.month,
                    year: draft.year,
                    daysInMonth: draft.daysInMonth,
                    onDay: form.setDay,
                    onMonth: form.setMonth,
                    onYear: form.setYear,
                  ),
                  gap,
                  DSSectionHeader(title: l10n.profileCity),
                  labelGap,
                  DSDropdown<String>(
                    value: draft.city,
                    onChanged: form.setCity,
                    options: [
                      for (final city in cities)
                        DSDropdownOption(value: city.id, label: city.name),
                    ],
                  ),
                  gap,
                  DSSectionHeader(title: l10n.profileGender),
                  labelGap,
                  Row(
                    children: [
                      _GenderChoice(
                        label: l10n.profileGenderMale,
                        selected: draft.gender == Gender.male,
                        onTap: () => form.setGender(Gender.male),
                      ),
                      const SizedBox(width: DSSpacing.lg),
                      _GenderChoice(
                        label: l10n.profileGenderFemale,
                        selected: draft.gender == Gender.female,
                        onTap: () => form.setGender(Gender.female),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(DSSpacing.base),
              decoration: BoxDecoration(
                color: colors.bgSurface,
                border: Border(
                  top: BorderSide(
                    color: colors.borderMuted,
                    width: DSSizes.borderWidthDefault,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (error != null) ...[
                    Text(
                      errorText(context, error),
                      style: DSTypography.bodySm.copyWith(
                        color: colors.textError,
                      ),
                    ),
                    const SizedBox(height: DSSpacing.sm),
                  ],
                  DSButton(
                    label: l10n.save,
                    size: DSButtonSize.sm,
                    fullWidth: true,
                    loading: state.saving,
                    onPressed: state.canSave ? _save : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One gender with its radio mark; the whole of it takes the tap.
class _GenderChoice extends StatelessWidget {
  const _GenderChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: DSSpacing.xs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DSRadio(selected: selected),
              const SizedBox(width: DSSpacing.sm),
              Text(
                label,
                style: DSTypography.body.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
