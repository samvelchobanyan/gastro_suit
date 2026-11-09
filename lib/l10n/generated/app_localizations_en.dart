// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabHome => 'Home';

  @override
  String get tabOrder => 'Order';

  @override
  String get tabGifts => 'Gifts';

  @override
  String get tabProfile => 'Profile';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginFieldLogin => 'Email or phone';

  @override
  String get loginFieldPassword => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get errorNoConnection => 'No internet connection';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';
}
