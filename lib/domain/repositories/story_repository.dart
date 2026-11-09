import '../../core/locale/content_language.dart';
import '../entities/story.dart';

/// Home's stories. Throws only `AppException`.
abstract interface class StoryRepository {
  /// The stories on show now, in the server's order.
  Future<List<Story>> getStories(ContentLanguage language);
}
