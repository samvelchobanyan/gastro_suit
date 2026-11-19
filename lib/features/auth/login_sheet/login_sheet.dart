import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/auth/auth_status.dart';
import '../../../core/config/app_config.dart';
import '../../../core/utils/error_text.dart';
import '../../../design_system/components/buttons/ds_button.dart';
import '../../../design_system/components/inputs/ds_code_field.dart';
import '../../../design_system/components/inputs/ds_text_field.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'login_sheet_controller.dart';

/// For an action that needs an account: a guest is asked to sign in. True
/// when the user is signed in, at once or on closing the sheet; false when
/// they closed it without signing in.
Future<bool> ensureSignedIn(BuildContext context, WidgetRef ref) async {
  if (ref.read(authStatusProvider) == AuthStatus.signedIn) return true;
  await showLoginSheet(context);
  if (!context.mounted) return false;
  return ref.read(authStatusProvider) == AuthStatus.signedIn;
}

/// Opens the sign-in sheet over the whole app, tab bar included. It closes
/// itself once the user is signed in.
Future<void> showLoginSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    barrierColor: context.colors.bgScrim,
    builder: (_) => const LoginSheet(),
  );
}

/// Signing in by phone (handoff `LoginSheet`): a dark glass sheet with two
/// steps, the phone number and the code sent to it. Opened with
/// [showLoginSheet].
///
/// The code is checked as soon as its last digit is in. A refusal, of the
/// number or of the code, is said under the field.
class LoginSheet extends ConsumerStatefulWidget {
  const LoginSheet({super.key});

  @override
  ConsumerState<LoginSheet> createState() => _LoginSheetState();
}

class _LoginSheetState extends ConsumerState<LoginSheet> {
  // The two lights behind the glass, as the handoff page draws them: a
  // white one at the top left, a brand one at the bottom right.
  static const _glowLightOpacity = 0.08;
  static const _glowBrandOpacity = 0.22;
  static const _glowLightSize = 300.0;
  static const _glowBrandSize = 260.0;
  static const _glowBlur = 80.0;

