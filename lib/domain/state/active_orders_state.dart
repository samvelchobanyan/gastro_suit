import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_status.dart';
import '../../core/di/repositories.dart';
import '../entities/order.dart';
import 'server_config_state.dart';

/// The user's orders that are on their way: paid and not handed over yet,
/// newest first. Empty for a guest.
///
/// While there is such an order, the list is read again every
/// [refreshInterval], so that its status moves on screen without the user
/// asking. Read again by whoever places an order.
class ActiveOrdersController extends AsyncNotifier<List<Order>> {
  static const refreshInterval = Duration(seconds: 30);

  /// The steps an order on its way goes through, in order. An order in any
  /// other status (not paid, handed over, cancelled) is not on its way.
  static const steps = [
    OrderStatus.placed,
    OrderStatus.accepted,
    OrderStatus.preparing,
    OrderStatus.ready,
  ];

  /// Whether the last list read had an order in it. Kept between reads: a
  /// read that fails must not stop the following ones.
  var _hasActive = false;

  @override
  Future<List<Order>> build() async {
    if (ref.watch(authStatusProvider) != AuthStatus.signedIn) {
      _hasActive = false;
      return const [];
    }
    final language = await ref.watch(contentLanguageProvider.future);

    Timer? timer;
    ref.onDispose(() => timer?.cancel());
    try {
      final recent = await ref
          .read(orderRepositoryProvider)
          .getRecentOrders(language);
      final active = [
        for (final order in recent)
          if (steps.contains(order.status)) order,
      ];
      _hasActive = active.isNotEmpty;
      return active;
    } finally {
      if (_hasActive) timer = Timer(refreshInterval, ref.invalidateSelf);
    }
  }
}

final activeOrdersProvider =
    AsyncNotifierProvider<ActiveOrdersController, List<Order>>(
      ActiveOrdersController.new,
    );
