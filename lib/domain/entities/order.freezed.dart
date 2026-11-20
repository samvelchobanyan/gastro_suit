// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Order {

 String get id; OrderStatus get status;/// The short number the order is called by at the counter; null until
/// the restaurant's till has given it one.
 String? get number;/// The branch to collect from: its id, and its name and address in the
/// app's language.
 String get branchId; String get branchName; String? get branchAddress;/// When it was placed.
 DateTime? get placedAt;/// When it is wanted for; null for as soon as possible.
 DateTime? get scheduledAt;/// What was ordered, as it was named and priced then.
 List<OrderLine> get lines;/// The lines together, before anything is taken off or added.
 int get subtotal;/// What the restaurant took off; 0 for nothing.
 int get discount;/// The user's tip; 0 for none.
 int get tip;/// What the order cost the user: [subtotal] − [discount] + [tip].
 int get total;/// What the user wrote to the kitchen.
 String? get comment;/// Whether the money for it was taken.
 bool get isPaid;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.number, number) || other.number == number)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.branchAddress, branchAddress) || other.branchAddress == branchAddress)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.tip, tip) || other.tip == tip)&&(identical(other.total, total) || other.total == total)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,number,branchId,branchName,branchAddress,placedAt,scheduledAt,const DeepCollectionEquality().hash(lines),subtotal,discount,tip,total,comment,isPaid);

@override
String toString() {
  return 'Order(id: $id, status: $status, number: $number, branchId: $branchId, branchName: $branchName, branchAddress: $branchAddress, placedAt: $placedAt, scheduledAt: $scheduledAt, lines: $lines, subtotal: $subtotal, discount: $discount, tip: $tip, total: $total, comment: $comment, isPaid: $isPaid)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, OrderStatus status, String? number, String branchId, String branchName, String? branchAddress, DateTime? placedAt, DateTime? scheduledAt, List<OrderLine> lines, int subtotal, int discount, int tip, int total, String? comment, bool isPaid
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? number = freezed,Object? branchId = null,Object? branchName = null,Object? branchAddress = freezed,Object? placedAt = freezed,Object? scheduledAt = freezed,Object? lines = null,Object? subtotal = null,Object? discount = null,Object? tip = null,Object? total = null,Object? comment = freezed,Object? isPaid = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String?,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,branchName: null == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String,branchAddress: freezed == branchAddress ? _self.branchAddress : branchAddress // ignore: cast_nullable_to_non_nullable
as String?,placedAt: freezed == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<OrderLine>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,tip: null == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  OrderStatus status,  String? number,  String branchId,  String branchName,  String? branchAddress,  DateTime? placedAt,  DateTime? scheduledAt,  List<OrderLine> lines,  int subtotal,  int discount,  int tip,  int total,  String? comment,  bool isPaid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.status,_that.number,_that.branchId,_that.branchName,_that.branchAddress,_that.placedAt,_that.scheduledAt,_that.lines,_that.subtotal,_that.discount,_that.tip,_that.total,_that.comment,_that.isPaid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  OrderStatus status,  String? number,  String branchId,  String branchName,  String? branchAddress,  DateTime? placedAt,  DateTime? scheduledAt,  List<OrderLine> lines,  int subtotal,  int discount,  int tip,  int total,  String? comment,  bool isPaid)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.status,_that.number,_that.branchId,_that.branchName,_that.branchAddress,_that.placedAt,_that.scheduledAt,_that.lines,_that.subtotal,_that.discount,_that.tip,_that.total,_that.comment,_that.isPaid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  OrderStatus status,  String? number,  String branchId,  String branchName,  String? branchAddress,  DateTime? placedAt,  DateTime? scheduledAt,  List<OrderLine> lines,  int subtotal,  int discount,  int tip,  int total,  String? comment,  bool isPaid)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.status,_that.number,_that.branchId,_that.branchName,_that.branchAddress,_that.placedAt,_that.scheduledAt,_that.lines,_that.subtotal,_that.discount,_that.tip,_that.total,_that.comment,_that.isPaid);case _:
  return null;

}
}

}

