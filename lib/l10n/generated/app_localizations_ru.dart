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
  String get orderTabProducts => 'Продукты';

  @override
  String get orderTabBranches => 'Филиалы';

  @override
  String get tabGifts => 'Подарки';

  @override
  String get tabProfile => 'Профиль';

  @override
  String get chooseBranch => 'Выбрать филиал';

  @override
  String get choose => 'Выбрать';

  @override
  String get otherDistrict => 'Другие';

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

  @override
  String get retry => 'Повторить';

  @override
  String get nearestBranches => 'Ближайшие филиалы';

  @override
  String get branchOpen => 'Открыто';

  @override
  String get branchClosed => 'Закрыто';

  @override
  String get branchClosedToday => 'Сегодня закрыто';

  @override
  String distanceKm(String km) {
    return '$km км';
  }

  @override
  String get featuredProducts => 'Рекомендуем';

  @override
  String get menuTitle => 'Меню';

  @override
  String get menuEmpty => 'Меню пусто';

  @override
  String checkoutWithTotal(String total) {
    return 'Оформить · $total';
  }

  @override
  String get addToCart => 'Добавить в корзину';

  @override
  String get quantityDecrease => 'Уменьшить количество';

  @override
  String get quantityIncrease => 'Увеличить количество';

  @override
  String get back => 'Назад';

  @override
  String get rateBranch => 'Оценить филиал';

  @override
  String get showOnMap => 'Показать на карте';

  @override
  String get leaveFeedback => 'Оставить отзыв';

  @override
  String get feedbackHint => 'Расскажите о вашем визите';

  @override
  String get send => 'Отправить';

  @override
  String ratingStar(int star) {
    return '$star из 5';
  }

  @override
  String addWithTotal(String total) {
    return 'Добавить · $total';
  }

  @override
  String portionGrams(String amount) {
    return '$amount г';
  }

  @override
  String portionKilograms(String amount) {
    return '$amount кг';
  }

  @override
  String portionMilliliters(String amount) {
    return '$amount мл';
  }

  @override
  String portionLiters(String amount) {
    return '$amount л';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get cartReplaceTitle => 'Очистить корзину?';

  @override
  String get cartReplaceMessage =>
      'В корзине могут быть товары только одного филиала. При смене филиала она будет очищена.';

  @override
  String get cartReplaceConfirm => 'Очистить';

  @override
  String get cartTitle => 'Корзина';

  @override
  String get cartOpen => 'Открыть корзину';

  @override
  String get cartBarBranch => 'Филиал';

  @override
  String get cartSectionBranch => 'Филиал';

  @override
  String get cartSectionTime => 'Время';

  @override
  String cartSectionOrder(int count) {
    return 'Ваш заказ ($count)';
  }

  @override
  String get cartSectionTip => 'Чаевые';

  @override
  String get cartEmpty => 'Корзина пуста';

  @override
  String get cartAddProducts => 'Добавить товары';

  @override
  String get cartLineRemove => 'Убрать из корзины';

  @override
  String get cartLineUnavailable => 'Сейчас недоступно в этом филиале';

  @override
  String get cartTimeAsap => 'Сейчас';

  @override
  String get cartTipNone => 'Без чаевых';

  @override
  String get cartTipOther => 'Другое';

  @override
  String get cartTipHint => 'Введите сумму чаевых';

  @override
  String orderWithTotal(String total) {
    return 'Заказать · $total';
  }
}
