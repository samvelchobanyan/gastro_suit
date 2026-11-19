// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileDraft {

 String get name; String get surname; int? get day; int? get month; int? get year; String? get city; Gender? get gender;
/// Create a copy of ProfileDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileDraftCopyWith<ProfileDraft> get copyWith => _$ProfileDraftCopyWithImpl<ProfileDraft>(this as ProfileDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.surname, surname) || other.surname == surname)&&(identical(other.day, day) || other.day == day)&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.city, city) || other.city == city)&&(identical(other.gender, gender) || other.gender == gender));
}


@override
int get hashCode => Object.hash(runtimeType,name,surname,day,month,year,city,gender);

@override
String toString() {
  return 'ProfileDraft(name: $name, surname: $surname, day: $day, month: $month, year: $year, city: $city, gender: $gender)';
}


}

/// @nodoc
abstract mixin class $ProfileDraftCopyWith<$Res>  {
  factory $ProfileDraftCopyWith(ProfileDraft value, $Res Function(ProfileDraft) _then) = _$ProfileDraftCopyWithImpl;
@useResult
$Res call({
 String name, String surname, int? day, int? month, int? year, String? city, Gender? gender
});




}
/// @nodoc
class _$ProfileDraftCopyWithImpl<$Res>
    implements $ProfileDraftCopyWith<$Res> {
  _$ProfileDraftCopyWithImpl(this._self, this._then);

  final ProfileDraft _self;
  final $Res Function(ProfileDraft) _then;

/// Create a copy of ProfileDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? surname = null,Object? day = freezed,Object? month = freezed,Object? year = freezed,Object? city = freezed,Object? gender = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,surname: null == surname ? _self.surname : surname // ignore: cast_nullable_to_non_nullable
as String,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int?,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileDraft].
extension ProfileDraftPatterns on ProfileDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileDraft value)  $default,){
final _that = this;
switch (_that) {
case _ProfileDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String surname,  int? day,  int? month,  int? year,  String? city,  Gender? gender)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileDraft() when $default != null:
return $default(_that.name,_that.surname,_that.day,_that.month,_that.year,_that.city,_that.gender);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String surname,  int? day,  int? month,  int? year,  String? city,  Gender? gender)  $default,) {final _that = this;
switch (_that) {
case _ProfileDraft():
return $default(_that.name,_that.surname,_that.day,_that.month,_that.year,_that.city,_that.gender);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String surname,  int? day,  int? month,  int? year,  String? city,  Gender? gender)?  $default,) {final _that = this;
switch (_that) {
case _ProfileDraft() when $default != null:
return $default(_that.name,_that.surname,_that.day,_that.month,_that.year,_that.city,_that.gender);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileDraft extends ProfileDraft {
  const _ProfileDraft({this.name = '', this.surname = '', this.day, this.month, this.year, this.city, this.gender}): super._();
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String surname;
@override final  int? day;
@override final  int? month;
@override final  int? year;
@override final  String? city;
@override final  Gender? gender;

/// Create a copy of ProfileDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileDraftCopyWith<_ProfileDraft> get copyWith => __$ProfileDraftCopyWithImpl<_ProfileDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.surname, surname) || other.surname == surname)&&(identical(other.day, day) || other.day == day)&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.city, city) || other.city == city)&&(identical(other.gender, gender) || other.gender == gender));
}


@override
int get hashCode => Object.hash(runtimeType,name,surname,day,month,year,city,gender);

@override
String toString() {
  return 'ProfileDraft(name: $name, surname: $surname, day: $day, month: $month, year: $year, city: $city, gender: $gender)';
}


}

/// @nodoc
abstract mixin class _$ProfileDraftCopyWith<$Res> implements $ProfileDraftCopyWith<$Res> {
  factory _$ProfileDraftCopyWith(_ProfileDraft value, $Res Function(_ProfileDraft) _then) = __$ProfileDraftCopyWithImpl;
@override @useResult
$Res call({
 String name, String surname, int? day, int? month, int? year, String? city, Gender? gender
});




}
/// @nodoc
class __$ProfileDraftCopyWithImpl<$Res>
    implements _$ProfileDraftCopyWith<$Res> {
  __$ProfileDraftCopyWithImpl(this._self, this._then);

  final _ProfileDraft _self;
  final $Res Function(_ProfileDraft) _then;

/// Create a copy of ProfileDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? surname = null,Object? day = freezed,Object? month = freezed,Object? year = freezed,Object? city = freezed,Object? gender = freezed,}) {
  return _then(_ProfileDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,surname: null == surname ? _self.surname : surname // ignore: cast_nullable_to_non_nullable
as String,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int?,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,
  ));
}


}

