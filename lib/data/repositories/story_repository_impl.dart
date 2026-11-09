import '../../core/locale/content_language.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../dto/json_list.dart';
import '../dto/story_dto.dart';

class StoryRepositoryImpl implements StoryRepository {
  StoryRepositoryImpl(this._api);

  final ApiClient _api;

  /// Sent with the token when there is one: the server then says which
  /// stories this user has seen.
  @override
  Future<List<Story>> getStories(ContentLanguage language) async {
    final json = await _api.get('/stories');
    return [
      for (final item in jsonObjectList(json))
        ?StoryDto.fromJson(item).toDomain(language),
    ];
  }
}
