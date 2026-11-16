// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Armenian (`hy`).
class AppLocalizationsHy extends AppLocalizations {
  AppLocalizationsHy([String locale = 'hy']) : super(locale);

  @override
  String get tabHome => 'Գլխավոր';

  @override
  String get tabOrder => 'Պատվեր';

  @override
  String get orderTabProducts => 'Ապրանքներ';

  @override
  String get orderTabBranches => 'Մասնաճյուղեր';

  @override
  String get tabGifts => 'Նվերներ';

  @override
  String get tabProfile => 'Պրոֆիլ';

  @override
  String get chooseBranch => 'Ընտրել մասնաճյուղ';

  @override
  String get choose => 'Ընտրել';

  @override
  String get otherDistrict => 'Այլ';

  @override
  String get notifications => 'Ծանուցումներ';

  @override
  String get loginTitle => 'Մուտք';

  @override
  String get loginFieldLogin => 'Էլ. փոստ կամ հեռախոս';

  @override
  String get loginFieldPassword => 'Գաղտնաբառ';

  @override
  String get signIn => 'Մուտք գործել';

  @override
  String get signOut => 'Դուրս գալ';

  @override
  String get errorNoConnection => 'Ինտերնետ կապ չկա';

  @override
  String get errorGeneric => 'Ինչ-որ բան սխալ է։ Խնդրում ենք կրկին փորձել։';

  @override
  String get retry => 'Կրկին փորձել';

  @override
  String get nearestBranches => 'Մոտակա մասնաճյուղեր';

  @override
  String get branchOpen => 'Բաց է';

  @override
  String get branchClosed => 'Փակ է';

  @override
  String get branchClosedToday => 'Այսօր փակ է';

  @override
  String distanceKm(String km) {
    return '$km կմ';
  }

  @override
  String get featuredProducts => 'Առաջարկում ենք';

  @override
  String get menuTitle => 'Մենյու';

  @override
  String get menuEmpty => 'Մենյուն դատարկ է';

  @override
  String checkoutWithTotal(String total) {
    return 'Պատվիրել · $total';
  }

  @override
  String get addToCart => 'Ավելացնել զամբյուղ';

  @override
  String get quantityDecrease => 'Պակասեցնել քանակը';

  @override
  String get quantityIncrease => 'Ավելացնել քանակը';

  @override
  String get back => 'Հետ';

  @override
  String get rateBranch => 'Գնահատել մասնաճյուղը';

  @override
  String get showOnMap => 'Ցույց տալ քարտեզի վրա';

  @override
  String get leaveFeedback => 'Թողնել կարծիք';

  @override
  String get feedbackHint => 'Պատմեք ձեր այցի մասին';

  @override
  String get send => 'Ուղարկել';

  @override
  String ratingStar(int star) {
    return '$star՝ 5-ից';
  }

  @override
  String addWithTotal(String total) {
    return 'Ավելացնել · $total';
  }

  @override
  String saveWithTotal(String total) {
    return 'Պահպանել · $total';
  }

  @override
  String portionGrams(String amount) {
    return '$amount գ';
  }

  @override
  String portionKilograms(String amount) {
    return '$amount կգ';
  }

  @override
  String portionMilliliters(String amount) {
    return '$amount մլ';
  }

  @override
  String portionLiters(String amount) {
    return '$amount լ';
  }

  @override
  String get cancel => 'Չեղարկել';

  @override
  String get cartReplaceTitle => 'Դատարկե՞լ զամբյուղը';

  @override
  String get cartReplaceMessage =>
      'Զամբյուղում կարող են լինել միայն մեկ մասնաճյուղի ապրանքներ։ Մասնաճյուղը փոխելիս այն կդատարկվի։';

  @override
  String get cartReplaceConfirm => 'Դատարկել';

  @override
  String get cartTitle => 'Զամբյուղ';

  @override
  String get cartOpen => 'Բացել զամբյուղը';

