// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loyalty_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoyaltyCard {

 int get points;/// What the cashier scans; the QR code shows this number.
 String get number;/// The tier as the restaurant names it; null when it names none. Only a
/// name so far: the API gives a tier no percent.
 String? get tier;
/// Create a copy of LoyaltyCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoyaltyCardCopyWith<LoyaltyCard> get copyWith => _$LoyaltyCardCopyWithImpl<LoyaltyCard>(this as LoyaltyCard, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoyaltyCard&&(identical(other.points, points) || other.points == points)&&(identical(other.number, number) || other.number == number)&&(identical(other.tier, tier) || other.tier == tier));
}


@override
int get hashCode => Object.hash(runtimeType,points,number,tier);

@override
String toString() {
  return 'LoyaltyCard(points: $points, number: $number, tier: $tier)';
}


}

/// @nodoc
abstract mixin class $LoyaltyCardCopyWith<$Res>  {
  factory $LoyaltyCardCopyWith(LoyaltyCard value, $Res Function(LoyaltyCard) _then) = _$LoyaltyCardCopyWithImpl;
@useResult
$Res call({
 int points, String number, String? tier
});




}
/// @nodoc
class _$LoyaltyCardCopyWithImpl<$Res>
    implements $LoyaltyCardCopyWith<$Res> {
  _$LoyaltyCardCopyWithImpl(this._self, this._then);

  final LoyaltyCard _self;
  final $Res Function(LoyaltyCard) _then;

/// Create a copy of LoyaltyCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,Object? number = null,Object? tier = freezed,}) {
  return _then(_self.copyWith(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,tier: freezed == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoyaltyCard].
extension LoyaltyCardPatterns on LoyaltyCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoyaltyCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoyaltyCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoyaltyCard value)  $default,){
final _that = this;
switch (_that) {
case _LoyaltyCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoyaltyCard value)?  $default,){
final _that = this;
switch (_that) {
case _LoyaltyCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int points,  String number,  String? tier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoyaltyCard() when $default != null:
return $default(_that.points,_that.number,_that.tier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int points,  String number,  String? tier)  $default,) {final _that = this;
switch (_that) {
case _LoyaltyCard():
return $default(_that.points,_that.number,_that.tier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int points,  String number,  String? tier)?  $default,) {final _that = this;
switch (_that) {
case _LoyaltyCard() when $default != null:
return $default(_that.points,_that.number,_that.tier);case _:
  return null;

}
}

}

/// @nodoc


class _LoyaltyCard implements LoyaltyCard {
  const _LoyaltyCard({required this.points, required this.number, this.tier});
  

@override final  int points;
/// What the cashier scans; the QR code shows this number.
@override final  String number;
/// The tier as the restaurant names it; null when it names none. Only a
/// name so far: the API gives a tier no percent.
@override final  String? tier;

/// Create a copy of LoyaltyCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoyaltyCardCopyWith<_LoyaltyCard> get copyWith => __$LoyaltyCardCopyWithImpl<_LoyaltyCard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoyaltyCard&&(identical(other.points, points) || other.points == points)&&(identical(other.number, number) || other.number == number)&&(identical(other.tier, tier) || other.tier == tier));
}


@override
int get hashCode => Object.hash(runtimeType,points,number,tier);

@override
String toString() {
  return 'LoyaltyCard(points: $points, number: $number, tier: $tier)';
}


}

/// @nodoc
abstract mixin class _$LoyaltyCardCopyWith<$Res> implements $LoyaltyCardCopyWith<$Res> {
  factory _$LoyaltyCardCopyWith(_LoyaltyCard value, $Res Function(_LoyaltyCard) _then) = __$LoyaltyCardCopyWithImpl;
@override @useResult
$Res call({
 int points, String number, String? tier
});




}
/// @nodoc
class __$LoyaltyCardCopyWithImpl<$Res>
    implements _$LoyaltyCardCopyWith<$Res> {
  __$LoyaltyCardCopyWithImpl(this._self, this._then);

  final _LoyaltyCard _self;
  final $Res Function(_LoyaltyCard) _then;

/// Create a copy of LoyaltyCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? number = null,Object? tier = freezed,}) {
  return _then(_LoyaltyCard(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,tier: freezed == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
