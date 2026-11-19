// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Profile {

 String get name; String get surname;/// Null for a user who registered by email.
 String? get phone; String? get email; String? get photoUrl;/// The day the user was born; the time of day means nothing.
 DateTime? get birthday;/// The city the user lives in, as the app saved it: the id of one of
/// the organisation's cities. May be a text the app does not know when
/// it was saved elsewhere.
 String? get city; Gender? get gender;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.name, name) || other.name == name)&&(identical(other.surname, surname) || other.surname == surname)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.city, city) || other.city == city)&&(identical(other.gender, gender) || other.gender == gender));
}


@override
int get hashCode => Object.hash(runtimeType,name,surname,phone,email,photoUrl,birthday,city,gender);

@override
String toString() {
  return 'Profile(name: $name, surname: $surname, phone: $phone, email: $email, photoUrl: $photoUrl, birthday: $birthday, city: $city, gender: $gender)';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String name, String surname, String? phone, String? email, String? photoUrl, DateTime? birthday, String? city, Gender? gender
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? surname = null,Object? phone = freezed,Object? email = freezed,Object? photoUrl = freezed,Object? birthday = freezed,Object? city = freezed,Object? gender = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,surname: null == surname ? _self.surname : surname // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,
  ));
}

}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String surname,  String? phone,  String? email,  String? photoUrl,  DateTime? birthday,  String? city,  Gender? gender)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.name,_that.surname,_that.phone,_that.email,_that.photoUrl,_that.birthday,_that.city,_that.gender);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String surname,  String? phone,  String? email,  String? photoUrl,  DateTime? birthday,  String? city,  Gender? gender)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.name,_that.surname,_that.phone,_that.email,_that.photoUrl,_that.birthday,_that.city,_that.gender);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String surname,  String? phone,  String? email,  String? photoUrl,  DateTime? birthday,  String? city,  Gender? gender)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.name,_that.surname,_that.phone,_that.email,_that.photoUrl,_that.birthday,_that.city,_that.gender);case _:
  return null;

}
}

}

/// @nodoc


class _Profile extends Profile {
  const _Profile({required this.name, required this.surname, this.phone, this.email, this.photoUrl, this.birthday, this.city, this.gender}): super._();
  

@override final  String name;
@override final  String surname;
/// Null for a user who registered by email.
@override final  String? phone;
@override final  String? email;
@override final  String? photoUrl;
/// The day the user was born; the time of day means nothing.
@override final  DateTime? birthday;
/// The city the user lives in, as the app saved it: the id of one of
/// the organisation's cities. May be a text the app does not know when
/// it was saved elsewhere.
@override final  String? city;
@override final  Gender? gender;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.name, name) || other.name == name)&&(identical(other.surname, surname) || other.surname == surname)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.city, city) || other.city == city)&&(identical(other.gender, gender) || other.gender == gender));
}


@override
int get hashCode => Object.hash(runtimeType,name,surname,phone,email,photoUrl,birthday,city,gender);

@override
String toString() {
  return 'Profile(name: $name, surname: $surname, phone: $phone, email: $email, photoUrl: $photoUrl, birthday: $birthday, city: $city, gender: $gender)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, String surname, String? phone, String? email, String? photoUrl, DateTime? birthday, String? city, Gender? gender
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? surname = null,Object? phone = freezed,Object? email = freezed,Object? photoUrl = freezed,Object? birthday = freezed,Object? city = freezed,Object? gender = freezed,}) {
  return _then(_Profile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,surname: null == surname ? _self.surname : surname // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,
  ));
}


}

// dart format on