/// @nodoc
mixin _$EditProfileState {

 ProfileDraft get draft;/// The draft the form was opened with: what the server holds.
 ProfileDraft get saved; bool get saving;/// Why the last save was refused.
 AppException? get error;
/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileStateCopyWith<EditProfileState> get copyWith => _$EditProfileStateCopyWithImpl<EditProfileState>(this as EditProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileState&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,draft,saved,saving,error);

@override
String toString() {
  return 'EditProfileState(draft: $draft, saved: $saved, saving: $saving, error: $error)';
}


}

/// @nodoc
abstract mixin class $EditProfileStateCopyWith<$Res>  {
  factory $EditProfileStateCopyWith(EditProfileState value, $Res Function(EditProfileState) _then) = _$EditProfileStateCopyWithImpl;
@useResult
$Res call({
 ProfileDraft draft, ProfileDraft saved, bool saving, AppException? error
});


$ProfileDraftCopyWith<$Res> get draft;$ProfileDraftCopyWith<$Res> get saved;

}
/// @nodoc
class _$EditProfileStateCopyWithImpl<$Res>
    implements $EditProfileStateCopyWith<$Res> {
  _$EditProfileStateCopyWithImpl(this._self, this._then);

  final EditProfileState _self;
  final $Res Function(EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? draft = null,Object? saved = null,Object? saving = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ProfileDraft,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as ProfileDraft,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}
/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileDraftCopyWith<$Res> get draft {
  
  return $ProfileDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileDraftCopyWith<$Res> get saved {
  
  return $ProfileDraftCopyWith<$Res>(_self.saved, (value) {
    return _then(_self.copyWith(saved: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditProfileState].
extension EditProfileStatePatterns on EditProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditProfileState value)  $default,){
final _that = this;
switch (_that) {
case _EditProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileDraft draft,  ProfileDraft saved,  bool saving,  AppException? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
return $default(_that.draft,_that.saved,_that.saving,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileDraft draft,  ProfileDraft saved,  bool saving,  AppException? error)  $default,) {final _that = this;
switch (_that) {
case _EditProfileState():
return $default(_that.draft,_that.saved,_that.saving,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileDraft draft,  ProfileDraft saved,  bool saving,  AppException? error)?  $default,) {final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
return $default(_that.draft,_that.saved,_that.saving,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _EditProfileState extends EditProfileState {
  const _EditProfileState({required this.draft, required this.saved, this.saving = false, this.error}): super._();
  

@override final  ProfileDraft draft;
/// The draft the form was opened with: what the server holds.
@override final  ProfileDraft saved;
@override@JsonKey() final  bool saving;
/// Why the last save was refused.
@override final  AppException? error;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditProfileStateCopyWith<_EditProfileState> get copyWith => __$EditProfileStateCopyWithImpl<_EditProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditProfileState&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,draft,saved,saving,error);

@override
String toString() {
  return 'EditProfileState(draft: $draft, saved: $saved, saving: $saving, error: $error)';
}


}

/// @nodoc
abstract mixin class _$EditProfileStateCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory _$EditProfileStateCopyWith(_EditProfileState value, $Res Function(_EditProfileState) _then) = __$EditProfileStateCopyWithImpl;
@override @useResult
$Res call({
 ProfileDraft draft, ProfileDraft saved, bool saving, AppException? error
});


@override $ProfileDraftCopyWith<$Res> get draft;@override $ProfileDraftCopyWith<$Res> get saved;

}
/// @nodoc
class __$EditProfileStateCopyWithImpl<$Res>
    implements _$EditProfileStateCopyWith<$Res> {
  __$EditProfileStateCopyWithImpl(this._self, this._then);

  final _EditProfileState _self;
  final $Res Function(_EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? draft = null,Object? saved = null,Object? saving = null,Object? error = freezed,}) {
  return _then(_EditProfileState(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as ProfileDraft,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as ProfileDraft,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileDraftCopyWith<$Res> get draft {
  
  return $ProfileDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileDraftCopyWith<$Res> get saved {
  
  return $ProfileDraftCopyWith<$Res>(_self.saved, (value) {
    return _then(_self.copyWith(saved: value));
  });
}
}

// dart format on
