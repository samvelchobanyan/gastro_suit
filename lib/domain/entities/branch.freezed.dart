// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Branch {

 String get id; String get name; String get address; String? get photoUrl;/// For the distance to the user; both or neither.
 double? get latitude; double? get longitude;/// Today's hours as the server reported them when the list was loaded;
/// null when the branch has no hours entered.
 TodayHours? get today;/// Closed for now regardless of its hours (repairs and the like).
 bool get isTemporarilyClosed;
/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchCopyWith<Branch> get copyWith => _$BranchCopyWithImpl<Branch>(this as Branch, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Branch&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.today, today) || other.today == today)&&(identical(other.isTemporarilyClosed, isTemporarilyClosed) || other.isTemporarilyClosed == isTemporarilyClosed));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,address,photoUrl,latitude,longitude,today,isTemporarilyClosed);

@override
String toString() {
  return 'Branch(id: $id, name: $name, address: $address, photoUrl: $photoUrl, latitude: $latitude, longitude: $longitude, today: $today, isTemporarilyClosed: $isTemporarilyClosed)';
}


}

/// @nodoc
abstract mixin class $BranchCopyWith<$Res>  {
  factory $BranchCopyWith(Branch value, $Res Function(Branch) _then) = _$BranchCopyWithImpl;
@useResult
$Res call({
 String id, String name, String address, String? photoUrl, double? latitude, double? longitude, TodayHours? today, bool isTemporarilyClosed
});


$TodayHoursCopyWith<$Res>? get today;

}
/// @nodoc
class _$BranchCopyWithImpl<$Res>
    implements $BranchCopyWith<$Res> {
  _$BranchCopyWithImpl(this._self, this._then);

  final Branch _self;
  final $Res Function(Branch) _then;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? photoUrl = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? today = freezed,Object? isTemporarilyClosed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as TodayHours?,isTemporarilyClosed: null == isTemporarilyClosed ? _self.isTemporarilyClosed : isTemporarilyClosed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TodayHoursCopyWith<$Res>? get today {
    if (_self.today == null) {
    return null;
  }

  return $TodayHoursCopyWith<$Res>(_self.today!, (value) {
    return _then(_self.copyWith(today: value));
  });
}
}


/// Adds pattern-matching-related methods to [Branch].
extension BranchPatterns on Branch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Branch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Branch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Branch value)  $default,){
final _that = this;
switch (_that) {
case _Branch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Branch value)?  $default,){
final _that = this;
switch (_that) {
case _Branch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String address,  String? photoUrl,  double? latitude,  double? longitude,  TodayHours? today,  bool isTemporarilyClosed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.photoUrl,_that.latitude,_that.longitude,_that.today,_that.isTemporarilyClosed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String address,  String? photoUrl,  double? latitude,  double? longitude,  TodayHours? today,  bool isTemporarilyClosed)  $default,) {final _that = this;
switch (_that) {
case _Branch():
return $default(_that.id,_that.name,_that.address,_that.photoUrl,_that.latitude,_that.longitude,_that.today,_that.isTemporarilyClosed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String address,  String? photoUrl,  double? latitude,  double? longitude,  TodayHours? today,  bool isTemporarilyClosed)?  $default,) {final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.photoUrl,_that.latitude,_that.longitude,_that.today,_that.isTemporarilyClosed);case _:
  return null;

}
}

}

/// @nodoc


class _Branch extends Branch {
  const _Branch({required this.id, required this.name, required this.address, this.photoUrl, this.latitude, this.longitude, this.today, required this.isTemporarilyClosed}): super._();
  

@override final  String id;
@override final  String name;
@override final  String address;
@override final  String? photoUrl;
/// For the distance to the user; both or neither.
@override final  double? latitude;
@override final  double? longitude;
/// Today's hours as the server reported them when the list was loaded;
/// null when the branch has no hours entered.
@override final  TodayHours? today;
/// Closed for now regardless of its hours (repairs and the like).
@override final  bool isTemporarilyClosed;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchCopyWith<_Branch> get copyWith => __$BranchCopyWithImpl<_Branch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Branch&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.today, today) || other.today == today)&&(identical(other.isTemporarilyClosed, isTemporarilyClosed) || other.isTemporarilyClosed == isTemporarilyClosed));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,address,photoUrl,latitude,longitude,today,isTemporarilyClosed);

@override
String toString() {
  return 'Branch(id: $id, name: $name, address: $address, photoUrl: $photoUrl, latitude: $latitude, longitude: $longitude, today: $today, isTemporarilyClosed: $isTemporarilyClosed)';
}


}

/// @nodoc
abstract mixin class _$BranchCopyWith<$Res> implements $BranchCopyWith<$Res> {
  factory _$BranchCopyWith(_Branch value, $Res Function(_Branch) _then) = __$BranchCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String address, String? photoUrl, double? latitude, double? longitude, TodayHours? today, bool isTemporarilyClosed
});


