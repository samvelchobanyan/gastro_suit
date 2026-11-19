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

  /// Sign-in sheet: title of the phone step
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginTitle;

  /// Sign-in sheet: text under the title of the phone step
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and we\'ll send you a verification code.'**
  String get loginPhoneHint;

  /// Sign-in sheet: the cross in the phone field, for screen readers
  ///
  /// In en, this message translates to:
  /// **'Clear phone number'**
  String get loginClearPhone;

  /// Sign-in sheet: button of the phone step
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get loginSendCode;

  /// Sign-in sheet: title of the code step
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get loginCodeTitle;

  /// Sign-in sheet: text under the title of the code step
  ///
  /// In en, this message translates to:
  /// **'Enter the {count} digit code sent to {phone}.'**
  String loginCodeHint(int count, String phone);

  /// Sign-in sheet: the code field, for screen readers
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get loginCodeField;

  /// Sign-in sheet: sends the code again
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get loginResend;

  /// Sign-in sheet: stands in place of 'Resend code' right after the code was sent again
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get loginResent;

  /// Sign-in sheet: goes back to the phone step
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get loginChangeNumber;

  /// Sign-in sheet: button of the code step
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get loginVerify;

  /// Button that opens the sign-in sheet (profile)
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

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

  /// Product sheet opened from a cart line: the button that saves the changed choice, with what the chosen quantity costs, e.g. Save · ֏1,450
  ///
  /// In en, this message translates to:
  /// **'Save · {total}'**
  String saveWithTotal(String total);

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

  /// Cart sheet: what the pencil button of a line does, for screen readers
  ///
  /// In en, this message translates to:
  /// **'Change the choice'**
  String get cartLineEdit;

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

  /// Cart sheet: title of the part with the way to pay; shown in capitals
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get cartSectionPayment;

  /// Title of the sheet that lists the ways to pay for an order
  ///
  /// In en, this message translates to:
  /// **'Choose payment method'**
  String get paymentMethodsTitle;

  /// A saved bank card, named by its last four digits, e.g. Card •••• 1111
  ///
  /// In en, this message translates to:
  /// **'Card •••• {digits}'**
  String paymentCard(String digits);

  /// The way to pay with a card that is not saved yet
  ///
  /// In en, this message translates to:
  /// **'New card'**
  String get paymentNewCard;

  /// Success screen after placing an order: the title
  ///
  /// In en, this message translates to:
  /// **'Your order has been successfully placed!'**
  String get orderSuccessTitle;

  /// Success screen after placing an order: label over the branch to collect the order from
  ///
  /// In en, this message translates to:
  /// **'Pickup location'**
  String get orderSuccessBranch;

  /// Success screen after placing an order: label over the time the order is wanted for
  ///
  /// In en, this message translates to:
  /// **'Pickup time'**
  String get orderSuccessTime;

  /// Success screen after placing an order: the button that leads to the order's status
  ///
  /// In en, this message translates to:
  /// **'Track order'**
  String get orderTrack;

  /// Home, the block of an order on its way: its title
  ///
  /// In en, this message translates to:
  /// **'Order status'**
  String get orderStatusTitle;

  /// Home, the block of an order on its way: how and when it is collected, e.g. Pickup · ASAP, Pickup · 18:30
  ///
  /// In en, this message translates to:
  /// **'Pickup · {time}'**
  String orderStatusPickup(String time);

  /// Home, the block of an order on its way: the number the order is called by at the counter
  ///
  /// In en, this message translates to:
  /// **'No. {number}'**
  String orderStatusNumber(String number);

  /// Order status, step 1 of 4: the order is paid and sent to the restaurant. Short, one word if possible
  ///
  /// In en, this message translates to:
  /// **'Placed'**
  String get orderStepPlaced;

  /// Order status, step 2 of 4: the restaurant took the order. Short, one word if possible
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get orderStepAccepted;

  /// Order status, step 3 of 4: the order is being made. Short
  ///
  /// In en, this message translates to:
  /// **'In process'**
  String get orderStepPreparing;

  /// Order status, step 4 of 4: the order waits at the counter. Short, one word if possible
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get orderStepReady;

  /// Home, the loyalty card: the label over the number of points
  ///
  /// In en, this message translates to:
  /// **'Loyalty points'**
  String get loyaltyPointsLabel;

  /// Home, the loyalty card: what tapping it does, read by screen readers
  ///
  /// In en, this message translates to:
  /// **'Show loyalty card'**
  String get loyaltyShowCard;

  /// Loyalty card sheet: the line under the QR code the cashier scans
  ///
  /// In en, this message translates to:
  /// **'Scan at checkout to earn points'**
  String get loyaltyScanHint;

  /// Loyalty card sheet: what the QR code is, read by screen readers
  ///
  /// In en, this message translates to:
  /// **'Loyalty QR code'**
  String get loyaltyQrLabel;

  /// Loyalty card sheet: the label over the points the user has
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get loyaltyBalanceLabel;

  /// A number of loyalty points, short, e.g. 1,240 pts
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String loyaltyPoints(String points);

  /// Home's wallet: the label over the balance; also the title of the sheet that breaks the balance down
  ///
  /// In en, this message translates to:
  /// **'Wallet balance'**
  String get walletBalanceTitle;

  /// The button that adds money to the wallet
  ///
  /// In en, this message translates to:
  /// **'Top up'**
  String get walletTopUp;

  /// Wallet balance sheet: the label over all the money in the wallet
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get walletTotal;

  /// Wallet balance sheet: the money the user added themselves
  ///
  /// In en, this message translates to:
  /// **'Top-up balance'**
  String get walletOwnTopUp;

  /// Wallet balance sheet: the note under the money the user added themselves
  ///
  /// In en, this message translates to:
  /// **'No expiry · use anytime'**
  String get walletNoExpiry;

  /// Wallet balance sheet: the heading of the money that came as gifts
  ///
  /// In en, this message translates to:
  /// **'From gift cards'**
  String get walletGifts;

  /// Wallet balance sheet: the sum of the money that came as gifts, e.g. ֏2,680 total
  ///
  /// In en, this message translates to:
  /// **'{amount} total'**
  String walletGiftsTotal(String amount);

  /// Wallet balance sheet: the part of the wallet that expires next
  ///
  /// In en, this message translates to:
  /// **'Expiring balance'**
  String get walletExpiring;

  /// Wallet balance sheet: when a part of the wallet expires, e.g. Expires Dec 16, 2026
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String walletExpires(String date);

  /// Title of the sheet where the user adds money to the wallet
  ///
  /// In en, this message translates to:
  /// **'Top up wallet'**
  String get walletTopUpTitle;

  /// Top-up sheet: the hint in the empty amount field
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get walletTopUpAmountHint;

  /// Top-up sheet: the least and the most that can be added at once, under the amount field
  ///
  /// In en, this message translates to:
  /// **'From {min} to {max}'**
  String walletTopUpLimits(String min, String max);

  /// Top-up sheet: shown when the payment needs the bank's page, which the app does not open yet
  ///
  /// In en, this message translates to:
  /// **'Paying this way is not available yet'**
  String get walletTopUpUnavailable;

  /// Success screen after topping up the wallet
  ///
  /// In en, this message translates to:
  /// **'You have successfully topped up your wallet by {amount}'**
  String walletTopUpSuccess(String amount);

  /// A button that closes a finished step and goes on
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Product sheet: the title of the rail of products suggested with this one
  ///
  /// In en, this message translates to:
  /// **'Anything else?'**
  String get productAnythingElse;

  /// Cart sheet: the button that places the order, with the cart's total, e.g. Order · ֏1,450
  ///
  /// In en, this message translates to:
  /// **'Order · {total}'**
  String orderWithTotal(String total);

  /// Profile: the row that leads to the saved cards
  ///
  /// In en, this message translates to:
  /// **'Bank cards'**
  String get profileBankCards;

  /// Profile: the row that leads to past orders and payments
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get profileHistory;

  /// Profile: the line under History
  ///
  /// In en, this message translates to:
  /// **'Your orders and transactions'**
  String get profileHistorySubtitle;

  /// Profile: the row that leads to the favourite products
  ///
  /// In en, this message translates to:
  /// **'Favorite products'**
  String get profileFavorites;

  /// Profile: how many favourite products the user has
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product} other{{count} products}}'**
  String profileFavoritesCount(int count);

  /// Profile: the row with the switch of push notifications
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get profilePush;

  /// Profile: the title over the choice of the app's language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// Profile: the title over signing out and deleting the account
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get profileDangerZone;

  /// Profile: the row that signs the user out
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// Profile: the row that deletes the account
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteAccount;

  /// Delete account dialog: title
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get profileDeleteTitle;

  /// Delete account dialog: message
  ///
  /// In en, this message translates to:
  /// **'Your account and everything in it will be deleted. This cannot be undone.'**
  String get profileDeleteMessage;

  /// Delete account dialog: the button that deletes
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileDeleteConfirm;

  /// Profile: link at the bottom
  ///
  /// In en, this message translates to:
  /// **'Terms & conditions'**
  String get profileTerms;

  /// Profile: link at the bottom
  ///
  /// In en, this message translates to:
  /// **'About developer'**
  String get profileAboutDeveloper;

  /// Profile: the pencil button on the user card, for screen readers; the title of the screen it opens
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEdit;

  /// Profile: the title of the invite card
  ///
  /// In en, this message translates to:
  /// **'Invite a friend'**
  String get inviteTitle;

  /// Profile: the line under the title of the invite card
  ///
  /// In en, this message translates to:
  /// **'and get loyalty points'**
  String get inviteDescription;

  /// Profile: the button of the invite card
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get inviteAction;

  /// History: the tab with the orders
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get historyTabOrders;

  /// History: the tab with the money that moved
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get historyTabTransactions;

  /// History: shown when the user has no orders
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get historyOrdersEmpty;

  /// History: shown when no money has moved
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get historyTransactionsEmpty;

  /// History: an order's number on its row
  ///
  /// In en, this message translates to:
  /// **'Order #{number}'**
  String historyOrderNumber(String number);

  /// History: money that came into the wallet
  ///
  /// In en, this message translates to:
  /// **'Wallet top up'**
  String get transactionTopUp;

  /// History: money the wallet paid towards an order
  ///
  /// In en, this message translates to:
  /// **'Wallet payment'**
  String get transactionSpend;

  /// Order details: the screen's title
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get orderDetailsTitle;

  /// Order details: the status of an order that was handed over
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get orderStatusCompleted;

  /// Order details: the status of a cancelled order
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// Order details: the status of an order not paid for yet
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get orderStatusAwaitingPayment;

  /// Order details: the status of an order whose payment failed
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get orderStatusPaymentFailed;

  /// Order details: when the order was placed
  ///
  /// In en, this message translates to:
  /// **'Order date'**
  String get orderDetailsDate;

  /// Order details: how the order is received
  ///
  /// In en, this message translates to:
  /// **'Fulfilment type'**
  String get orderDetailsFulfilment;

  /// Order details: the order is collected at the branch
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get orderDetailsPickup;

  /// Order details: how the order was paid
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get orderDetailsPaymentMethod;

  /// Order details: the order was paid in the app
  ///
  /// In en, this message translates to:
  /// **'Online payment'**
  String get orderDetailsOnlinePayment;

  /// Order details: whether the order is paid
  ///
  /// In en, this message translates to:
  /// **'Payment status'**
  String get orderDetailsPaymentStatus;

  /// Order details: the order is paid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get orderDetailsPaid;

  /// Order details: what the user wrote to the kitchen
  ///
  /// In en, this message translates to:
  /// **'Order comment'**
  String get orderDetailsComment;

  /// Order details: the title over the products
  ///
  /// In en, this message translates to:
  /// **'Your order'**
  String get orderDetailsYourOrder;

  /// Order details: the products together
  ///
  /// In en, this message translates to:
  /// **'Order subtotal'**
  String get orderDetailsSubtotal;

  /// Order details: what was taken off
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get orderDetailsDiscount;

  /// Order details: what the order cost
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get orderDetailsTotal;

  /// The heart on a product that is not a favourite, for screen readers
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get favoriteAdd;

  /// The heart on a favourite product, for screen readers
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get favoriteRemove;

  /// Home: the tab over the rail of what the user ordered before
  ///
  /// In en, this message translates to:
  /// **'Buy again'**
  String get buyAgain;

  /// Home: the tab over the rail of favourite products
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Favorite products: shown when the user has none
  ///
  /// In en, this message translates to:
  /// **'No favorite products yet'**
  String get favoritesEmpty;

  /// Favorite products: shown when the active branch sells none of them
  ///
  /// In en, this message translates to:
  /// **'None of your favorite products is sold at this branch'**
  String get favoritesNoneAtBranch;

  /// A button that saves what was entered
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Edit profile: under the photo, and the title of the sheet that asks where to take one from
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get profileChangePhoto;

  /// Edit profile: take the photo from the phone's gallery
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get profilePhotoFromGallery;

  /// Edit profile: take the photo with the camera
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get profilePhotoFromCamera;

  /// Edit profile: the camera or the gallery could not be opened
  ///
  /// In en, this message translates to:
  /// **'The photo could not be taken. Check that the app may use the camera and the photos.'**
  String get profilePhotoUnavailable;

  /// Edit profile: label of a field
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get profileFirstName;

  /// Edit profile: label of a field
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get profileLastName;

  /// Edit profile: label over the day, month and year lists
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get profileBirthday;

  /// Edit profile: shown in the day list while no day is chosen
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get profileBirthdayDay;

  /// Edit profile: shown in the month list while no month is chosen
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get profileBirthdayMonth;

  /// Edit profile: shown in the year list while no year is chosen
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get profileBirthdayYear;

  /// Edit profile: label of the city list
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get profileCity;

  /// Edit profile: label over the two choices
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGender;

  /// Edit profile: a gender
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get profileGenderMale;

  /// Edit profile: a gender
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get profileGenderFemale;
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
