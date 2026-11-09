// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_banner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PromoBanner {

 String get id; String get imageUrl;/// The picture's text for accessibility; not shown.
 String? get title;/// No link — the banner is not tappable.
 AppLink? get link;
/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoBannerCopyWith<PromoBanner> get copyWith => _$PromoBannerCopyWithImpl<PromoBanner>(this as PromoBanner, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoBanner&&(identical(other.id, id) || other.id == id)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.title, title) || other.title == title)&&(identical(other.link, link) || other.link == link));
}


@override
int get hashCode => Object.hash(runtimeType,id,imageUrl,title,link);

@override
String toString() {
  return 'PromoBanner(id: $id, imageUrl: $imageUrl, title: $title, link: $link)';
}


}

/// @nodoc
abstract mixin class $PromoBannerCopyWith<$Res>  {
  factory $PromoBannerCopyWith(PromoBanner value, $Res Function(PromoBanner) _then) = _$PromoBannerCopyWithImpl;
@useResult
$Res call({
 String id, String imageUrl, String? title, AppLink? link
});


$AppLinkCopyWith<$Res>? get link;

}
/// @nodoc
class _$PromoBannerCopyWithImpl<$Res>
    implements $PromoBannerCopyWith<$Res> {
  _$PromoBannerCopyWithImpl(this._self, this._then);

  final PromoBanner _self;
  final $Res Function(PromoBanner) _then;

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? imageUrl = null,Object? title = freezed,Object? link = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as AppLink?,
  ));
}
/// Create a copy of PromoBanner
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


/// Adds pattern-matching-related methods to [PromoBanner].
extension PromoBannerPatterns on PromoBanner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoBanner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoBanner value)  $default,){
final _that = this;
switch (_that) {
case _PromoBanner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoBanner value)?  $default,){
final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String imageUrl,  String? title,  AppLink? link)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
return $default(_that.id,_that.imageUrl,_that.title,_that.link);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String imageUrl,  String? title,  AppLink? link)  $default,) {final _that = this;
switch (_that) {
case _PromoBanner():
return $default(_that.id,_that.imageUrl,_that.title,_that.link);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String imageUrl,  String? title,  AppLink? link)?  $default,) {final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
return $default(_that.id,_that.imageUrl,_that.title,_that.link);case _:
  return null;

}
}

}

/// @nodoc


class _PromoBanner implements PromoBanner {
  const _PromoBanner({required this.id, required this.imageUrl, this.title, this.link});
  

@override final  String id;
@override final  String imageUrl;
/// The picture's text for accessibility; not shown.
@override final  String? title;
/// No link — the banner is not tappable.
@override final  AppLink? link;

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoBannerCopyWith<_PromoBanner> get copyWith => __$PromoBannerCopyWithImpl<_PromoBanner>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoBanner&&(identical(other.id, id) || other.id == id)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.title, title) || other.title == title)&&(identical(other.link, link) || other.link == link));
}


@override
int get hashCode => Object.hash(runtimeType,id,imageUrl,title,link);

@override
String toString() {
  return 'PromoBanner(id: $id, imageUrl: $imageUrl, title: $title, link: $link)';
}


}

/// @nodoc
abstract mixin class _$PromoBannerCopyWith<$Res> implements $PromoBannerCopyWith<$Res> {
  factory _$PromoBannerCopyWith(_PromoBanner value, $Res Function(_PromoBanner) _then) = __$PromoBannerCopyWithImpl;
@override @useResult
$Res call({
 String id, String imageUrl, String? title, AppLink? link
});


@override $AppLinkCopyWith<$Res>? get link;

}
/// @nodoc
class __$PromoBannerCopyWithImpl<$Res>
    implements _$PromoBannerCopyWith<$Res> {
  __$PromoBannerCopyWithImpl(this._self, this._then);

  final _PromoBanner _self;
  final $Res Function(_PromoBanner) _then;

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? imageUrl = null,Object? title = freezed,Object? link = freezed,}) {
  return _then(_PromoBanner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as AppLink?,
  ));
}

/// Create a copy of PromoBanner
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
