// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_checkout_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartCheckout {

/// The times offered besides "as soon as possible".
 List<DateTime> get slots;/// Null: as soon as possible.
 DateTime? get time;/// The tip in whole currency; 0 for none.
 int get tip;/// The user is entering an amount of their own.
 bool get isCustomTip;
/// Create a copy of CartCheckout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartCheckoutCopyWith<CartCheckout> get copyWith => _$CartCheckoutCopyWithImpl<CartCheckout>(this as CartCheckout, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartCheckout&&const DeepCollectionEquality().equals(other.slots, slots)&&(identical(other.time, time) || other.time == time)&&(identical(other.tip, tip) || other.tip == tip)&&(identical(other.isCustomTip, isCustomTip) || other.isCustomTip == isCustomTip));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(slots),time,tip,isCustomTip);

@override
String toString() {
  return 'CartCheckout(slots: $slots, time: $time, tip: $tip, isCustomTip: $isCustomTip)';
}


}

/// @nodoc
abstract mixin class $CartCheckoutCopyWith<$Res>  {
  factory $CartCheckoutCopyWith(CartCheckout value, $Res Function(CartCheckout) _then) = _$CartCheckoutCopyWithImpl;
@useResult
$Res call({
 List<DateTime> slots, DateTime? time, int tip, bool isCustomTip
});




}
/// @nodoc
class _$CartCheckoutCopyWithImpl<$Res>
    implements $CartCheckoutCopyWith<$Res> {
  _$CartCheckoutCopyWithImpl(this._self, this._then);

  final CartCheckout _self;
  final $Res Function(CartCheckout) _then;

/// Create a copy of CartCheckout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slots = null,Object? time = freezed,Object? tip = null,Object? isCustomTip = null,}) {
  return _then(_self.copyWith(
slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<DateTime>,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime?,tip: null == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as int,isCustomTip: null == isCustomTip ? _self.isCustomTip : isCustomTip // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CartCheckout].
extension CartCheckoutPatterns on CartCheckout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartCheckout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartCheckout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartCheckout value)  $default,){
final _that = this;
switch (_that) {
case _CartCheckout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartCheckout value)?  $default,){
final _that = this;
switch (_that) {
case _CartCheckout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DateTime> slots,  DateTime? time,  int tip,  bool isCustomTip)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartCheckout() when $default != null:
return $default(_that.slots,_that.time,_that.tip,_that.isCustomTip);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DateTime> slots,  DateTime? time,  int tip,  bool isCustomTip)  $default,) {final _that = this;
switch (_that) {
case _CartCheckout():
return $default(_that.slots,_that.time,_that.tip,_that.isCustomTip);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DateTime> slots,  DateTime? time,  int tip,  bool isCustomTip)?  $default,) {final _that = this;
switch (_that) {
case _CartCheckout() when $default != null:
return $default(_that.slots,_that.time,_that.tip,_that.isCustomTip);case _:
  return null;

}
}

}

/// @nodoc


class _CartCheckout implements CartCheckout {
  const _CartCheckout({required final  List<DateTime> slots, this.time, required this.tip, required this.isCustomTip}): _slots = slots;
  

/// The times offered besides "as soon as possible".
 final  List<DateTime> _slots;
/// The times offered besides "as soon as possible".
@override List<DateTime> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}

/// Null: as soon as possible.
@override final  DateTime? time;
/// The tip in whole currency; 0 for none.
@override final  int tip;
/// The user is entering an amount of their own.
@override final  bool isCustomTip;

/// Create a copy of CartCheckout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartCheckoutCopyWith<_CartCheckout> get copyWith => __$CartCheckoutCopyWithImpl<_CartCheckout>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartCheckout&&const DeepCollectionEquality().equals(other._slots, _slots)&&(identical(other.time, time) || other.time == time)&&(identical(other.tip, tip) || other.tip == tip)&&(identical(other.isCustomTip, isCustomTip) || other.isCustomTip == isCustomTip));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_slots),time,tip,isCustomTip);

@override
String toString() {
  return 'CartCheckout(slots: $slots, time: $time, tip: $tip, isCustomTip: $isCustomTip)';
}


}

/// @nodoc
abstract mixin class _$CartCheckoutCopyWith<$Res> implements $CartCheckoutCopyWith<$Res> {
  factory _$CartCheckoutCopyWith(_CartCheckout value, $Res Function(_CartCheckout) _then) = __$CartCheckoutCopyWithImpl;
@override @useResult
$Res call({
 List<DateTime> slots, DateTime? time, int tip, bool isCustomTip
});




}
/// @nodoc
class __$CartCheckoutCopyWithImpl<$Res>
    implements _$CartCheckoutCopyWith<$Res> {
  __$CartCheckoutCopyWithImpl(this._self, this._then);

  final _CartCheckout _self;
  final $Res Function(_CartCheckout) _then;

/// Create a copy of CartCheckout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slots = null,Object? time = freezed,Object? tip = null,Object? isCustomTip = null,}) {
  return _then(_CartCheckout(
slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<DateTime>,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime?,tip: null == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as int,isCustomTip: null == isCustomTip ? _self.isCustomTip : isCustomTip // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
