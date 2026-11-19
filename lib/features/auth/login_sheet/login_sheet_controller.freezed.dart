// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_sheet_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginSheetState {

 LoginStep get step;/// The digits of the number after the country code.
 String get phone;/// A request is on its way: a code is being sent or checked.
 bool get busy;/// A code was just sent again; goes back to false in a moment.
 bool get resent;/// Why the last request was refused; gone once the user edits.
 AppException? get error;
/// Create a copy of LoginSheetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginSheetStateCopyWith<LoginSheetState> get copyWith => _$LoginSheetStateCopyWithImpl<LoginSheetState>(this as LoginSheetState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginSheetState&&(identical(other.step, step) || other.step == step)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.resent, resent) || other.resent == resent)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,step,phone,busy,resent,error);

@override
String toString() {
  return 'LoginSheetState(step: $step, phone: $phone, busy: $busy, resent: $resent, error: $error)';
}


}

/// @nodoc
abstract mixin class $LoginSheetStateCopyWith<$Res>  {
  factory $LoginSheetStateCopyWith(LoginSheetState value, $Res Function(LoginSheetState) _then) = _$LoginSheetStateCopyWithImpl;
@useResult
$Res call({
 LoginStep step, String phone, bool busy, bool resent, AppException? error
});




}
/// @nodoc
class _$LoginSheetStateCopyWithImpl<$Res>
    implements $LoginSheetStateCopyWith<$Res> {
  _$LoginSheetStateCopyWithImpl(this._self, this._then);

  final LoginSheetState _self;
  final $Res Function(LoginSheetState) _then;

/// Create a copy of LoginSheetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? phone = null,Object? busy = null,Object? resent = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as LoginStep,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,resent: null == resent ? _self.resent : resent // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginSheetState].
extension LoginSheetStatePatterns on LoginSheetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginSheetState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginSheetState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginSheetState value)  $default,){
final _that = this;
switch (_that) {
case _LoginSheetState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginSheetState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginSheetState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoginStep step,  String phone,  bool busy,  bool resent,  AppException? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginSheetState() when $default != null:
return $default(_that.step,_that.phone,_that.busy,_that.resent,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoginStep step,  String phone,  bool busy,  bool resent,  AppException? error)  $default,) {final _that = this;
switch (_that) {
case _LoginSheetState():
return $default(_that.step,_that.phone,_that.busy,_that.resent,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoginStep step,  String phone,  bool busy,  bool resent,  AppException? error)?  $default,) {final _that = this;
switch (_that) {
case _LoginSheetState() when $default != null:
return $default(_that.step,_that.phone,_that.busy,_that.resent,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _LoginSheetState implements LoginSheetState {
  const _LoginSheetState({this.step = LoginStep.phone, this.phone = '', this.busy = false, this.resent = false, this.error});
  

@override@JsonKey() final  LoginStep step;
/// The digits of the number after the country code.
@override@JsonKey() final  String phone;
/// A request is on its way: a code is being sent or checked.
@override@JsonKey() final  bool busy;
/// A code was just sent again; goes back to false in a moment.
@override@JsonKey() final  bool resent;
/// Why the last request was refused; gone once the user edits.
@override final  AppException? error;

/// Create a copy of LoginSheetState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginSheetStateCopyWith<_LoginSheetState> get copyWith => __$LoginSheetStateCopyWithImpl<_LoginSheetState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginSheetState&&(identical(other.step, step) || other.step == step)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.resent, resent) || other.resent == resent)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,step,phone,busy,resent,error);

@override
String toString() {
  return 'LoginSheetState(step: $step, phone: $phone, busy: $busy, resent: $resent, error: $error)';
}


}

/// @nodoc
abstract mixin class _$LoginSheetStateCopyWith<$Res> implements $LoginSheetStateCopyWith<$Res> {
  factory _$LoginSheetStateCopyWith(_LoginSheetState value, $Res Function(_LoginSheetState) _then) = __$LoginSheetStateCopyWithImpl;
@override @useResult
$Res call({
 LoginStep step, String phone, bool busy, bool resent, AppException? error
});




}
/// @nodoc
class __$LoginSheetStateCopyWithImpl<$Res>
    implements _$LoginSheetStateCopyWith<$Res> {
  __$LoginSheetStateCopyWithImpl(this._self, this._then);

  final _LoginSheetState _self;
  final $Res Function(_LoginSheetState) _then;

/// Create a copy of LoginSheetState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? phone = null,Object? busy = null,Object? resent = null,Object? error = freezed,}) {
  return _then(_LoginSheetState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as LoginStep,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,resent: null == resent ? _self.resent : resent // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}


}

// dart format on
