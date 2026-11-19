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
  String get loginPhoneHint =>
      'Введите номер телефона — мы отправим код подтверждения.';

  @override
  String get loginClearPhone => 'Очистить номер';

  @override
  String get loginSendCode => 'Отправить код';

  @override
  String get loginCodeTitle => 'Введите код';

  @override
  String loginCodeHint(int count, String phone) {
    return 'Введите код из $count цифр, отправленный на $phone.';
  }

  @override
  String get loginCodeField => 'Код подтверждения';

  @override
  String get loginResend => 'Отправить ещё раз';

  @override
  String get loginResent => 'Отправлено';

  @override
  String get loginChangeNumber => 'Изменить номер';

  @override
  String get loginVerify => 'Подтвердить';

  @override
  String get signIn => 'Войти';

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
  String saveWithTotal(String total) {
    return 'Сохранить · $total';
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
  String get cartLineEdit => 'Изменить выбор';

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
  String get cartSectionPayment => 'Способ оплаты';

  @override
  String get paymentMethodsTitle => 'Выберите способ оплаты';

  @override
  String paymentCard(String digits) {
    return 'Карта •••• $digits';
  }

  @override
  String get paymentNewCard => 'Новая карта';

  @override
  String get orderSuccessTitle => 'Ваш заказ успешно оформлен!';

  @override
  String get orderSuccessBranch => 'Где забрать';

  @override
  String get orderSuccessTime => 'Время получения';

  @override
  String get orderTrack => 'Отследить заказ';

  @override
  String get orderStatusTitle => 'Статус заказа';

  @override
  String orderStatusPickup(String time) {
    return 'Самовывоз · $time';
  }

  @override
  String orderStatusNumber(String number) {
    return '№ $number';
  }

  @override
  String get orderStepPlaced => 'Оформлен';

  @override
  String get orderStepAccepted => 'Принят';

  @override
  String get orderStepPreparing => 'Готовится';

  @override
  String get orderStepReady => 'Готов';

  @override
  String get loyaltyPointsLabel => 'Баллы лояльности';

  @override
  String get loyaltyShowCard => 'Показать карту лояльности';

  @override
  String get loyaltyScanHint => 'Покажите на кассе, чтобы получить баллы';

  @override
  String get loyaltyQrLabel => 'QR-код карты лояльности';

  @override
  String get loyaltyBalanceLabel => 'Доступный баланс';

  @override
  String loyaltyPoints(String points) {
    return '$points б.';
  }

  @override
  String get walletBalanceTitle => 'Баланс кошелька';

  @override
  String get walletTopUp => 'Пополнить';

  @override
  String get walletTotal => 'Общий баланс';

  @override
  String get walletOwnTopUp => 'Пополнения';

  @override
  String get walletNoExpiry => 'Без срока · в любое время';

  @override
  String get walletGifts => 'Подарочные карты';

  @override
  String walletGiftsTotal(String amount) {
    return 'всего $amount';
  }

  @override
  String get walletExpiring => 'Сгорающая часть';

  @override
  String walletExpires(String date) {
    return 'Сгорает $date';
  }

  @override
  String get walletTopUpTitle => 'Пополнение кошелька';

  @override
  String get walletTopUpAmountHint => 'Введите сумму';

  @override
  String walletTopUpLimits(String min, String max) {
    return 'От $min до $max';
  }

  @override
  String get walletTopUpUnavailable => 'Оплата этим способом пока недоступна';

  @override
  String walletTopUpSuccess(String amount) {
    return 'Кошелёк успешно пополнен на $amount';
  }

  @override
  String get continueAction => 'Продолжить';

  @override
  String get productAnythingElse => 'Что-нибудь ещё?';

  @override
  String orderWithTotal(String total) {
    return 'Заказать · $total';
  }

  @override
  String get profileBankCards => 'Банковские карты';

  @override
  String get profileHistory => 'История';

  @override
  String get profileHistorySubtitle => 'Ваши заказы и операции';

  @override
  String get profileFavorites => 'Избранные товары';

  @override
  String profileFavoritesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товара',
      many: '$count товаров',
      few: '$count товара',
      one: '$count товар',
    );
    return '$_temp0';
  }

  @override
  String get profilePush => 'Push-уведомления';

  @override
  String get profileLanguage => 'Язык';

  @override
  String get profileDangerZone => 'Опасная зона';

  @override
  String get profileLogout => 'Выйти';

  @override
  String get profileDeleteAccount => 'Удалить аккаунт';

  @override
  String get profileDeleteTitle => 'Удалить аккаунт?';

  @override
  String get profileDeleteMessage =>
      'Аккаунт и все его данные будут удалены. Это действие нельзя отменить.';

  @override
  String get profileDeleteConfirm => 'Удалить';

  @override
  String get profileTerms => 'Условия использования';

  @override
  String get profileAboutDeveloper => 'О разработчике';

  @override
  String get profileEdit => 'Редактировать профиль';

  @override
  String get inviteTitle => 'Пригласи друга';

  @override
  String get inviteDescription => 'и получи баллы лояльности';

  @override
  String get inviteAction => 'Пригласить';

  @override
  String get historyTabOrders => 'Заказы';

  @override
  String get historyTabTransactions => 'Операции';

  @override
  String get historyOrdersEmpty => 'Заказов пока нет';

  @override
  String get historyTransactionsEmpty => 'Операций пока нет';

  @override
  String historyOrderNumber(String number) {
    return 'Заказ №$number';
  }

  @override
  String get transactionTopUp => 'Пополнение кошелька';

  @override
  String get transactionSpend => 'Оплата из кошелька';

  @override
  String get orderDetailsTitle => 'Детали заказа';

  @override
  String get orderStatusCompleted => 'Выполнен';

  @override
  String get orderStatusCancelled => 'Отменён';

  @override
  String get orderStatusAwaitingPayment => 'Ожидает оплаты';

  @override
  String get orderStatusPaymentFailed => 'Оплата не прошла';

  @override
  String get orderDetailsDate => 'Дата заказа';

  @override
  String get orderDetailsFulfilment => 'Способ получения';

  @override
  String get orderDetailsPickup => 'Самовывоз';

  @override
  String get orderDetailsPaymentMethod => 'Способ оплаты';

  @override
  String get orderDetailsOnlinePayment => 'Онлайн-оплата';

  @override
  String get orderDetailsPaymentStatus => 'Статус оплаты';

  @override
  String get orderDetailsPaid => 'Оплачен';

  @override
  String get orderDetailsComment => 'Комментарий к заказу';

  @override
  String get orderDetailsYourOrder => 'Ваш заказ';

  @override
  String get orderDetailsSubtotal => 'Сумма заказа';

  @override
  String get orderDetailsDiscount => 'Скидка';

  @override
  String get orderDetailsTotal => 'Итого';

  @override
  String get favoriteAdd => 'Добавить в избранное';

  @override
  String get favoriteRemove => 'Убрать из избранного';

  @override
  String get buyAgain => 'Купить снова';

  @override
  String get favorites => 'Избранное';

  @override
  String get favoritesEmpty => 'Избранных товаров пока нет';

  @override
  String get favoritesNoneAtBranch =>
      'В этом филиале нет ваших избранных товаров';

  @override
  String get save => 'Сохранить';

  @override
  String get profileChangePhoto => 'Изменить фото';

  @override
  String get profilePhotoFromGallery => 'Выбрать из галереи';

  @override
  String get profilePhotoFromCamera => 'Сделать снимок';

  @override
  String get profilePhotoUnavailable =>
      'Не удалось получить фото. Проверьте, что приложению разрешён доступ к камере и фото.';

  @override
  String get profileFirstName => 'Имя';

  @override
  String get profileLastName => 'Фамилия';

  @override
  String get profileBirthday => 'День рождения';

  @override
  String get profileBirthdayDay => 'День';

  @override
  String get profileBirthdayMonth => 'Месяц';

  @override
  String get profileBirthdayYear => 'Год';

  @override
  String get profileCity => 'Город';

  @override
  String get profileGender => 'Пол';

  @override
  String get profileGenderMale => 'Мужской';

  @override
  String get profileGenderFemale => 'Женский';
}
