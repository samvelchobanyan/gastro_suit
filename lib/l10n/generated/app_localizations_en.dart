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
  String get orderTabProducts => 'Products';

  @override
  String get orderTabBranches => 'Branches';

  @override
  String get tabGifts => 'Gifts';

  @override
  String get tabProfile => 'Profile';

  @override
  String get chooseBranch => 'Choose branch';

  @override
  String get choose => 'Choose';

  @override
  String get otherDistrict => 'Other';

  @override
  String get notifications => 'Notifications';

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

  @override
  String get retry => 'Try again';

  @override
  String get nearestBranches => 'Nearest branches';

  @override
  String get branchOpen => 'Open';

  @override
  String get branchClosed => 'Closed';

  @override
  String get branchClosedToday => 'Closed today';

  @override
  String distanceKm(String km) {
    return '$km km';
  }

  @override
  String get featuredProducts => 'Featured products';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuEmpty => 'The menu is empty';

  @override
  String checkoutWithTotal(String total) {
    return 'Checkout · $total';
  }

  @override
  String get addToCart => 'Add to cart';

  @override
  String get quantityDecrease => 'Decrease quantity';

  @override
  String get quantityIncrease => 'Increase quantity';

  @override
  String get back => 'Back';

  @override
  String get rateBranch => 'Rate the branch';

  @override
  String get showOnMap => 'Show on map';

  @override
  String get leaveFeedback => 'Leave a feedback';

  @override
  String get feedbackHint => 'Tell us about your visit';

  @override
  String get send => 'Send';

  @override
  String ratingStar(int star) {
    return '$star of 5';
  }

  @override
  String addWithTotal(String total) {
    return 'Add · $total';
  }

  @override
  String saveWithTotal(String total) {
    return 'Save · $total';
  }

  @override
  String portionGrams(String amount) {
    return '$amount g';
  }

  @override
  String portionKilograms(String amount) {
    return '$amount kg';
  }

  @override
  String portionMilliliters(String amount) {
    return '$amount ml';
  }

  @override
  String portionLiters(String amount) {
    return '$amount l';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get cartReplaceTitle => 'Clear the cart?';

  @override
  String get cartReplaceMessage =>
      'The cart holds products of one branch only. Changing the branch will clear it.';

  @override
  String get cartReplaceConfirm => 'Clear';

  @override
  String get cartTitle => 'Basket';

  @override
  String get cartOpen => 'Open the basket';

  @override
  String get cartBarBranch => 'Branch';

  @override
  String get cartSectionBranch => 'Location';

  @override
  String get cartSectionTime => 'Time';

  @override
  String cartSectionOrder(int count) {
    return 'Your order ($count)';
  }

  @override
  String get cartSectionTip => 'Tip';

  @override
  String get cartEmpty => 'Your basket is empty';

  @override
  String get cartAddProducts => 'Add products';

  @override
  String get cartLineEdit => 'Change the choice';

  @override
  String get cartLineRemove => 'Remove from the basket';

  @override
  String get cartLineUnavailable => 'Not available at this branch now';

  @override
  String get cartTimeAsap => 'ASAP';

  @override
  String get cartTipNone => 'No tip';

  @override
  String get cartTipOther => 'Other';

  @override
  String get cartTipHint => 'Enter tip amount';

  @override
  String get cartSectionPayment => 'Payment method';

  @override
  String get paymentMethodsTitle => 'Choose payment method';

  @override
  String paymentCard(String digits) {
    return 'Card •••• $digits';
  }

  @override
  String get paymentNewCard => 'New card';

  @override
  String get orderSuccessTitle => 'Your order has been successfully placed!';

  @override
  String get orderSuccessBranch => 'Pickup location';

  @override
  String get orderSuccessTime => 'Pickup time';

  @override
  String get orderTrack => 'Track order';

  @override
  String get orderStatusTitle => 'Order status';

  @override
  String orderStatusPickup(String time) {
    return 'Pickup · $time';
  }

  @override
  String orderStatusNumber(String number) {
    return 'No. $number';
  }

  @override
  String get orderStepPlaced => 'Placed';

  @override
  String get orderStepAccepted => 'Accepted';

  @override
  String get orderStepPreparing => 'In process';

  @override
  String get orderStepReady => 'Ready';

  @override
  String get loyaltyPointsLabel => 'Loyalty points';

  @override
  String get loyaltyShowCard => 'Show loyalty card';

  @override
  String get loyaltyScanHint => 'Scan at checkout to earn points';

  @override
  String get loyaltyQrLabel => 'Loyalty QR code';

  @override
  String get loyaltyBalanceLabel => 'Available balance';

  @override
  String loyaltyPoints(String points) {
    return '$points pts';
  }

  @override
  String get walletBalanceTitle => 'Wallet balance';

  @override
  String get walletTopUp => 'Top up';

  @override
  String get walletTotal => 'Total balance';

  @override
  String get walletOwnTopUp => 'Top-up balance';

  @override
  String get walletNoExpiry => 'No expiry · use anytime';

  @override
  String get walletGifts => 'From gift cards';

  @override
  String walletGiftsTotal(String amount) {
    return '$amount total';
  }

  @override
  String get walletExpiring => 'Expiring balance';

  @override
  String walletExpires(String date) {
    return 'Expires $date';
  }

  @override
  String get productAnythingElse => 'Anything else?';

  @override
  String orderWithTotal(String total) {
    return 'Order · $total';
  }
}
