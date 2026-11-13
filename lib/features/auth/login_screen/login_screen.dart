import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_status.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../shared_widgets/error_text.dart';
import 'login_controller.dart';

/// For an action that needs an account: a guest is sent to the sign-in
/// screen. True when the user is signed in, at once or on coming back from
/// it; false when they came back without signing in.
Future<bool> ensureSignedIn(BuildContext context, WidgetRef ref) async {
  if (ref.read(authStatusProvider) == AuthStatus.signedIn) return true;
  await context.push(AppRoutes.login);
  if (!context.mounted) return false;
  return ref.read(authStatusProvider) == AuthStatus.signedIn;
}

/// Temporary sign-in screen built from stock widgets until the design has one.
/// The logic behind it (controller, repository, tokens) is the real one.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _login = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _login.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final signedIn = await ref
        .read(loginControllerProvider.notifier)
        .submit(login: _login.text, password: _password.text);
    if (signedIn && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(loginControllerProvider);
    final loading = state.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(DSSpacing.base),
          children: [
            TextField(
              controller: _login,
              enabled: !loading,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.loginFieldLogin),
            ),
            const SizedBox(height: DSSpacing.md),
            TextField(
              controller: _password,
              enabled: !loading,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(labelText: l10n.loginFieldPassword),
            ),
            if (state.error case final error?) ...[
              const SizedBox(height: DSSpacing.md),
              Text(
                errorText(context, error),
                style: DSTypography.bodySm.copyWith(
                  color: context.colors.textError,
                ),
              ),
            ],
            const SizedBox(height: DSSpacing.lg),
            SizedBox(
              height: DSSizes.buttonHeightMd,
              child: FilledButton(
                onPressed: loading ? null : _submit,
                child: loading
                    ? const SizedBox.square(
                        dimension: DSSizes.iconSm,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.signIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
