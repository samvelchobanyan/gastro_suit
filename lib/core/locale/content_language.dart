/// Which language to take from the API's translated texts (`{en, ru, hy}`).
///
/// [current] is the app's language; [fallback] is the instance's default
/// language from `GET /config`, used when a text has no translation in
/// [current]. It is null when `/config` failed to load: content is then
/// mapped without that step.
class ContentLanguage {
  const ContentLanguage({required this.current, this.fallback});

  final String current;
  final String? fallback;
}
