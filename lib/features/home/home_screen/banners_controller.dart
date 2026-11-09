import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/repositories.dart';
import '../../../domain/entities/promo_banner.dart';
import '../../../domain/state/server_config_state.dart';

/// Home's promo banners.
class BannersController extends AsyncNotifier<List<PromoBanner>> {
  @override
  Future<List<PromoBanner>> build() async {
    final language = await ref.watch(contentLanguageProvider.future);
    return ref.read(promoBannerRepositoryProvider).getBanners(language);
  }
}

final bannersControllerProvider =
    AsyncNotifierProvider<BannersController, List<PromoBanner>>(
      BannersController.new,
    );
