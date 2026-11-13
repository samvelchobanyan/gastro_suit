import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hy'),
    Locale('ru'),
  ];

  /// Bottom navigation: Home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// Order tab: its label in the bottom navigation and the screen title
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get tabOrder;

  /// Order screen: the tab with the menu
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get orderTabProducts;

  /// Order screen: the tab with the branch list
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get orderTabBranches;

  /// Bottom navigation: Gifts tab
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get tabGifts;

  /// Bottom navigation: Profile tab
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// Home header tap target and the branch sheet title
  ///
  /// In en, this message translates to:
  /// **'Choose branch'**
  String get chooseBranch;

  /// Branch sheet: the button that applies the picked branch
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// Branch filter: the district chip for branches that name no district of their city
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherDistrict;

  /// Accessibility label of the notifications bell
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Login screen: title
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// Login screen: login field label
  ///
  /// In en, this message translates to:
  /// **'Email or phone'**
  String get loginFieldLogin;

  /// Login screen: password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginFieldPassword;

  /// Button that signs in (login screen, profile)
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Profile: sign-out button
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Error shown when the device is offline
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorNoConnection;

  /// Error shown when nothing more specific is known
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// Button that repeats a failed load
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// Home: title of the nearest branches section
  ///
  /// In en, this message translates to:
  /// **'Nearest branches'**
  String get nearestBranches;

  /// Branch card: the branch is open now
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get branchOpen;

  /// Branch card: the branch is closed now
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get branchClosed;

  /// Branch card: today is a day off, shown instead of the hours
  ///
  /// In en, this message translates to:
  /// **'Closed today'**
  String get branchClosedToday;

  /// Distance to a branch, e.g. 1.2 km
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String distanceKm(String km);

  /// Order tab: title of the featured products row
  ///
  /// In en, this message translates to:
  /// **'Featured products'**
  String get featuredProducts;

  /// Title over a branch's menu
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// Shown instead of the menu when the branch offers nothing
  ///
  /// In en, this message translates to:
  /// **'The menu is empty'**
  String get menuEmpty;

  /// Branch screen: the button that opens the cart, with its total, e.g. Checkout · ֏1,450
  ///
  /// In en, this message translates to:
  /// **'Checkout · {total}'**
  String checkoutWithTotal(String total);

  /// Accessibility label of the plus on a product card
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// Accessibility label of the minus of a quantity stepper
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get quantityDecrease;

  /// Accessibility label of the plus of a quantity stepper
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get quantityIncrease;

  /// Accessibility label of a back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Branch screen: accessibility label of the button that opens the feedback sheet
  ///
  /// In en, this message translates to:
  /// **'Rate the branch'**
  String get rateBranch;

  /// Branch screen: accessibility label of the button that opens the map
  ///
  /// In en, this message translates to:
  /// **'Show on map'**
  String get showOnMap;

  /// Title of the sheet where the user rates a branch
  ///
  /// In en, this message translates to:
  /// **'Leave a feedback'**
  String get leaveFeedback;

  /// Feedback sheet: placeholder of the text field
  ///
  /// In en, this message translates to:
  /// **'Tell us about your visit'**
  String get feedbackHint;

  /// Button that sends what the user entered
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Accessibility label of one star of a rating input, e.g. 3 of 5
  ///
  /// In en, this message translates to:
  /// **'{star} of 5'**
  String ratingStar(int star);

  /// Product sheet: the button that adds the product to the cart, with what the chosen quantity costs, e.g. Add · ֏1,450
  ///
  /// In en, this message translates to:
  /// **'Add · {total}'**
  String addWithTotal(String total);

  /// A portion in grams, e.g. 120 g
  ///
  /// In en, this message translates to:
  /// **'{amount} g'**
  String portionGrams(String amount);

  /// A portion in kilograms, e.g. 1.5 kg
  ///
  /// In en, this message translates to:
  /// **'{amount} kg'**
  String portionKilograms(String amount);

  /// A portion in millilitres, e.g. 300 ml
  ///
  /// In en, this message translates to:
  /// **'{amount} ml'**
  String portionMilliliters(String amount);

  /// A portion in litres, e.g. 1 l
  ///
  /// In en, this message translates to:
  /// **'{amount} l'**
  String portionLiters(String amount);

  /// Button that backs out of a question
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Title of the question asked before the branch changes while the cart holds products: on choosing another branch, or on adding a product of another branch
  ///
  /// In en, this message translates to:
  /// **'Clear the cart?'**
  String get cartReplaceTitle;

  /// The sentence under cartReplaceTitle
  ///
  /// In en, this message translates to:
  /// **'The cart holds products of one branch only. Changing the branch will clear it.'**
  String get cartReplaceMessage;

  /// Button that agrees to clearing the cart
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get cartReplaceConfirm;

  /// Title of the cart sheet
  ///
  /// In en, this message translates to:
  /// **'Basket'**
  String get cartTitle;

  /// Accessibility label of the cart button
  ///
  /// In en, this message translates to:
  /// **'Open the basket'**
  String get cartOpen;

  /// Order tab: label over the branch field of the cart bar
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get cartBarBranch;

  /// Cart sheet: title of the part with the branch; shown in capitals
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get cartSectionBranch;

  /// Cart sheet: title of the part with the pickup time; shown in capitals
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get cartSectionTime;

  /// Cart sheet: title of the list of products with how many pieces it holds; shown in capitals
  ///
  /// In en, this message translates to:
  /// **'Your order ({count})'**
  String cartSectionOrder(int count);

  /// Cart sheet: title of the part with the tip; shown in capitals
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get cartSectionTip;

  /// Cart sheet: shown in place of the products when there are none
  ///
  /// In en, this message translates to:
  /// **'Your basket is empty'**
  String get cartEmpty;

  /// Cart sheet: the link under the products that goes back to the menu
  ///
  /// In en, this message translates to:
  /// **'Add products'**
  String get cartAddProducts;

  /// Accessibility label of the button that removes a line of the cart
  ///
  /// In en, this message translates to:
  /// **'Remove from the basket'**
  String get cartLineRemove;

  /// Cart sheet: under a line the branch cannot make
  ///
  /// In en, this message translates to:
  /// **'Not available at this branch now'**
  String get cartLineUnavailable;

  /// Cart sheet: the first of the pickup times, as soon as possible
  ///
  /// In en, this message translates to:
  /// **'ASAP'**
  String get cartTimeAsap;

  /// Cart sheet: the first of the tip amounts
  ///
  /// In en, this message translates to:
  /// **'No tip'**
  String get cartTipNone;

  /// Cart sheet: the last of the tip amounts, opens a field for an amount of the user's own
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get cartTipOther;

  /// Cart sheet: placeholder of the field for a tip of the user's own
  ///
  /// In en, this message translates to:
  /// **'Enter tip amount'**
  String get cartTipHint;

  /// Cart sheet: the button that places the order, with the cart's total, e.g. Order · ֏1,450
  ///
  /// In en, this message translates to:
  /// **'Order · {total}'**
  String orderWithTotal(String total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hy', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hy':
      return AppLocalizationsHy();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
