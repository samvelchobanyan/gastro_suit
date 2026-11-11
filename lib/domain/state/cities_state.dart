import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/di/repositories.dart';
import '../entities/city.dart';
import 'server_config_state.dart';

/// The cities the organisation's branches stand in, with their districts:
/// the city and district filters of the branch picker and the Order tab's
/// branch list.
class CitiesController extends AsyncNotifier<List<City>> {
  @override
  Future<List<City>> build() async {
    final language = await ref.watch(contentLanguageProvider.future);
    return ref
        .read(branchRepositoryProvider)
        .getCities(
          restaurantId: ref.read(appConfigProvider).restaurantId,
          language: language,
        );
  }
}

final citiesControllerProvider =
    AsyncNotifierProvider<CitiesController, List<City>>(CitiesController.new);
