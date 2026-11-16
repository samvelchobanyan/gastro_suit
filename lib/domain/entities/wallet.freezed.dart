// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Wallet {

/// All of it.
 int get total;/// What the user topped up themselves. Does not expire.
 int get ownTopUp;/// What came as gifts.
 int get gifts;/// How much of the wallet expires next, on [expiresAt]; 0 when nothing
/// does.
 int get expiring;/// When [expiring] expires; null when nothing does.
 DateTime? get expiresAt;
/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletCopyWith<Wallet> get copyWith => _$WalletCopyWithImpl<Wallet>(this as Wallet, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Wallet&&(identical(other.total, total) || other.total == total)&&(identical(other.ownTopUp, ownTopUp) || other.ownTopUp == ownTopUp)&&(identical(other.gifts, gifts) || other.gifts == gifts)&&(identical(other.expiring, expiring) || other.expiring == expiring)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,total,ownTopUp,gifts,expiring,expiresAt);

@override
String toString() {
  return 'Wallet(total: $total, ownTopUp: $ownTopUp, gifts: $gifts, expiring: $expiring, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $WalletCopyWith<$Res>  {
  factory $WalletCopyWith(Wallet value, $Res Function(Wallet) _then) = _$WalletCopyWithImpl;
@useResult
$Res call({
 int total, int ownTopUp, int gifts, int expiring, DateTime? expiresAt
});




}
/// @nodoc
class _$WalletCopyWithImpl<$Res>
    implements $WalletCopyWith<$Res> {
  _$WalletCopyWithImpl(this._self, this._then);

  final Wallet _self;
  final $Res Function(Wallet) _then;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? ownTopUp = null,Object? gifts = null,Object? expiring = null,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,ownTopUp: null == ownTopUp ? _self.ownTopUp : ownTopUp // ignore: cast_nullable_to_non_nullable
as int,gifts: null == gifts ? _self.gifts : gifts // ignore: cast_nullable_to_non_nullable
as int,expiring: null == expiring ? _self.expiring : expiring // ignore: cast_nullable_to_non_nullable
as int,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Wallet].
extension WalletPatterns on Wallet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Wallet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Wallet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Wallet value)  $default,){
final _that = this;
switch (_that) {
case _Wallet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Wallet value)?  $default,){
final _that = this;
switch (_that) {
case _Wallet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int ownTopUp,  int gifts,  int expiring,  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Wallet() when $default != null:
return $default(_that.total,_that.ownTopUp,_that.gifts,_that.expiring,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int ownTopUp,  int gifts,  int expiring,  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _Wallet():
return $default(_that.total,_that.ownTopUp,_that.gifts,_that.expiring,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int ownTopUp,  int gifts,  int expiring,  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _Wallet() when $default != null:
return $default(_that.total,_that.ownTopUp,_that.gifts,_that.expiring,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _Wallet implements Wallet {
  const _Wallet({required this.total, required this.ownTopUp, required this.gifts, required this.expiring, this.expiresAt});
  

/// All of it.
@override final  int total;
/// What the user topped up themselves. Does not expire.
@override final  int ownTopUp;
/// What came as gifts.
@override final  int gifts;
/// How much of the wallet expires next, on [expiresAt]; 0 when nothing
/// does.
@override final  int expiring;
/// When [expiring] expires; null when nothing does.
@override final  DateTime? expiresAt;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletCopyWith<_Wallet> get copyWith => __$WalletCopyWithImpl<_Wallet>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Wallet&&(identical(other.total, total) || other.total == total)&&(identical(other.ownTopUp, ownTopUp) || other.ownTopUp == ownTopUp)&&(identical(other.gifts, gifts) || other.gifts == gifts)&&(identical(other.expiring, expiring) || other.expiring == expiring)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,total,ownTopUp,gifts,expiring,expiresAt);

@override
String toString() {
  return 'Wallet(total: $total, ownTopUp: $ownTopUp, gifts: $gifts, expiring: $expiring, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$WalletCopyWith<$Res> implements $WalletCopyWith<$Res> {
  factory _$WalletCopyWith(_Wallet value, $Res Function(_Wallet) _then) = __$WalletCopyWithImpl;
@override @useResult
$Res call({
 int total, int ownTopUp, int gifts, int expiring, DateTime? expiresAt
});




}
/// @nodoc
class __$WalletCopyWithImpl<$Res>
    implements _$WalletCopyWith<$Res> {
  __$WalletCopyWithImpl(this._self, this._then);

  final _Wallet _self;
  final $Res Function(_Wallet) _then;

/// Create a copy of Wallet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? ownTopUp = null,Object? gifts = null,Object? expiring = null,Object? expiresAt = freezed,}) {
  return _then(_Wallet(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,ownTopUp: null == ownTopUp ? _self.ownTopUp : ownTopUp // ignore: cast_nullable_to_non_nullable
as int,gifts: null == gifts ? _self.gifts : gifts // ignore: cast_nullable_to_non_nullable
as int,expiring: null == expiring ? _self.expiring : expiring // ignore: cast_nullable_to_non_nullable
as int,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
