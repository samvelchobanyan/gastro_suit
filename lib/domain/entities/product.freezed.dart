// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Product {

 String get id; String get categoryId; String get name; String? get description; String? get imageUrl;/// The base price; with [sizes], the price of the smallest size.
 int get price;/// False: the branch has stopped it. Shown greyed; the cart refuses it.
 bool get isAvailable; Portion? get portion; bool get isFeatured;/// From the cheapest; empty when the product has one size.
 List<ProductSize> get sizes;/// Empty when the product has no add-ons.
 List<ProductOptionGroup> get optionGroups;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.price, price) || other.price == price)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.portion, portion) || other.portion == portion)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&const DeepCollectionEquality().equals(other.sizes, sizes)&&const DeepCollectionEquality().equals(other.optionGroups, optionGroups));
}


@override
int get hashCode => Object.hash(runtimeType,id,categoryId,name,description,imageUrl,price,isAvailable,portion,isFeatured,const DeepCollectionEquality().hash(sizes),const DeepCollectionEquality().hash(optionGroups));

@override
String toString() {
  return 'Product(id: $id, categoryId: $categoryId, name: $name, description: $description, imageUrl: $imageUrl, price: $price, isAvailable: $isAvailable, portion: $portion, isFeatured: $isFeatured, sizes: $sizes, optionGroups: $optionGroups)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String categoryId, String name, String? description, String? imageUrl, int price, bool isAvailable, Portion? portion, bool isFeatured, List<ProductSize> sizes, List<ProductOptionGroup> optionGroups
});


$PortionCopyWith<$Res>? get portion;

}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? name = null,Object? description = freezed,Object? imageUrl = freezed,Object? price = null,Object? isAvailable = null,Object? portion = freezed,Object? isFeatured = null,Object? sizes = null,Object? optionGroups = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,portion: freezed == portion ? _self.portion : portion // ignore: cast_nullable_to_non_nullable
as Portion?,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,sizes: null == sizes ? _self.sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<ProductSize>,optionGroups: null == optionGroups ? _self.optionGroups : optionGroups // ignore: cast_nullable_to_non_nullable
as List<ProductOptionGroup>,
  ));
}
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortionCopyWith<$Res>? get portion {
    if (_self.portion == null) {
    return null;
  }

  return $PortionCopyWith<$Res>(_self.portion!, (value) {
    return _then(_self.copyWith(portion: value));
  });
}
}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String categoryId,  String name,  String? description,  String? imageUrl,  int price,  bool isAvailable,  Portion? portion,  bool isFeatured,  List<ProductSize> sizes,  List<ProductOptionGroup> optionGroups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.imageUrl,_that.price,_that.isAvailable,_that.portion,_that.isFeatured,_that.sizes,_that.optionGroups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String categoryId,  String name,  String? description,  String? imageUrl,  int price,  bool isAvailable,  Portion? portion,  bool isFeatured,  List<ProductSize> sizes,  List<ProductOptionGroup> optionGroups)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.imageUrl,_that.price,_that.isAvailable,_that.portion,_that.isFeatured,_that.sizes,_that.optionGroups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String categoryId,  String name,  String? description,  String? imageUrl,  int price,  bool isAvailable,  Portion? portion,  bool isFeatured,  List<ProductSize> sizes,  List<ProductOptionGroup> optionGroups)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.imageUrl,_that.price,_that.isAvailable,_that.portion,_that.isFeatured,_that.sizes,_that.optionGroups);case _:
  return null;

}
}

}

/// @nodoc


class _Product extends Product {
  const _Product({required this.id, required this.categoryId, required this.name, this.description, this.imageUrl, required this.price, required this.isAvailable, this.portion, required this.isFeatured, required final  List<ProductSize> sizes, required final  List<ProductOptionGroup> optionGroups}): _sizes = sizes,_optionGroups = optionGroups,super._();
  

@override final  String id;
@override final  String categoryId;
@override final  String name;
@override final  String? description;
@override final  String? imageUrl;
/// The base price; with [sizes], the price of the smallest size.
@override final  int price;
/// False: the branch has stopped it. Shown greyed; the cart refuses it.
@override final  bool isAvailable;
@override final  Portion? portion;
@override final  bool isFeatured;
/// From the cheapest; empty when the product has one size.
 final  List<ProductSize> _sizes;
/// From the cheapest; empty when the product has one size.
@override List<ProductSize> get sizes {
  if (_sizes is EqualUnmodifiableListView) return _sizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sizes);
}

