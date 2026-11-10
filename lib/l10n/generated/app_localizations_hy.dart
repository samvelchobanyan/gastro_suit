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
  String get tabGifts => 'Նվերներ';

  @override
  String get tabProfile => 'Պրոֆիլ';

  @override
  String get homeGreeting => 'Եկեք վայելենք սուրճը';

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
}
