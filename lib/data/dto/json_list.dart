import '../../core/network/app_exception.dart';

/// Reads a JSON array of objects: a response that is not an array fails as
/// an unreadable answer; an element that is not an object is skipped.
List<Map<String, dynamic>> jsonObjectList(Object? json) {
  if (json is! List) throw const AppException(AppExceptionKind.unknown);
  return json.whereType<Map<String, dynamic>>().toList();
}
