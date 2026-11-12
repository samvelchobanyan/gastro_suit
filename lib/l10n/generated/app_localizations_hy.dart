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
}
