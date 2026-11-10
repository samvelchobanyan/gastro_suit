import '../../core/locale/content_language.dart';

/// Picks one string from an API translation map (`{en: …, ru: …, hy: …}`):
/// the current language, then the instance's default language (if known), then
/// [internalName], then an empty string. An empty translation counts as
/// missing.
String localized(
  Map<String, String>? text,
  ContentLanguage language, {
  String? internalName,
}) {
  String? pick(String? value) =>
      value == null || value.trim().isEmpty ? null : value;

  return pick(text?[language.current]) ??
      pick(language.fallback == null ? null : text?[language.fallback]) ??
      pick(internalName) ??
      '';
}

/// Same as [localized], but null when there is no text at all: for optional
/// fields (a story title, a description).
String? localizedOrNull(
  Map<String, String>? text,
  ContentLanguage language, {
  String? internalName,
}) {
  final value = localized(text, language, internalName: internalName);
  return value.isEmpty ? null : value;
}

/// Reads a translation map from JSON; anything that is not a map of strings
/// becomes null rather than failing the whole response.
Map<String, String>? translationsFromJson(Object? json) {
  if (json is! Map) return null;
  return {
    for (final entry in json.entries)
      if (entry.key is String && entry.value is String)
        entry.key as String: entry.value as String,
  };
}
