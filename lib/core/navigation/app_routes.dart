/// Route paths. Navigation goes through these, never through string literals.
abstract final class AppRoutes {
  static const home = '/home';
  static const order = '/order';
  static const gifts = '/gifts';
  static const profile = '/profile';

  /// One branch's screen; open it with [branchOf].
  static const branch = '/branch/:id';

  static String branchOf(String branchId) => '/branch/$branchId';

  static const editProfile = '/profile/edit';
  static const history = '/history';
  static const favorites = '/favorites';

  /// One order in full; open it with [orderOf].
  static const orderDetails = '/orders/:id';

  static String orderOf(String orderId) => '/orders/$orderId';
}
