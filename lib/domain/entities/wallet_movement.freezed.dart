// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_movement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletMovement {

 String get id; WalletMovementKind get kind;/// How much moved, always positive.
 int get amount;/// When the user made it.
 DateTime get at;
/// Create a copy of WalletMovement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletMovementCopyWith<WalletMovement> get copyWith => _$WalletMovementCopyWithImpl<WalletMovement>(this as WalletMovement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.at, at) || other.at == at));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,amount,at);

@override
String toString() {
  return 'WalletMovement(id: $id, kind: $kind, amount: $amount, at: $at)';
}


}

/// @nodoc
abstract mixin class $WalletMovementCopyWith<$Res>  {
  factory $WalletMovementCopyWith(WalletMovement value, $Res Function(WalletMovement) _then) = _$WalletMovementCopyWithImpl;
@useResult
$Res call({
 String id, WalletMovementKind kind, int amount, DateTime at
});




}
/// @nodoc
class _$WalletMovementCopyWithImpl<$Res>
    implements $WalletMovementCopyWith<$Res> {
  _$WalletMovementCopyWithImpl(this._self, this._then);

  final WalletMovement _self;
  final $Res Function(WalletMovement) _then;

/// Create a copy of WalletMovement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? amount = null,Object? at = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as WalletMovementKind,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletMovement].
extension WalletMovementPatterns on WalletMovement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletMovement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletMovement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletMovement value)  $default,){
final _that = this;
switch (_that) {
case _WalletMovement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletMovement value)?  $default,){
final _that = this;
switch (_that) {
case _WalletMovement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  WalletMovementKind kind,  int amount,  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletMovement() when $default != null:
return $default(_that.id,_that.kind,_that.amount,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  WalletMovementKind kind,  int amount,  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _WalletMovement():
return $default(_that.id,_that.kind,_that.amount,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  WalletMovementKind kind,  int amount,  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _WalletMovement() when $default != null:
return $default(_that.id,_that.kind,_that.amount,_that.at);case _:
  return null;

}
}

}

/// @nodoc


class _WalletMovement implements WalletMovement {
  const _WalletMovement({required this.id, required this.kind, required this.amount, required this.at});
  

@override final  String id;
@override final  WalletMovementKind kind;
/// How much moved, always positive.
@override final  int amount;
/// When the user made it.
@override final  DateTime at;

/// Create a copy of WalletMovement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletMovementCopyWith<_WalletMovement> get copyWith => __$WalletMovementCopyWithImpl<_WalletMovement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletMovement&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.at, at) || other.at == at));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,amount,at);

@override
String toString() {
  return 'WalletMovement(id: $id, kind: $kind, amount: $amount, at: $at)';
}


}

/// @nodoc
abstract mixin class _$WalletMovementCopyWith<$Res> implements $WalletMovementCopyWith<$Res> {
  factory _$WalletMovementCopyWith(_WalletMovement value, $Res Function(_WalletMovement) _then) = __$WalletMovementCopyWithImpl;
@override @useResult
$Res call({
 String id, WalletMovementKind kind, int amount, DateTime at
});




}
/// @nodoc
class __$WalletMovementCopyWithImpl<$Res>
    implements _$WalletMovementCopyWith<$Res> {
  __$WalletMovementCopyWithImpl(this._self, this._then);

  final _WalletMovement _self;
  final $Res Function(_WalletMovement) _then;

/// Create a copy of WalletMovement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? amount = null,Object? at = null,}) {
  return _then(_WalletMovement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as WalletMovementKind,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