/// Empty when the product has no add-ons.
 final  List<ProductOptionGroup> _optionGroups;
/// Empty when the product has no add-ons.
@override List<ProductOptionGroup> get optionGroups {
  if (_optionGroups is EqualUnmodifiableListView) return _optionGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_optionGroups);
}


/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.price, price) || other.price == price)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.portion, portion) || other.portion == portion)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&const DeepCollectionEquality().equals(other._sizes, _sizes)&&const DeepCollectionEquality().equals(other._optionGroups, _optionGroups));
}


@override
int get hashCode => Object.hash(runtimeType,id,categoryId,name,description,imageUrl,price,isAvailable,portion,isFeatured,const DeepCollectionEquality().hash(_sizes),const DeepCollectionEquality().hash(_optionGroups));

@override
String toString() {
  return 'Product(id: $id, categoryId: $categoryId, name: $name, description: $description, imageUrl: $imageUrl, price: $price, isAvailable: $isAvailable, portion: $portion, isFeatured: $isFeatured, sizes: $sizes, optionGroups: $optionGroups)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String categoryId, String name, String? description, String? imageUrl, int price, bool isAvailable, Portion? portion, bool isFeatured, List<ProductSize> sizes, List<ProductOptionGroup> optionGroups
});


@override $PortionCopyWith<$Res>? get portion;

}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? name = null,Object? description = freezed,Object? imageUrl = freezed,Object? price = null,Object? isAvailable = null,Object? portion = freezed,Object? isFeatured = null,Object? sizes = null,Object? optionGroups = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,portion: freezed == portion ? _self.portion : portion // ignore: cast_nullable_to_non_nullable
as Portion?,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,sizes: null == sizes ? _self._sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<ProductSize>,optionGroups: null == optionGroups ? _self._optionGroups : optionGroups // ignore: cast_nullable_to_non_nullable
as List<ProductOptionGroup>,
  ));
}

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortionCopyWith<$Res>? get portion {
    if (_self.portion == null) {
    return null;
  }

  return $PortionCopyWith<$Res>(_self.portion!, (value) {
    return _then(_self.copyWith(portion: value));
  });
}
}

