import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/config/app_config.dart';
import '../../../core/di/repositories.dart';
import '../../../core/network/app_exception.dart';

part 'login_sheet_controller.freezed.dart';

/// The two steps of signing in: the phone number, then the code sent to it.
enum LoginStep { phone, code }

/// Where the sign-in sheet stands.
@freezed
abstract class LoginSheetState with _$LoginSheetState {
  const factory LoginSheetState({
    @Default(LoginStep.phone) LoginStep step,

    /// The digits of the number after the country code.
    @Default('') String phone,

    /// A request is on its way: a code is being sent or checked.
    @Default(false) bool busy,

    /// A code was just sent again; goes back to false in a moment.
    @Default(false) bool resent,

    /// Why the last request was refused; gone once the user edits.
    AppException? error,
  }) = _LoginSheetState;
}

/// Signing in by phone: asks the server to send a code to the number, then
/// trades the code for a session. The same two steps make an account when
/// the number has none.
class LoginSheetController extends Notifier<LoginSheetState> {
  /// How many digits the server's code has.
  static const codeLength = 6;

  /// How long "Sent" stands in place of "Resend code".
  static const resentNotice = Duration(seconds: 3);

  Timer? _resentTimer;

  @override
  LoginSheetState build() {
    ref.onDispose(() => _resentTimer?.cancel());
    return const LoginSheetState();
  }

  AppConfig get _config => ref.read(appConfigProvider);

  /// The whole number, as the server takes it.
  String get fullPhone => '${_config.phoneCountryCode}${state.phone}';

  bool get isPhoneComplete => state.phone.length == _config.phoneNumberLength;

  void setPhone(String digits) {
    state = state.copyWith(phone: digits, error: null);
  }

  /// The code is being typed again: the refusal of the last one goes.
  void codeEdited() {
    if (state.error != null) state = state.copyWith(error: null);
  }

  /// Sends a code to the number and moves on to the code step.
  Future<void> sendCode() async {
    if (state.busy || !isPhoneComplete) return;
    if (await _request()) {
      state = state.copyWith(step: LoginStep.code);
    }
  }

  /// Sends a code to the same number once more.
  Future<void> resend() async {
    if (state.busy) return;
    if (await _request()) {
      state = state.copyWith(resent: true);
      _resentTimer?.cancel();
      _resentTimer = Timer(resentNotice, () {
        state = state.copyWith(resent: false);
      });
    }
  }

  Future<bool> _request() async {
    state = state.copyWith(busy: true, error: null);
    try {
      await ref.read(authRepositoryProvider).requestCode(fullPhone);
      if (!ref.mounted) return false;
      state = state.copyWith(busy: false);
      return true;
    } on AppException catch (error) {
      if (ref.mounted) state = state.copyWith(busy: false, error: error);
      return false;
    }
  }

  /// Back to the phone step, to enter another number.
  void changeNumber() {
    if (state.busy) return;
    state = state.copyWith(step: LoginStep.phone, error: null, resent: false);
  }

  /// Signs in with [code]. True when signed in; a refusal stays in the
  /// state.
  Future<bool> verify(String code) async {
    if (state.busy || code.length != codeLength) return false;
    state = state.copyWith(busy: true, error: null);
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithCode(
            phone: fullPhone,
            code: code,
            restaurantId: _config.restaurantId,
          );
      if (ref.mounted) state = state.copyWith(busy: false);
      return true;
    } on AppException catch (error) {
      if (ref.mounted) state = state.copyWith(busy: false, error: error);
      return false;
    }
  }
}

final loginSheetProvider =
    NotifierProvider.autoDispose<LoginSheetController, LoginSheetState>(
      LoginSheetController.new,
    );
