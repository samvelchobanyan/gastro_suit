import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_status.dart';
import '../../../core/di/repositories.dart';
import '../../../domain/entities/story.dart';
import '../../../domain/state/server_config_state.dart';

/// Home's stories.
class StoriesController extends AsyncNotifier<List<Story>> {
  @override
  Future<List<Story>> build() async {
    // Which stories are seen depends on who is signed in: reload on sign-in
    // and sign-out.
    ref.watch(authStatusProvider);
    final language = await ref.watch(contentLanguageProvider.future);
    return ref.read(storyRepositoryProvider).getStories(language);
  }
}

final storiesControllerProvider =
    AsyncNotifierProvider<StoriesController, List<Story>>(
      StoriesController.new,
    );