  final _phone = TextEditingController();
  final _code = TextEditingController();
  final _phoneFocus = FocusNode();
  final _codeFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // The prefix shows with the focus.
    _phoneFocus.addListener(_redraw);
  }

  @override
  void dispose() {
    _phoneFocus.removeListener(_redraw);
    _phone.dispose();
    _code.dispose();
    _phoneFocus.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  void _redraw() => setState(() {});

  Future<void> _sendCode() async {
    await ref.read(loginSheetProvider.notifier).sendCode();
    if (!mounted) return;
    if (ref.read(loginSheetProvider).step == LoginStep.code) {
      _code.clear();
      _codeFocus.requestFocus();
    }
  }

  Future<void> _resend() async {
    _code.clear();
    _codeFocus.requestFocus();
    await ref.read(loginSheetProvider.notifier).resend();
  }

  void _changeNumber() {
    ref.read(loginSheetProvider.notifier).changeNumber();
    _code.clear();
    _phoneFocus.requestFocus();
  }

  Future<void> _verify() async {
    final signedIn = await ref
        .read(loginSheetProvider.notifier)
        .verify(_code.text);
    if (signedIn && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final config = ref.watch(appConfigProvider);
    final state = ref.watch(loginSheetProvider);
    final controller = ref.read(loginSheetProvider.notifier);
    final onCode = state.step == LoginStep.code;
    final error = state.error;
    // The system's bottom inset is zero while the keyboard is open, so the
    // two do not add up.
    final bottomInset =
        MediaQuery.paddingOf(context).bottom +
        MediaQuery.viewInsetsOf(context).bottom;

    final link = DSTypography.bodySemibold.copyWith(color: colors.textInverse);
    final hint = DSTypography.body.copyWith(color: colors.textInverseMuted);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: DSSpacing.sm),
          child: Container(
            width: DSSizes.sheetHandleWidth,
            height: DSSizes.sheetHandleHeight,
            decoration: BoxDecoration(
              color: colors.handleOnDark,
              borderRadius: BorderRadius.circular(DSRadius.full),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DSSpacing.xs),
            child: Semantics(
              button: true,
              label: MaterialLocalizations.of(context).closeButtonTooltip,
              excludeSemantics: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.pop(context),
                child: SizedBox.square(
                  dimension: DSSizes.buttonHeightMd,
                  child: Icon(
                    PhosphorIcons.x(),
                    size: DSSizes.iconMd,
                    color: colors.textInverse,
                  ),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: DSSpacing.base),
            child: Column(
              children: [
                Image.asset(
                  onCode
                      ? 'assets/images/login_code.png'
                      : 'assets/images/login_phone.png',
                  width: DSSizes.loginArt,
                  height: DSSizes.loginArt,
                  fit: BoxFit.contain,
                  excludeFromSemantics: true,
                ),
                const SizedBox(height: DSSpacing.base),
                Semantics(
                  header: true,
                  child: Text(
                    onCode ? l10n.loginCodeTitle : l10n.loginTitle,
                    textAlign: TextAlign.center,
                    style: DSTypography.h2.copyWith(color: colors.textInverse),
                  ),
                ),
                const SizedBox(height: DSSpacing.xs),
                if (!onCode)
                  Text(
                    l10n.loginPhoneHint,
                    textAlign: TextAlign.center,
                    style: hint,
                  )
                else
                  Text.rich(
                    textAlign: TextAlign.center,
                    style: hint,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: l10n.loginCodeHint(
                            LoginSheetController.codeLength,
                            '${config.phoneCountryCode} ${state.phone}',
                          ),
                        ),
                        const TextSpan(text: ' '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: _Link(
                            label: state.resent
                                ? l10n.loginResent
                                : l10n.loginResend,
                            style: link,
                            onTap: state.busy || state.resent ? null : _resend,
                          ),
                        ),
                        const TextSpan(text: ' · '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: _Link(
                            label: l10n.loginChangeNumber,
                            style: link,
                            onTap: state.busy ? null : _changeNumber,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: DSSpacing.lg),
                if (onCode)
                  DSCodeField(
                    controller: _code,
                    focusNode: _codeFocus,
                    length: LoginSheetController.codeLength,
                    semanticLabel: l10n.loginCodeField,
                    error: error != null,
                    enabled: !state.busy,
                    onChanged: (_) => controller.codeEdited(),
                    onCompleted: (_) => _verify(),
                  )
                else
                  DSTextField(
                    controller: _phone,
                    focusNode: _phoneFocus,
                    size: DSTextFieldSize.lg,
                    leadingIcon: PhosphorIcons.phone(),
                    hintText: config.phoneCountryCode,
                    prefixText: _phoneFocus.hasFocus || _phone.text.isNotEmpty
                        ? '${config.phoneCountryCode} '
                        : null,
                    keyboardType: TextInputType.phone,
                    digitsOnly: true,
                    maxLength: config.phoneNumberLength,
                    textInputAction: TextInputAction.done,
                    autofocus: true,
                    enabled: !state.busy,
                    onChanged: controller.setPhone,
                    onSubmitted: (_) => _sendCode(),
                    clearLabel: l10n.loginClearPhone,
                    onClear: () {
                      _phone.clear();
                      controller.setPhone('');
                    },
                  ),
                if (error != null) ...[
                  const SizedBox(height: DSSpacing.sm),
                  Text(
                    errorText(context, error),
                    textAlign: TextAlign.center,
                    style: DSTypography.bodySm.copyWith(
                      color: colors.statusError,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            DSSpacing.base,
            DSSpacing.base,
            DSSpacing.base,
            DSSpacing.base + bottomInset,
          ),
          child: DSButton(
            label: onCode ? l10n.loginVerify : l10n.loginSendCode,
            size: DSButtonSize.md,
            pill: true,
            fullWidth: true,
            loading: state.busy,
            onPressed: onCode
                ? (_code.text.length == LoginSheetController.codeLength
                      ? _verify
                      : null)
                : (controller.isPhoneComplete ? _sendCode : null),
          ),
        ),
      ],
    );

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(DSRadius.sheet),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: DSSizes.darkSheetBlur,
          sigmaY: DSSizes.darkSheetBlur,
        ),
        child: ColoredBox(
          color: colors.glassBgDark,
          child: Stack(
            children: [
              PositionedDirectional(
                top: -_glowLightSize / 2,
                start: -_glowLightSize / 3,
                child: _Glow(
                  size: _glowLightSize,
                  color: colors.textInverse.withValues(
                    alpha: _glowLightOpacity,
                  ),
                  blur: _glowBlur,
                ),
              ),
              PositionedDirectional(
                bottom: -_glowBrandSize / 2.6,
                end: -_glowBrandSize / 2.9,
                child: _Glow(
                  size: _glowBrandSize,
                  color: colors.brandPrimary.withValues(
                    alpha: _glowBrandOpacity,
                  ),
                  blur: _glowBlur,
                ),
              ),
              // The code step listens to the field to enable its button.
              ListenableBuilder(listenable: _code, builder: (_, _) => content),
            ],
          ),
        ),
      ),
    );
  }
}

/// A word in the hint that takes a tap; dimmed while it takes none.
class _Link extends StatelessWidget {
  const _Link({required this.label, required this.style, required this.onTap});

  final String label;
  final TextStyle style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Text(label, style: style),
      ),
    );
  }
}

/// A soft round light behind the sheet's glass.
class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color, required this.blur});

  final double size;
  final Color color;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
