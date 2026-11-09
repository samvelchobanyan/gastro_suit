/// Which language to take from the API's translated texts (`{en, ru, hy}`).
///
/// [current] is the app's language; [fallback] is the instance's default
/// language from `GET /config`, used when a text has no translation in
/// [current].
class ContentLanguage {
  const ContentLanguage({required this.current, required this.fallback});

  final String current;
  final String fallback;
}