/// @nodoc
mixin _$ProductSize {

 String get id; String get name; int get price;/// False: the branch has run out of it.
 bool get isAvailable;/// Exactly one size of a product is the default.
 bool get isDefault;
/// Create a copy of ProductSize
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSizeCopyWith<ProductSize> get copyWith => _$ProductSizeCopyWithImpl<ProductSize>(this as ProductSize, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSize&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,price,isAvailable,isDefault);

@override
String toString() {
  return 'ProductSize(id: $id, name: $name, price: $price, isAvailable: $isAvailable, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $ProductSizeCopyWith<$Res>  {
  factory $ProductSizeCopyWith(ProductSize value, $Res Function(ProductSize) _then) = _$ProductSizeCopyWithImpl;
@useResult
$Res call({
 String id, String name, int price, bool isAvailable, bool isDefault
});




}
/// @nodoc
class _$ProductSizeCopyWithImpl<$Res>
    implements $ProductSizeCopyWith<$Res> {
  _$ProductSizeCopyWithImpl(this._self, this._then);

  final ProductSize _self;
  final $Res Function(ProductSize) _then;

/// Create a copy of ProductSize
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = null,Object? isAvailable = null,Object? isDefault = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSize].
extension ProductSizePatterns on ProductSize {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSize value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSize() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSize value)  $default,){
final _that = this;
switch (_that) {
case _ProductSize():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSize value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSize() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int price,  bool isAvailable,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSize() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.isAvailable,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int price,  bool isAvailable,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _ProductSize():
return $default(_that.id,_that.name,_that.price,_that.isAvailable,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int price,  bool isAvailable,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _ProductSize() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.isAvailable,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc


class _ProductSize implements ProductSize {
  const _ProductSize({required this.id, required this.name, required this.price, required this.isAvailable, required this.isDefault});
  

@override final  String id;
@override final  String name;
@override final  int price;
/// False: the branch has run out of it.
@override final  bool isAvailable;
/// Exactly one size of a product is the default.
@override final  bool isDefault;

/// Create a copy of ProductSize
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSizeCopyWith<_ProductSize> get copyWith => __$ProductSizeCopyWithImpl<_ProductSize>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSize&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,price,isAvailable,isDefault);

@override
String toString() {
  return 'ProductSize(id: $id, name: $name, price: $price, isAvailable: $isAvailable, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$ProductSizeCopyWith<$Res> implements $ProductSizeCopyWith<$Res> {
  factory _$ProductSizeCopyWith(_ProductSize value, $Res Function(_ProductSize) _then) = __$ProductSizeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int price, bool isAvailable, bool isDefault
});




}
/// @nodoc
class __$ProductSizeCopyWithImpl<$Res>
    implements _$ProductSizeCopyWith<$Res> {
  __$ProductSizeCopyWithImpl(this._self, this._then);

  final _ProductSize _self;
  final $Res Function(_ProductSize) _then;

/// Create a copy of ProductSize
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = null,Object? isAvailable = null,Object? isDefault = null,}) {
  return _then(_ProductSize(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ProductOptionGroup {

 String get id; String get name;/// How many options must be chosen; 0 for an optional group.
 int get minSelected;/// How many options may be chosen; null for no limit.
 int? get maxSelected; List<ProductOption> get options;
/// Create a copy of ProductOptionGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductOptionGroupCopyWith<ProductOptionGroup> get copyWith => _$ProductOptionGroupCopyWithImpl<ProductOptionGroup>(this as ProductOptionGroup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductOptionGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.minSelected, minSelected) || other.minSelected == minSelected)&&(identical(other.maxSelected, maxSelected) || other.maxSelected == maxSelected)&&const DeepCollectionEquality().equals(other.options, options));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,minSelected,maxSelected,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'ProductOptionGroup(id: $id, name: $name, minSelected: $minSelected, maxSelected: $maxSelected, options: $options)';
}


}

/// @nodoc
abstract mixin class $ProductOptionGroupCopyWith<$Res>  {
  factory $ProductOptionGroupCopyWith(ProductOptionGroup value, $Res Function(ProductOptionGroup) _then) = _$ProductOptionGroupCopyWithImpl;
@useResult
$Res call({
 String id, String name, int minSelected, int? maxSelected, List<ProductOption> options
});




}
/// @nodoc
class _$ProductOptionGroupCopyWithImpl<$Res>
    implements $ProductOptionGroupCopyWith<$Res> {
  _$ProductOptionGroupCopyWithImpl(this._self, this._then);

  final ProductOptionGroup _self;
  final $Res Function(ProductOptionGroup) _then;

/// Create a copy of ProductOptionGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? minSelected = null,Object? maxSelected = freezed,Object? options = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,minSelected: null == minSelected ? _self.minSelected : minSelected // ignore: cast_nullable_to_non_nullable
as int,maxSelected: freezed == maxSelected ? _self.maxSelected : maxSelected // ignore: cast_nullable_to_non_nullable
as int?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<ProductOption>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductOptionGroup].
extension ProductOptionGroupPatterns on ProductOptionGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductOptionGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductOptionGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductOptionGroup value)  $default,){
final _that = this;
switch (_that) {
case _ProductOptionGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductOptionGroup value)?  $default,){
final _that = this;
switch (_that) {
case _ProductOptionGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int minSelected,  int? maxSelected,  List<ProductOption> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductOptionGroup() when $default != null:
return $default(_that.id,_that.name,_that.minSelected,_that.maxSelected,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int minSelected,  int? maxSelected,  List<ProductOption> options)  $default,) {final _that = this;
switch (_that) {
case _ProductOptionGroup():
return $default(_that.id,_that.name,_that.minSelected,_that.maxSelected,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int minSelected,  int? maxSelected,  List<ProductOption> options)?  $default,) {final _that = this;
switch (_that) {
case _ProductOptionGroup() when $default != null:
return $default(_that.id,_that.name,_that.minSelected,_that.maxSelected,_that.options);case _:
  return null;

}
}

}

/// @nodoc


class _ProductOptionGroup extends ProductOptionGroup {
  const _ProductOptionGroup({required this.id, required this.name, required this.minSelected, this.maxSelected, required final  List<ProductOption> options}): _options = options,super._();
  

@override final  String id;
@override final  String name;
/// How many options must be chosen; 0 for an optional group.
@override final  int minSelected;
/// How many options may be chosen; null for no limit.
@override final  int? maxSelected;
 final  List<ProductOption> _options;
@override List<ProductOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of ProductOptionGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductOptionGroupCopyWith<_ProductOptionGroup> get copyWith => __$ProductOptionGroupCopyWithImpl<_ProductOptionGroup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductOptionGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.minSelected, minSelected) || other.minSelected == minSelected)&&(identical(other.maxSelected, maxSelected) || other.maxSelected == maxSelected)&&const DeepCollectionEquality().equals(other._options, _options));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,minSelected,maxSelected,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'ProductOptionGroup(id: $id, name: $name, minSelected: $minSelected, maxSelected: $maxSelected, options: $options)';
}


}

