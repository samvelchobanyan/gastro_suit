// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_choice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductChoice {

 String get productId; String get productName;/// Null for a product without sizes.
 ChosenSize? get size;/// Empty when nothing is chosen.
 List<ChosenOption> get options;
/// Create a copy of ProductChoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductChoiceCopyWith<ProductChoice> get copyWith => _$ProductChoiceCopyWithImpl<ProductChoice>(this as ProductChoice, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductChoice&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.size, size) || other.size == size)&&const DeepCollectionEquality().equals(other.options, options));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,size,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'ProductChoice(productId: $productId, productName: $productName, size: $size, options: $options)';
}


}

/// @nodoc
abstract mixin class $ProductChoiceCopyWith<$Res>  {
  factory $ProductChoiceCopyWith(ProductChoice value, $Res Function(ProductChoice) _then) = _$ProductChoiceCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, ChosenSize? size, List<ChosenOption> options
});


$ChosenSizeCopyWith<$Res>? get size;

}
/// @nodoc
class _$ProductChoiceCopyWithImpl<$Res>
    implements $ProductChoiceCopyWith<$Res> {
  _$ProductChoiceCopyWithImpl(this._self, this._then);

  final ProductChoice _self;
  final $Res Function(ProductChoice) _then;

/// Create a copy of ProductChoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? size = freezed,Object? options = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as ChosenSize?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<ChosenOption>,
  ));
}
/// Create a copy of ProductChoice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChosenSizeCopyWith<$Res>? get size {
    if (_self.size == null) {
    return null;
  }

  return $ChosenSizeCopyWith<$Res>(_self.size!, (value) {
    return _then(_self.copyWith(size: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductChoice].
extension ProductChoicePatterns on ProductChoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductChoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductChoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductChoice value)  $default,){
final _that = this;
switch (_that) {
case _ProductChoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductChoice value)?  $default,){
final _that = this;
switch (_that) {
case _ProductChoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  ChosenSize? size,  List<ChosenOption> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductChoice() when $default != null:
return $default(_that.productId,_that.productName,_that.size,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  ChosenSize? size,  List<ChosenOption> options)  $default,) {final _that = this;
switch (_that) {
case _ProductChoice():
return $default(_that.productId,_that.productName,_that.size,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  ChosenSize? size,  List<ChosenOption> options)?  $default,) {final _that = this;
switch (_that) {
case _ProductChoice() when $default != null:
return $default(_that.productId,_that.productName,_that.size,_that.options);case _:
  return null;

}
}

}

/// @nodoc


class _ProductChoice implements ProductChoice {
  const _ProductChoice({required this.productId, required this.productName, this.size, required final  List<ChosenOption> options}): _options = options;
  

@override final  String productId;
@override final  String productName;
/// Null for a product without sizes.
@override final  ChosenSize? size;
/// Empty when nothing is chosen.
 final  List<ChosenOption> _options;
/// Empty when nothing is chosen.
@override List<ChosenOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of ProductChoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductChoiceCopyWith<_ProductChoice> get copyWith => __$ProductChoiceCopyWithImpl<_ProductChoice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductChoice&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.size, size) || other.size == size)&&const DeepCollectionEquality().equals(other._options, _options));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,size,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'ProductChoice(productId: $productId, productName: $productName, size: $size, options: $options)';
}


}

/// @nodoc
abstract mixin class _$ProductChoiceCopyWith<$Res> implements $ProductChoiceCopyWith<$Res> {
  factory _$ProductChoiceCopyWith(_ProductChoice value, $Res Function(_ProductChoice) _then) = __$ProductChoiceCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, ChosenSize? size, List<ChosenOption> options
});


@override $ChosenSizeCopyWith<$Res>? get size;

}
/// @nodoc
class __$ProductChoiceCopyWithImpl<$Res>
    implements _$ProductChoiceCopyWith<$Res> {
  __$ProductChoiceCopyWithImpl(this._self, this._then);

  final _ProductChoice _self;
  final $Res Function(_ProductChoice) _then;

/// Create a copy of ProductChoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? size = freezed,Object? options = null,}) {
  return _then(_ProductChoice(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as ChosenSize?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<ChosenOption>,
  ));
}

/// Create a copy of ProductChoice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChosenSizeCopyWith<$Res>? get size {
    if (_self.size == null) {
    return null;
  }

  return $ChosenSizeCopyWith<$Res>(_self.size!, (value) {
    return _then(_self.copyWith(size: value));
  });
}
}