/// @nodoc


class _Order extends Order {
  const _Order({required this.id, required this.status, this.number, this.branchId = '', required this.branchName, this.branchAddress, this.placedAt, this.scheduledAt, final  List<OrderLine> lines = const [], this.subtotal = 0, this.discount = 0, this.tip = 0, this.total = 0, this.comment, this.isPaid = false}): _lines = lines,super._();
  

@override final  String id;
@override final  OrderStatus status;
/// The short number the order is called by at the counter; null until
/// the restaurant's till has given it one.
@override final  String? number;
/// The branch to collect from: its id, and its name and address in the
/// app's language.
@override@JsonKey() final  String branchId;
@override final  String branchName;
@override final  String? branchAddress;
/// When it was placed.
@override final  DateTime? placedAt;
/// When it is wanted for; null for as soon as possible.
@override final  DateTime? scheduledAt;
/// What was ordered, as it was named and priced then.
 final  List<OrderLine> _lines;
/// What was ordered, as it was named and priced then.
@override@JsonKey() List<OrderLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

/// The lines together, before anything is taken off or added.
@override@JsonKey() final  int subtotal;
/// What the restaurant took off; 0 for nothing.
@override@JsonKey() final  int discount;
/// The user's tip; 0 for none.
@override@JsonKey() final  int tip;
/// What the order cost the user: [subtotal] − [discount] + [tip].
@override@JsonKey() final  int total;
/// What the user wrote to the kitchen.
@override final  String? comment;
/// Whether the money for it was taken.
@override@JsonKey() final  bool isPaid;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.number, number) || other.number == number)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.branchAddress, branchAddress) || other.branchAddress == branchAddress)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.tip, tip) || other.tip == tip)&&(identical(other.total, total) || other.total == total)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,number,branchId,branchName,branchAddress,placedAt,scheduledAt,const DeepCollectionEquality().hash(_lines),subtotal,discount,tip,total,comment,isPaid);

