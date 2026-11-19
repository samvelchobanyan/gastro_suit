import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/repositories.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/state/server_config_state.dart';

/// One order by its id, for its details screen: `orderProvider(orderId)`.
/// Read from the server on opening, so its status is the current one.
final orderProvider = FutureProvider.autoDispose.family<Order, String>((
  ref,
  orderId,
) async {
  final language = await ref.watch(contentLanguageProvider.future);
  return ref.read(orderRepositoryProvider).getOrder(orderId, language);
});
