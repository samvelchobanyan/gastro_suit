// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_selection_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductSelection {

/// Null for a product without sizes, or when every size has run out.
 String? get sizeId;/// The chosen options of every group together.
 Set<String> get optionIds; int get quantity;/// The price of one: the size's price (the base price without sizes)
/// plus the surcharges of the chosen options. A preview: the server
/// prices the cart line.
 int get unitPrice;/// Whether this may be added: the product and a size are available,
/// and every group has as many options chosen as it asks for.
 bool get isComplete;
/// Create a copy of ProductSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSelectionCopyWith<ProductSelection> get copyWith => _$ProductSelectionCopyWithImpl<ProductSelection>(this as ProductSelection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSelection&&(identical(other.sizeId, sizeId) || other.sizeId == sizeId)&&const DeepCollectionEquality().equals(other.optionIds, optionIds)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete));
}


@override
int get hashCode => Object.hash(runtimeType,sizeId,const DeepCollectionEquality().hash(optionIds),quantity,unitPrice,isComplete);

@override
String toString() {
  return 'ProductSelection(sizeId: $sizeId, optionIds: $optionIds, quantity: $quantity, unitPrice: $unitPrice, isComplete: $isComplete)';
}


}

/// @nodoc
abstract mixin class $ProductSelectionCopyWith<$Res>  {
  factory $ProductSelectionCopyWith(ProductSelection value, $Res Function(ProductSelection) _then) = _$ProductSelectionCopyWithImpl;
@useResult
$Res call({
 String? sizeId, Set<String> optionIds, int quantity, int unitPrice, bool isComplete
});




}
/// @nodoc
class _$ProductSelectionCopyWithImpl<$Res>
    implements $ProductSelectionCopyWith<$Res> {
  _$ProductSelectionCopyWithImpl(this._self, this._then);

  final ProductSelection _self;
  final $Res Function(ProductSelection) _then;

/// Create a copy of ProductSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sizeId = freezed,Object? optionIds = null,Object? quantity = null,Object? unitPrice = null,Object? isComplete = null,}) {
  return _then(_self.copyWith(
sizeId: freezed == sizeId ? _self.sizeId : sizeId // ignore: cast_nullable_to_non_nullable
as String?,optionIds: null == optionIds ? _self.optionIds : optionIds // ignore: cast_nullable_to_non_nullable
as Set<String>,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSelection].
extension ProductSelectionPatterns on ProductSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSelection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSelection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSelection value)  $default,){
final _that = this;
switch (_that) {
case _ProductSelection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSelection value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSelection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? sizeId,  Set<String> optionIds,  int quantity,  int unitPrice,  bool isComplete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSelection() when $default != null:
return $default(_that.sizeId,_that.optionIds,_that.quantity,_that.unitPrice,_that.isComplete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? sizeId,  Set<String> optionIds,  int quantity,  int unitPrice,  bool isComplete)  $default,) {final _that = this;
switch (_that) {
case _ProductSelection():
return $default(_that.sizeId,_that.optionIds,_that.quantity,_that.unitPrice,_that.isComplete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? sizeId,  Set<String> optionIds,  int quantity,  int unitPrice,  bool isComplete)?  $default,) {final _that = this;
switch (_that) {
case _ProductSelection() when $default != null:
return $default(_that.sizeId,_that.optionIds,_that.quantity,_that.unitPrice,_that.isComplete);case _:
  return null;

}
}

}

/// @nodoc


class _ProductSelection extends ProductSelection {
  const _ProductSelection({this.sizeId, required final  Set<String> optionIds, required this.quantity, required this.unitPrice, required this.isComplete}): _optionIds = optionIds,super._();
  

/// Null for a product without sizes, or when every size has run out.
@override final  String? sizeId;
/// The chosen options of every group together.
 final  Set<String> _optionIds;
/// The chosen options of every group together.
@override Set<String> get optionIds {
  if (_optionIds is EqualUnmodifiableSetView) return _optionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_optionIds);
}

@override final  int quantity;
/// The price of one: the size's price (the base price without sizes)
/// plus the surcharges of the chosen options. A preview: the server
/// prices the cart line.
@override final  int unitPrice;
/// Whether this may be added: the product and a size are available,
/// and every group has as many options chosen as it asks for.
@override final  bool isComplete;

/// Create a copy of ProductSelection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSelectionCopyWith<_ProductSelection> get copyWith => __$ProductSelectionCopyWithImpl<_ProductSelection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSelection&&(identical(other.sizeId, sizeId) || other.sizeId == sizeId)&&const DeepCollectionEquality().equals(other._optionIds, _optionIds)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete));
}


@override
int get hashCode => Object.hash(runtimeType,sizeId,const DeepCollectionEquality().hash(_optionIds),quantity,unitPrice,isComplete);

@override
String toString() {
  return 'ProductSelection(sizeId: $sizeId, optionIds: $optionIds, quantity: $quantity, unitPrice: $unitPrice, isComplete: $isComplete)';
}


}

/// @nodoc
abstract mixin class _$ProductSelectionCopyWith<$Res> implements $ProductSelectionCopyWith<$Res> {
  factory _$ProductSelectionCopyWith(_ProductSelection value, $Res Function(_ProductSelection) _then) = __$ProductSelectionCopyWithImpl;
@override @useResult
$Res call({
 String? sizeId, Set<String> optionIds, int quantity, int unitPrice, bool isComplete
});




}
/// @nodoc
class __$ProductSelectionCopyWithImpl<$Res>
    implements _$ProductSelectionCopyWith<$Res> {
  __$ProductSelectionCopyWithImpl(this._self, this._then);

  final _ProductSelection _self;
  final $Res Function(_ProductSelection) _then;

/// Create a copy of ProductSelection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sizeId = freezed,Object? optionIds = null,Object? quantity = null,Object? unitPrice = null,Object? isComplete = null,}) {
  return _then(_ProductSelection(
sizeId: freezed == sizeId ? _self.sizeId : sizeId // ignore: cast_nullable_to_non_nullable
as String?,optionIds: null == optionIds ? _self._optionIds : optionIds // ignore: cast_nullable_to_non_nullable
as Set<String>,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