@override
String toString() {
  return 'Order(id: $id, status: $status, number: $number, branchId: $branchId, branchName: $branchName, branchAddress: $branchAddress, placedAt: $placedAt, scheduledAt: $scheduledAt, lines: $lines, subtotal: $subtotal, discount: $discount, tip: $tip, total: $total, comment: $comment, isPaid: $isPaid)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, OrderStatus status, String? number, String branchId, String branchName, String? branchAddress, DateTime? placedAt, DateTime? scheduledAt, List<OrderLine> lines, int subtotal, int discount, int tip, int total, String? comment, bool isPaid
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? number = freezed,Object? branchId = null,Object? branchName = null,Object? branchAddress = freezed,Object? placedAt = freezed,Object? scheduledAt = freezed,Object? lines = null,Object? subtotal = null,Object? discount = null,Object? tip = null,Object? total = null,Object? comment = freezed,Object? isPaid = null,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String?,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,branchName: null == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String,branchAddress: freezed == branchAddress ? _self.branchAddress : branchAddress // ignore: cast_nullable_to_non_nullable
as String?,placedAt: freezed == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<OrderLine>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,tip: null == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$OrderLine {

/// The product's id is empty when it has since left the menu; its name
/// is the one it was ordered under.
 ProductChoice get choice;/// The product's photo: the menu's today, or the one it had when
/// ordered if it has since left the menu. Null for none.
 String? get imageUrl; int get quantity;/// The price of one, add-ons included.
 int get unitPrice; int get total;
/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderLineCopyWith<OrderLine> get copyWith => _$OrderLineCopyWithImpl<OrderLine>(this as OrderLine, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderLine&&(identical(other.choice, choice) || other.choice == choice)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,choice,imageUrl,quantity,unitPrice,total);

@override
String toString() {
  return 'OrderLine(choice: $choice, imageUrl: $imageUrl, quantity: $quantity, unitPrice: $unitPrice, total: $total)';
}


}

/// @nodoc
abstract mixin class $OrderLineCopyWith<$Res>  {
  factory $OrderLineCopyWith(OrderLine value, $Res Function(OrderLine) _then) = _$OrderLineCopyWithImpl;
@useResult
$Res call({
 ProductChoice choice, String? imageUrl, int quantity, int unitPrice, int total
});


$ProductChoiceCopyWith<$Res> get choice;

}
/// @nodoc
class _$OrderLineCopyWithImpl<$Res>
    implements $OrderLineCopyWith<$Res> {
  _$OrderLineCopyWithImpl(this._self, this._then);

  final OrderLine _self;
  final $Res Function(OrderLine) _then;

/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? choice = null,Object? imageUrl = freezed,Object? quantity = null,Object? unitPrice = null,Object? total = null,}) {
  return _then(_self.copyWith(
choice: null == choice ? _self.choice : choice // ignore: cast_nullable_to_non_nullable
as ProductChoice,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductChoiceCopyWith<$Res> get choice {
  
  return $ProductChoiceCopyWith<$Res>(_self.choice, (value) {
    return _then(_self.copyWith(choice: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderLine].
extension OrderLinePatterns on OrderLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderLine value)  $default,){
final _that = this;
switch (_that) {
case _OrderLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderLine value)?  $default,){
final _that = this;
switch (_that) {
case _OrderLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductChoice choice,  String? imageUrl,  int quantity,  int unitPrice,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderLine() when $default != null:
return $default(_that.choice,_that.imageUrl,_that.quantity,_that.unitPrice,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductChoice choice,  String? imageUrl,  int quantity,  int unitPrice,  int total)  $default,) {final _that = this;
switch (_that) {
case _OrderLine():
return $default(_that.choice,_that.imageUrl,_that.quantity,_that.unitPrice,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductChoice choice,  String? imageUrl,  int quantity,  int unitPrice,  int total)?  $default,) {final _that = this;
switch (_that) {
case _OrderLine() when $default != null:
return $default(_that.choice,_that.imageUrl,_that.quantity,_that.unitPrice,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _OrderLine implements OrderLine {
  const _OrderLine({required this.choice, this.imageUrl, required this.quantity, required this.unitPrice, required this.total});
  

/// The product's id is empty when it has since left the menu; its name
/// is the one it was ordered under.
@override final  ProductChoice choice;
/// The product's photo: the menu's today, or the one it had when
/// ordered if it has since left the menu. Null for none.
@override final  String? imageUrl;
@override final  int quantity;
/// The price of one, add-ons included.
@override final  int unitPrice;
@override final  int total;

/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderLineCopyWith<_OrderLine> get copyWith => __$OrderLineCopyWithImpl<_OrderLine>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderLine&&(identical(other.choice, choice) || other.choice == choice)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,choice,imageUrl,quantity,unitPrice,total);

@override
String toString() {
  return 'OrderLine(choice: $choice, imageUrl: $imageUrl, quantity: $quantity, unitPrice: $unitPrice, total: $total)';
}


}

/// @nodoc
abstract mixin class _$OrderLineCopyWith<$Res> implements $OrderLineCopyWith<$Res> {
  factory _$OrderLineCopyWith(_OrderLine value, $Res Function(_OrderLine) _then) = __$OrderLineCopyWithImpl;
@override @useResult
$Res call({
 ProductChoice choice, String? imageUrl, int quantity, int unitPrice, int total
});


@override $ProductChoiceCopyWith<$Res> get choice;

}
/// @nodoc
class __$OrderLineCopyWithImpl<$Res>
    implements _$OrderLineCopyWith<$Res> {
  __$OrderLineCopyWithImpl(this._self, this._then);

  final _OrderLine _self;
  final $Res Function(_OrderLine) _then;

/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? choice = null,Object? imageUrl = freezed,Object? quantity = null,Object? unitPrice = null,Object? total = null,}) {
  return _then(_OrderLine(
choice: null == choice ? _self.choice : choice // ignore: cast_nullable_to_non_nullable
as ProductChoice,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductChoiceCopyWith<$Res> get choice {
  
  return $ProductChoiceCopyWith<$Res>(_self.choice, (value) {
    return _then(_self.copyWith(choice: value));
  });
}
}

// dart format on
