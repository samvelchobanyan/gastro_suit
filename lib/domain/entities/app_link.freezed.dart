// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppLink {

 AppLinkType get type;/// The product's or category's id, or the web address.
 String get target;
/// Create a copy of AppLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppLinkCopyWith<AppLink> get copyWith => _$AppLinkCopyWithImpl<AppLink>(this as AppLink, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLink&&(identical(other.type, type) || other.type == type)&&(identical(other.target, target) || other.target == target));
}


@override
int get hashCode => Object.hash(runtimeType,type,target);

@override
String toString() {
  return 'AppLink(type: $type, target: $target)';
}


}

/// @nodoc
abstract mixin class $AppLinkCopyWith<$Res>  {
  factory $AppLinkCopyWith(AppLink value, $Res Function(AppLink) _then) = _$AppLinkCopyWithImpl;
@useResult
$Res call({
 AppLinkType type, String target
});




}
/// @nodoc
class _$AppLinkCopyWithImpl<$Res>
    implements $AppLinkCopyWith<$Res> {
  _$AppLinkCopyWithImpl(this._self, this._then);

  final AppLink _self;
  final $Res Function(AppLink) _then;

/// Create a copy of AppLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? target = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AppLinkType,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppLink].
extension AppLinkPatterns on AppLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppLink value)  $default,){
final _that = this;
switch (_that) {
case _AppLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppLink value)?  $default,){
final _that = this;
switch (_that) {
case _AppLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppLinkType type,  String target)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppLink() when $default != null:
return $default(_that.type,_that.target);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppLinkType type,  String target)  $default,) {final _that = this;
switch (_that) {
case _AppLink():
return $default(_that.type,_that.target);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppLinkType type,  String target)?  $default,) {final _that = this;
switch (_that) {
case _AppLink() when $default != null:
return $default(_that.type,_that.target);case _:
  return null;

}
}

}

/// @nodoc


class _AppLink implements AppLink {
  const _AppLink({required this.type, required this.target});
  

@override final  AppLinkType type;
/// The product's or category's id, or the web address.
@override final  String target;

/// Create a copy of AppLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppLinkCopyWith<_AppLink> get copyWith => __$AppLinkCopyWithImpl<_AppLink>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppLink&&(identical(other.type, type) || other.type == type)&&(identical(other.target, target) || other.target == target));
}


@override
int get hashCode => Object.hash(runtimeType,type,target);

@override
String toString() {
  return 'AppLink(type: $type, target: $target)';
}


}

/// @nodoc
abstract mixin class _$AppLinkCopyWith<$Res> implements $AppLinkCopyWith<$Res> {
  factory _$AppLinkCopyWith(_AppLink value, $Res Function(_AppLink) _then) = __$AppLinkCopyWithImpl;
@override @useResult
$Res call({
 AppLinkType type, String target
});




}
/// @nodoc
class __$AppLinkCopyWithImpl<$Res>
    implements _$AppLinkCopyWith<$Res> {
  __$AppLinkCopyWithImpl(this._self, this._then);

  final _AppLink _self;
  final $Res Function(_AppLink) _then;

/// Create a copy of AppLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? target = null,}) {
  return _then(_AppLink(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AppLinkType,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
