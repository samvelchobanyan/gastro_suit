import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/di/repositories.dart';
import '../entities/menu.dart';
import 'server_config_state.dart';

/// The menu of one branch. Knows nothing about the active branch: whoever
/// shows a menu asks for it by the branch's id.
class BranchMenuController extends AsyncNotifier<Menu> {
  BranchMenuController(this.branchId);

  final String branchId;

  @override
  Future<Menu> build() async {
    final language = await ref.watch(contentLanguageProvider.future);
    return ref
        .read(menuRepositoryProvider)
        .getMenu(
          restaurantId: ref.read(appConfigProvider).restaurantId,
          branchId: branchId,
          language: language,
        );
  }
}

/// Menus by branch id: `menuProvider(branchId)`.
///
/// Each branch asked for gets its own menu with its own loading and error.
/// A menu is loaded when first asked for, shared by everyone who asks for
/// the same branch, and dropped when nobody watches it any more. So the
/// active branch's menu lives while the Order tab does, and the menu of a
/// branch the user is browsing lives while its screen is open.
final menuProvider = AsyncNotifierProvider.autoDispose
    .family<BranchMenuController, Menu, String>(BranchMenuController.new);
