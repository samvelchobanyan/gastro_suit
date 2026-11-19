import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/repositories.dart';
import '../../../core/network/app_exception.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/state/server_config_state.dart';

/// What the history shows of the user's orders so far.
class OrderHistory {
  const OrderHistory({
    required this.orders,
    required this.hasMore,
    this.moreFailed = false,
  });

  /// The orders of the pages read so far, newest first. Orders that were
  /// never paid for are left out (`Order.isInHistory`).
  final List<Order> orders;

  /// Whether the server holds pages not read yet.
  final bool hasMore;

  /// Whether the last try to read the next page failed.
  final bool moreFailed;
}

/// The user's orders for the History screen, read a page at a time: the
/// first page on opening, the next ones as the list is scrolled to its end.
class OrderHistoryController extends AsyncNotifier<OrderHistory> {
  /// The last page read.
  var _page = 1;
  var _loadingMore = false;

  @override
  Future<OrderHistory> build() async {
    _page = 1;
    _loadingMore = false;
    final language = await ref.watch(contentLanguageProvider.future);
    final page = await ref
        .read(orderRepositoryProvider)
        .getOrders(page: 1, language: language);
    return OrderHistory(orders: _shown(page.orders), hasMore: page.hasMore);
  }

  /// Reads on until the list has grown or the pages have ended: a page may
  /// hold only orders that are not shown. Does nothing while a page is on
  /// its way, or when there is none left. A failed read keeps the list and
  /// is told in `OrderHistory.moreFailed`; calling again retries.
  Future<void> loadMore() async {
    final history = state.value;
    if (history == null || !history.hasMore || _loadingMore) return;
    _loadingMore = true;
    try {
      final language = await ref.read(contentLanguageProvider.future);
      var added = const <Order>[];
      var hasMore = true;
      while (added.isEmpty && hasMore) {
        final page = await ref
            .read(orderRepositoryProvider)
            .getOrders(page: _page + 1, language: language);
        if (!ref.mounted) return;
        _page++;
        added = _shown(page.orders);
        hasMore = page.hasMore;
      }
      state = AsyncData(
        OrderHistory(orders: [...history.orders, ...added], hasMore: hasMore),
      );
    } on AppException {
      if (!ref.mounted) return;
      state = AsyncData(
        OrderHistory(orders: history.orders, hasMore: true, moreFailed: true),
      );
    } finally {
      _loadingMore = false;
    }
  }

  static List<Order> _shown(List<Order> orders) => [
    for (final order in orders)
      if (order.isInHistory) order,
  ];
}

final orderHistoryProvider =
    AsyncNotifierProvider.autoDispose<OrderHistoryController, OrderHistory>(
      OrderHistoryController.new,
    );
