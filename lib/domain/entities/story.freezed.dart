// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Story {

 String get id; String? get title; String get coverUrl;/// The pictures it plays, in order; at least one.
 List<String> get slides;/// Its button; none without a link.
 AppLink? get link;/// Seen since it last changed. Known only for a signed-in user; a guest
/// sees every story as new.
 bool get isSeen;
/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryCopyWith<Story> get copyWith => _$StoryCopyWithImpl<Story>(this as Story, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Story&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other.slides, slides)&&(identical(other.link, link) || other.link == link)&&(identical(other.isSeen, isSeen) || other.isSeen == isSeen));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,coverUrl,const DeepCollectionEquality().hash(slides),link,isSeen);

@override
String toString() {
  return 'Story(id: $id, title: $title, coverUrl: $coverUrl, slides: $slides, link: $link, isSeen: $isSeen)';
}


}

/// @nodoc
abstract mixin class $StoryCopyWith<$Res>  {
  factory $StoryCopyWith(Story value, $Res Function(Story) _then) = _$StoryCopyWithImpl;
@useResult
$Res call({
 String id, String? title, String coverUrl, List<String> slides, AppLink? link, bool isSeen
});


$AppLinkCopyWith<$Res>? get link;

}
/// @nodoc
class _$StoryCopyWithImpl<$Res>
    implements $StoryCopyWith<$Res> {
  _$StoryCopyWithImpl(this._self, this._then);

  final Story _self;
  final $Res Function(Story) _then;

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? coverUrl = null,Object? slides = null,Object? link = freezed,Object? isSeen = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: null == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String,slides: null == slides ? _self.slides : slides // ignore: cast_nullable_to_non_nullable
as List<String>,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as AppLink?,isSeen: null == isSeen ? _self.isSeen : isSeen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppLinkCopyWith<$Res>? get link {
    if (_self.link == null) {
    return null;
  }

  return $AppLinkCopyWith<$Res>(_self.link!, (value) {
    return _then(_self.copyWith(link: value));
  });
}
}


/// Adds pattern-matching-related methods to [Story].
extension StoryPatterns on Story {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Story value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Story() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Story value)  $default,){
final _that = this;
switch (_that) {
case _Story():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Story value)?  $default,){
final _that = this;
switch (_that) {
case _Story() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? title,  String coverUrl,  List<String> slides,  AppLink? link,  bool isSeen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Story() when $default != null:
return $default(_that.id,_that.title,_that.coverUrl,_that.slides,_that.link,_that.isSeen);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? title,  String coverUrl,  List<String> slides,  AppLink? link,  bool isSeen)  $default,) {final _that = this;
switch (_that) {
case _Story():
return $default(_that.id,_that.title,_that.coverUrl,_that.slides,_that.link,_that.isSeen);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? title,  String coverUrl,  List<String> slides,  AppLink? link,  bool isSeen)?  $default,) {final _that = this;
switch (_that) {
case _Story() when $default != null:
return $default(_that.id,_that.title,_that.coverUrl,_that.slides,_that.link,_that.isSeen);case _:
  return null;

}
}

}

/// @nodoc


class _Story implements Story {
  const _Story({required this.id, this.title, required this.coverUrl, required final  List<String> slides, this.link, required this.isSeen}): _slides = slides;
  

@override final  String id;
@override final  String? title;
@override final  String coverUrl;
/// The pictures it plays, in order; at least one.
 final  List<String> _slides;
/// The pictures it plays, in order; at least one.
@override List<String> get slides {
  if (_slides is EqualUnmodifiableListView) return _slides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slides);
}

/// Its button; none without a link.
@override final  AppLink? link;
/// Seen since it last changed. Known only for a signed-in user; a guest
/// sees every story as new.
@override final  bool isSeen;

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryCopyWith<_Story> get copyWith => __$StoryCopyWithImpl<_Story>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Story&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other._slides, _slides)&&(identical(other.link, link) || other.link == link)&&(identical(other.isSeen, isSeen) || other.isSeen == isSeen));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,coverUrl,const DeepCollectionEquality().hash(_slides),link,isSeen);

@override
String toString() {
  return 'Story(id: $id, title: $title, coverUrl: $coverUrl, slides: $slides, link: $link, isSeen: $isSeen)';
}


}

/// @nodoc
abstract mixin class _$StoryCopyWith<$Res> implements $StoryCopyWith<$Res> {
  factory _$StoryCopyWith(_Story value, $Res Function(_Story) _then) = __$StoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String? title, String coverUrl, List<String> slides, AppLink? link, bool isSeen
});


@override $AppLinkCopyWith<$Res>? get link;

}
/// @nodoc
class __$StoryCopyWithImpl<$Res>
    implements _$StoryCopyWith<$Res> {
  __$StoryCopyWithImpl(this._self, this._then);

  final _Story _self;
  final $Res Function(_Story) _then;

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? coverUrl = null,Object? slides = null,Object? link = freezed,Object? isSeen = null,}) {
  return _then(_Story(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: null == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String,slides: null == slides ? _self._slides : slides // ignore: cast_nullable_to_non_nullable
as List<String>,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as AppLink?,isSeen: null == isSeen ? _self.isSeen : isSeen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppLinkCopyWith<$Res>? get link {
    if (_self.link == null) {
    return null;
  }

  return $AppLinkCopyWith<$Res>(_self.link!, (value) {
    return _then(_self.copyWith(link: value));
  });
}
}

// dart format on