  @override
  String get cartBarBranch => 'Մասնաճյուղ';

  @override
  String get cartSectionBranch => 'Մասնաճյուղ';

  @override
  String get cartSectionTime => 'Ժամ';

  @override
  String cartSectionOrder(int count) {
    return 'Ձեր պատվերը ($count)';
  }

  @override
  String get cartSectionTip => 'Թեյավճար';

  @override
  String get cartEmpty => 'Զամբյուղը դատարկ է';

  @override
  String get cartAddProducts => 'Ավելացնել ապրանքներ';

  @override
  String get cartLineEdit => 'Փոխել ընտրությունը';

  @override
  String get cartLineRemove => 'Հեռացնել զամբյուղից';

  @override
  String get cartLineUnavailable => 'Այս մասնաճյուղում այժմ հասանելի չէ';

  @override
  String get cartTimeAsap => 'Հիմա';

  @override
  String get cartTipNone => 'Առանց թեյավճարի';

  @override
  String get cartTipOther => 'Այլ';

  @override
  String get cartTipHint => 'Մուտքագրեք թեյավճարի գումարը';

  @override
  String get cartSectionPayment => 'Վճարման եղանակ';

  @override
  String get paymentMethodsTitle => 'Ընտրեք վճարման եղանակը';

  @override
  String paymentCard(String digits) {
    return 'Քարտ •••• $digits';
  }

  @override
  String get paymentNewCard => 'Նոր քարտ';

  @override
  String get orderSuccessTitle => 'Ձեր պատվերը հաջողությամբ ձևակերպվել է։';

  @override
  String get orderSuccessBranch => 'Ստացման վայր';

  @override
  String get orderSuccessTime => 'Ստացման ժամ';

  @override
  String get orderTrack => 'Հետևել պատվերին';

  @override
  String get orderStatusTitle => 'Պատվերի կարգավիճակ';

  @override
  String orderStatusPickup(String time) {
    return 'Ստացում · $time';
  }

  @override
  String orderStatusNumber(String number) {
    return '№ $number';
  }

  @override
  String get orderStepPlaced => 'Ձևակերպված';

  @override
  String get orderStepAccepted => 'Ընդունված';

  @override
  String get orderStepPreparing => 'Պատրաստվում է';

  @override
  String get orderStepReady => 'Պատրաստ է';

  @override
  String get loyaltyPointsLabel => 'Հավատարմության միավորներ';

  @override
  String get loyaltyShowCard => 'Ցույց տալ հավատարմության քարտը';

  @override
  String get loyaltyScanHint =>
      'Ցույց տվեք դրամարկղում՝ միավորներ ստանալու համար';

  @override
  String get loyaltyQrLabel => 'Հավատարմության քարտի QR կոդ';

  @override
  String get loyaltyBalanceLabel => 'Հասանելի մնացորդ';

  @override
  String loyaltyPoints(String points) {
    return '$points միավոր';
  }

  @override
  String get walletBalanceTitle => 'Դրամապանակի մնացորդ';

  @override
  String get walletTopUp => 'Լիցքավորել';

  @override
  String get walletTotal => 'Ընդհանուր մնացորդ';

  @override
  String get walletOwnTopUp => 'Լիցքավորումներ';

  @override
  String get walletNoExpiry => 'Առանց ժամկետի · ցանկացած ժամանակ';

  @override
  String get walletGifts => 'Նվեր քարտերից';

  @override
  String walletGiftsTotal(String amount) {
    return 'ընդամենը $amount';
  }

  @override
  String get walletExpiring => 'Ժամկետանց դարձող մաս';

  @override
  String walletExpires(String date) {
    return 'Ուժի մեջ է մինչև $date';
  }

  @override
  String get productAnythingElse => 'Ուրիշ բա՞ն';

  @override
  String orderWithTotal(String total) {
    return 'Պատվիրել · $total';
  }
}
