/// Route paths. Navigation goes through these, never through string literals.
abstract final class AppRoutes {
  static const home = '/home';
  static const order = '/order';
  static const gifts = '/gifts';
  static const profile = '/profile';

  static const login = '/login';

  /// One branch's screen; open it with [branchOf].
  static const branch = '/branch/:id';

  static String branchOf(String branchId) => '/branch/$branchId';
}