/// @nodoc
abstract mixin class _$ProductOptionGroupCopyWith<$Res> implements $ProductOptionGroupCopyWith<$Res> {
  factory _$ProductOptionGroupCopyWith(_ProductOptionGroup value, $Res Function(_ProductOptionGroup) _then) = __$ProductOptionGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int minSelected, int? maxSelected, List<ProductOption> options
});




}
/// @nodoc
class __$ProductOptionGroupCopyWithImpl<$Res>
    implements _$ProductOptionGroupCopyWith<$Res> {
  __$ProductOptionGroupCopyWithImpl(this._self, this._then);

  final _ProductOptionGroup _self;
  final $Res Function(_ProductOptionGroup) _then;

/// Create a copy of ProductOptionGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? minSelected = null,Object? maxSelected = freezed,Object? options = null,}) {
  return _then(_ProductOptionGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,minSelected: null == minSelected ? _self.minSelected : minSelected // ignore: cast_nullable_to_non_nullable
as int,maxSelected: freezed == maxSelected ? _self.maxSelected : maxSelected // ignore: cast_nullable_to_non_nullable
as int?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<ProductOption>,
  ));
}


}

/// @nodoc
mixin _$ProductOption {

 String get id; String get name;/// What choosing it adds to the product's price; 0 when free.
 int get price;/// False: the branch has run out of it.
 bool get isAvailable;/// Chosen until the user changes it.
 bool get isDefault;
/// Create a copy of ProductOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductOptionCopyWith<ProductOption> get copyWith => _$ProductOptionCopyWithImpl<ProductOption>(this as ProductOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,price,isAvailable,isDefault);

@override
String toString() {
  return 'ProductOption(id: $id, name: $name, price: $price, isAvailable: $isAvailable, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $ProductOptionCopyWith<$Res>  {
  factory $ProductOptionCopyWith(ProductOption value, $Res Function(ProductOption) _then) = _$ProductOptionCopyWithImpl;
@useResult
$Res call({
 String id, String name, int price, bool isAvailable, bool isDefault
});




}
/// @nodoc
class _$ProductOptionCopyWithImpl<$Res>
    implements $ProductOptionCopyWith<$Res> {
  _$ProductOptionCopyWithImpl(this._self, this._then);

  final ProductOption _self;
  final $Res Function(ProductOption) _then;

/// Create a copy of ProductOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = null,Object? isAvailable = null,Object? isDefault = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductOption].
extension ProductOptionPatterns on ProductOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductOption value)  $default,){
final _that = this;
switch (_that) {
case _ProductOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductOption value)?  $default,){
final _that = this;
switch (_that) {
case _ProductOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int price,  bool isAvailable,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductOption() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.isAvailable,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int price,  bool isAvailable,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _ProductOption():
return $default(_that.id,_that.name,_that.price,_that.isAvailable,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int price,  bool isAvailable,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _ProductOption() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.isAvailable,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc


class _ProductOption implements ProductOption {
  const _ProductOption({required this.id, required this.name, required this.price, required this.isAvailable, required this.isDefault});
  

@override final  String id;
@override final  String name;
/// What choosing it adds to the product's price; 0 when free.
@override final  int price;
/// False: the branch has run out of it.
@override final  bool isAvailable;
/// Chosen until the user changes it.
@override final  bool isDefault;

/// Create a copy of ProductOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductOptionCopyWith<_ProductOption> get copyWith => __$ProductOptionCopyWithImpl<_ProductOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,price,isAvailable,isDefault);

@override
String toString() {
  return 'ProductOption(id: $id, name: $name, price: $price, isAvailable: $isAvailable, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$ProductOptionCopyWith<$Res> implements $ProductOptionCopyWith<$Res> {
  factory _$ProductOptionCopyWith(_ProductOption value, $Res Function(_ProductOption) _then) = __$ProductOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int price, bool isAvailable, bool isDefault
});




}
/// @nodoc
class __$ProductOptionCopyWithImpl<$Res>
    implements _$ProductOptionCopyWith<$Res> {
  __$ProductOptionCopyWithImpl(this._self, this._then);

  final _ProductOption _self;
  final $Res Function(_ProductOption) _then;

/// Create a copy of ProductOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = null,Object? isAvailable = null,Object? isDefault = null,}) {
  return _then(_ProductOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$Portion {

 num get amount; PortionUnit get unit;
/// Create a copy of Portion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortionCopyWith<Portion> get copyWith => _$PortionCopyWithImpl<Portion>(this as Portion, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Portion&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,amount,unit);

@override
String toString() {
  return 'Portion(amount: $amount, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $PortionCopyWith<$Res>  {
  factory $PortionCopyWith(Portion value, $Res Function(Portion) _then) = _$PortionCopyWithImpl;
@useResult
$Res call({
 num amount, PortionUnit unit
});




}
/// @nodoc
class _$PortionCopyWithImpl<$Res>
    implements $PortionCopyWith<$Res> {
  _$PortionCopyWithImpl(this._self, this._then);

  final Portion _self;
  final $Res Function(Portion) _then;

/// Create a copy of Portion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? unit = null,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as PortionUnit,
  ));
}

}


/// Adds pattern-matching-related methods to [Portion].
extension PortionPatterns on Portion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Portion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Portion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Portion value)  $default,){
final _that = this;
switch (_that) {
case _Portion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Portion value)?  $default,){
final _that = this;
switch (_that) {
case _Portion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num amount,  PortionUnit unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Portion() when $default != null:
return $default(_that.amount,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num amount,  PortionUnit unit)  $default,) {final _that = this;
switch (_that) {
case _Portion():
return $default(_that.amount,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num amount,  PortionUnit unit)?  $default,) {final _that = this;
switch (_that) {
case _Portion() when $default != null:
return $default(_that.amount,_that.unit);case _:
  return null;

}
}

}

/// @nodoc


class _Portion implements Portion {
  const _Portion({required this.amount, required this.unit});
  

@override final  num amount;
@override final  PortionUnit unit;

/// Create a copy of Portion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortionCopyWith<_Portion> get copyWith => __$PortionCopyWithImpl<_Portion>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Portion&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,amount,unit);

@override
String toString() {
  return 'Portion(amount: $amount, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$PortionCopyWith<$Res> implements $PortionCopyWith<$Res> {
  factory _$PortionCopyWith(_Portion value, $Res Function(_Portion) _then) = __$PortionCopyWithImpl;
@override @useResult
$Res call({
 num amount, PortionUnit unit
});




}
/// @nodoc
class __$PortionCopyWithImpl<$Res>
    implements _$PortionCopyWith<$Res> {
  __$PortionCopyWithImpl(this._self, this._then);

  final _Portion _self;
  final $Res Function(_Portion) _then;

/// Create a copy of Portion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? unit = null,}) {
  return _then(_Portion(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as PortionUnit,
  ));
}


}

// dart format on
