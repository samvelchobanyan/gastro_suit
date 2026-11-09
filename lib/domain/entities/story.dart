import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_link.dart';

part 'story.freezed.dart';

/// A short sequence of pictures shown on Home (DOMAIN_SPEC §6).
@freezed
abstract class Story with _$Story {
  const factory Story({
    required String id,
    String? title,
    required String coverUrl,

    /// The pictures it plays, in order; at least one.
    required List<String> slides,

    /// Its button; none without a link.
    AppLink? link,

    /// Seen since it last changed. Known only for a signed-in user; a guest
    /// sees every story as new.
    required bool isSeen,
  }) = _Story;
}