@override $TodayHoursCopyWith<$Res>? get today;

}
/// @nodoc
class __$BranchCopyWithImpl<$Res>
    implements _$BranchCopyWith<$Res> {
  __$BranchCopyWithImpl(this._self, this._then);

  final _Branch _self;
  final $Res Function(_Branch) _then;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? photoUrl = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? today = freezed,Object? isTemporarilyClosed = null,}) {
  return _then(_Branch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as TodayHours?,isTemporarilyClosed: null == isTemporarilyClosed ? _self.isTemporarilyClosed : isTemporarilyClosed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TodayHoursCopyWith<$Res>? get today {
    if (_self.today == null) {
    return null;
  }

  return $TodayHoursCopyWith<$Res>(_self.today!, (value) {
    return _then(_self.copyWith(today: value));
  });
}
}

/// @nodoc
mixin _$TodayHours {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayHours);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TodayHours()';
}


}

/// @nodoc
class $TodayHoursCopyWith<$Res>  {
$TodayHoursCopyWith(TodayHours _, $Res Function(TodayHours) __);
}


/// Adds pattern-matching-related methods to [TodayHours].
extension TodayHoursPatterns on TodayHours {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TodayOpen value)?  open,TResult Function( TodayClosed value)?  closed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TodayOpen() when open != null:
return open(_that);case TodayClosed() when closed != null:
return closed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TodayOpen value)  open,required TResult Function( TodayClosed value)  closed,}){
final _that = this;
switch (_that) {
case TodayOpen():
return open(_that);case TodayClosed():
return closed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TodayOpen value)?  open,TResult? Function( TodayClosed value)?  closed,}){
final _that = this;
switch (_that) {
case TodayOpen() when open != null:
return open(_that);case TodayClosed() when closed != null:
return closed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String opens,  String closes,  bool isOpenNow)?  open,TResult Function()?  closed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TodayOpen() when open != null:
return open(_that.opens,_that.closes,_that.isOpenNow);case TodayClosed() when closed != null:
return closed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String opens,  String closes,  bool isOpenNow)  open,required TResult Function()  closed,}) {final _that = this;
switch (_that) {
case TodayOpen():
return open(_that.opens,_that.closes,_that.isOpenNow);case TodayClosed():
return closed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String opens,  String closes,  bool isOpenNow)?  open,TResult? Function()?  closed,}) {final _that = this;
switch (_that) {
case TodayOpen() when open != null:
return open(_that.opens,_that.closes,_that.isOpenNow);case TodayClosed() when closed != null:
return closed();case _:
  return null;

}
}

}

/// @nodoc


class TodayOpen implements TodayHours {
  const TodayOpen({required this.opens, required this.closes, required this.isOpenNow});
  

 final  String opens;
 final  String closes;
 final  bool isOpenNow;

/// Create a copy of TodayHours
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayOpenCopyWith<TodayOpen> get copyWith => _$TodayOpenCopyWithImpl<TodayOpen>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayOpen&&(identical(other.opens, opens) || other.opens == opens)&&(identical(other.closes, closes) || other.closes == closes)&&(identical(other.isOpenNow, isOpenNow) || other.isOpenNow == isOpenNow));
}


@override
int get hashCode => Object.hash(runtimeType,opens,closes,isOpenNow);

@override
String toString() {
  return 'TodayHours.open(opens: $opens, closes: $closes, isOpenNow: $isOpenNow)';
}


}

/// @nodoc
abstract mixin class $TodayOpenCopyWith<$Res> implements $TodayHoursCopyWith<$Res> {
  factory $TodayOpenCopyWith(TodayOpen value, $Res Function(TodayOpen) _then) = _$TodayOpenCopyWithImpl;
@useResult
$Res call({
 String opens, String closes, bool isOpenNow
});




}
/// @nodoc
class _$TodayOpenCopyWithImpl<$Res>
    implements $TodayOpenCopyWith<$Res> {
  _$TodayOpenCopyWithImpl(this._self, this._then);

  final TodayOpen _self;
  final $Res Function(TodayOpen) _then;

/// Create a copy of TodayHours
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? opens = null,Object? closes = null,Object? isOpenNow = null,}) {
  return _then(TodayOpen(
opens: null == opens ? _self.opens : opens // ignore: cast_nullable_to_non_nullable
as String,closes: null == closes ? _self.closes : closes // ignore: cast_nullable_to_non_nullable
as String,isOpenNow: null == isOpenNow ? _self.isOpenNow : isOpenNow // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class TodayClosed implements TodayHours {
  const TodayClosed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayClosed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TodayHours.closed()';
}


}




// dart format on