/// @nodoc
mixin _$ChosenSize {

 String get id; String get name;
/// Create a copy of ChosenSize
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChosenSizeCopyWith<ChosenSize> get copyWith => _$ChosenSizeCopyWithImpl<ChosenSize>(this as ChosenSize, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChosenSize&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ChosenSize(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $ChosenSizeCopyWith<$Res>  {
  factory $ChosenSizeCopyWith(ChosenSize value, $Res Function(ChosenSize) _then) = _$ChosenSizeCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$ChosenSizeCopyWithImpl<$Res>
    implements $ChosenSizeCopyWith<$Res> {
  _$ChosenSizeCopyWithImpl(this._self, this._then);

  final ChosenSize _self;
  final $Res Function(ChosenSize) _then;

/// Create a copy of ChosenSize
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChosenSize].
extension ChosenSizePatterns on ChosenSize {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChosenSize value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChosenSize() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChosenSize value)  $default,){
final _that = this;
switch (_that) {
case _ChosenSize():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChosenSize value)?  $default,){
final _that = this;
switch (_that) {
case _ChosenSize() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChosenSize() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _ChosenSize():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _ChosenSize() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _ChosenSize implements ChosenSize {
  const _ChosenSize({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of ChosenSize
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChosenSizeCopyWith<_ChosenSize> get copyWith => __$ChosenSizeCopyWithImpl<_ChosenSize>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChosenSize&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ChosenSize(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ChosenSizeCopyWith<$Res> implements $ChosenSizeCopyWith<$Res> {
  factory _$ChosenSizeCopyWith(_ChosenSize value, $Res Function(_ChosenSize) _then) = __$ChosenSizeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$ChosenSizeCopyWithImpl<$Res>
    implements _$ChosenSizeCopyWith<$Res> {
  __$ChosenSizeCopyWithImpl(this._self, this._then);

  final _ChosenSize _self;
  final $Res Function(_ChosenSize) _then;

/// Create a copy of ChosenSize
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_ChosenSize(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChosenOption {

 String get id; String get groupId; String get name;/// What it adds to the product's price; 0 when free.
 int get price;
/// Create a copy of ChosenOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChosenOptionCopyWith<ChosenOption> get copyWith => _$ChosenOptionCopyWithImpl<ChosenOption>(this as ChosenOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChosenOption&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price));
}


@override
int get hashCode => Object.hash(runtimeType,id,groupId,name,price);

@override
String toString() {
  return 'ChosenOption(id: $id, groupId: $groupId, name: $name, price: $price)';
}


}

/// @nodoc
abstract mixin class $ChosenOptionCopyWith<$Res>  {
  factory $ChosenOptionCopyWith(ChosenOption value, $Res Function(ChosenOption) _then) = _$ChosenOptionCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, String name, int price
});




}
/// @nodoc
class _$ChosenOptionCopyWithImpl<$Res>
    implements $ChosenOptionCopyWith<$Res> {
  _$ChosenOptionCopyWithImpl(this._self, this._then);

  final ChosenOption _self;
  final $Res Function(ChosenOption) _then;

/// Create a copy of ChosenOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? name = null,Object? price = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChosenOption].
extension ChosenOptionPatterns on ChosenOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChosenOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChosenOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChosenOption value)  $default,){
final _that = this;
switch (_that) {
case _ChosenOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChosenOption value)?  $default,){
final _that = this;
switch (_that) {
case _ChosenOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  String name,  int price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChosenOption() when $default != null:
return $default(_that.id,_that.groupId,_that.name,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  String name,  int price)  $default,) {final _that = this;
switch (_that) {
case _ChosenOption():
return $default(_that.id,_that.groupId,_that.name,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  String name,  int price)?  $default,) {final _that = this;
switch (_that) {
case _ChosenOption() when $default != null:
return $default(_that.id,_that.groupId,_that.name,_that.price);case _:
  return null;

}
}

}

/// @nodoc


class _ChosenOption implements ChosenOption {
  const _ChosenOption({required this.id, required this.groupId, required this.name, required this.price});
  

@override final  String id;
@override final  String groupId;
@override final  String name;
/// What it adds to the product's price; 0 when free.
@override final  int price;

/// Create a copy of ChosenOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChosenOptionCopyWith<_ChosenOption> get copyWith => __$ChosenOptionCopyWithImpl<_ChosenOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChosenOption&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price));
}


@override
int get hashCode => Object.hash(runtimeType,id,groupId,name,price);

@override
String toString() {
  return 'ChosenOption(id: $id, groupId: $groupId, name: $name, price: $price)';
}


}

/// @nodoc
abstract mixin class _$ChosenOptionCopyWith<$Res> implements $ChosenOptionCopyWith<$Res> {
  factory _$ChosenOptionCopyWith(_ChosenOption value, $Res Function(_ChosenOption) _then) = __$ChosenOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, String name, int price
});




}
/// @nodoc
class __$ChosenOptionCopyWithImpl<$Res>
    implements _$ChosenOptionCopyWith<$Res> {
  __$ChosenOptionCopyWithImpl(this._self, this._then);

  final _ChosenOption _self;
  final $Res Function(_ChosenOption) _then;

/// Create a copy of ChosenOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? name = null,Object? price = null,}) {
  return _then(_ChosenOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
