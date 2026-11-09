// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get tabHome => 'Главная';

  @override
  String get tabOrder => 'Заказ';

  @override
  String get tabGifts => 'Подарки';

  @override
  String get tabProfile => 'Профиль';

  @override
  String get homeGreeting => 'Время насладиться кофе';

  @override
  String get notifications => 'Уведомления';

  @override
  String get loginTitle => 'Вход';

  @override
  String get loginFieldLogin => 'Email или телефон';

  @override
  String get loginFieldPassword => 'Пароль';

  @override
  String get signIn => 'Войти';

  @override
  String get signOut => 'Выйти';

  @override
  String get errorNoConnection => 'Нет подключения к интернету';

  @override
  String get errorGeneric => 'Что-то пошло не так. Попробуйте ещё раз.';
}
