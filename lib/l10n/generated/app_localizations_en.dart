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
  String get loginTitle => 'Log in';

  @override
  String get loginPhoneHint =>
      'Enter your phone number and we\'ll send you a verification code.';

  @override
  String get loginClearPhone => 'Clear phone number';

  @override
  String get loginSendCode => 'Send code';

  @override
  String get loginCodeTitle => 'Enter code';

  @override
  String loginCodeHint(int count, String phone) {
    return 'Enter the $count digit code sent to $phone.';
  }

  @override
  String get loginCodeField => 'Verification code';

  @override
  String get loginResend => 'Resend code';

  @override
  String get loginResent => 'Sent';

  @override
  String get loginChangeNumber => 'Change number';

  @override
  String get loginVerify => 'Verify';

  @override
  String get signIn => 'Sign in';

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
  String get walletTopUpTitle => 'Top up wallet';

  @override
  String get walletTopUpAmountHint => 'Enter amount';

  @override
  String walletTopUpLimits(String min, String max) {
    return 'From $min to $max';
  }

  @override
  String get walletTopUpUnavailable => 'Paying this way is not available yet';

  @override
  String walletTopUpSuccess(String amount) {
    return 'You have successfully topped up your wallet by $amount';
  }

  @override
  String get continueAction => 'Continue';

  @override
  String get productAnythingElse => 'Anything else?';

  @override
  String orderWithTotal(String total) {
    return 'Order · $total';
  }

  @override
  String get profileBankCards => 'Bank cards';

  @override
  String get profileHistory => 'History';

  @override
  String get profileHistorySubtitle => 'Your orders and transactions';

  @override
  String get profileFavorites => 'Favorite products';

  @override
  String profileFavoritesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0';
  }

  @override
  String get profilePush => 'Push notifications';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileDangerZone => 'Danger zone';

  @override
  String get profileLogout => 'Logout';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileDeleteTitle => 'Delete account?';

  @override
  String get profileDeleteMessage =>
      'Your account and everything in it will be deleted. This cannot be undone.';

  @override
  String get profileDeleteConfirm => 'Delete';

  @override
  String get profileTerms => 'Terms & conditions';

  @override
  String get profileAboutDeveloper => 'About developer';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get inviteTitle => 'Invite a friend';

  @override
  String get inviteDescription => 'and get loyalty points';

  @override
  String get inviteAction => 'Invite';

  @override
  String get historyTabOrders => 'Orders';

  @override
  String get historyTabTransactions => 'Transactions';

  @override
  String get historyOrdersEmpty => 'No orders yet';

  @override
  String get historyTransactionsEmpty => 'No transactions yet';

  @override
  String historyOrderNumber(String number) {
    return 'Order #$number';
  }

  @override
  String get transactionTopUp => 'Wallet top up';

  @override
  String get transactionSpend => 'Wallet payment';

  @override
  String get orderDetailsTitle => 'Order details';

  @override
  String get orderStatusCompleted => 'Completed';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get orderStatusAwaitingPayment => 'Awaiting payment';

  @override
  String get orderStatusPaymentFailed => 'Payment failed';

  @override
  String get orderDetailsDate => 'Order date';

  @override
  String get orderDetailsFulfilment => 'Fulfilment type';

  @override
  String get orderDetailsPickup => 'Pickup';

  @override
  String get orderDetailsPaymentMethod => 'Payment method';

  @override
  String get orderDetailsOnlinePayment => 'Online payment';

  @override
  String get orderDetailsPaymentStatus => 'Payment status';

  @override
  String get orderDetailsPaid => 'Paid';

  @override
  String get orderDetailsComment => 'Order comment';

  @override
  String get orderDetailsYourOrder => 'Your order';

  @override
  String get orderDetailsSubtotal => 'Order subtotal';

  @override
  String get orderDetailsDiscount => 'Discount';

  @override
  String get orderDetailsTotal => 'Total';

  @override
  String get favoriteAdd => 'Add to favorites';

  @override
  String get favoriteRemove => 'Remove from favorites';

  @override
  String get buyAgain => 'Buy again';

  @override
  String get favorites => 'Favorites';

  @override
  String get favoritesEmpty => 'No favorite products yet';

  @override
  String get favoritesNoneAtBranch =>
      'None of your favorite products is sold at this branch';

  @override
  String get save => 'Save';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profilePhotoFromGallery => 'Choose from gallery';

  @override
  String get profilePhotoFromCamera => 'Take a photo';

  @override
  String get profilePhotoUnavailable =>
      'The photo could not be taken. Check that the app may use the camera and the photos.';

  @override
  String get profileFirstName => 'First name';

  @override
  String get profileLastName => 'Last name';

  @override
  String get profileBirthday => 'Birthday';

  @override
  String get profileBirthdayDay => 'Day';

  @override
  String get profileBirthdayMonth => 'Month';

  @override
  String get profileBirthdayYear => 'Year';

  @override
  String get profileCity => 'City';

  @override
  String get profileGender => 'Gender';

  @override
  String get profileGenderMale => 'Male';

  @override
  String get profileGenderFemale => 'Female';
}
