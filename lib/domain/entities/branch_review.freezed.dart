// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BranchReview {

/// Whole stars, 1 to 5.
 int get rating;/// What the user wrote, read by the merchant only; null when nothing.
 String? get text;
/// Create a copy of BranchReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchReviewCopyWith<BranchReview> get copyWith => _$BranchReviewCopyWithImpl<BranchReview>(this as BranchReview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchReview&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,rating,text);

@override
String toString() {
  return 'BranchReview(rating: $rating, text: $text)';
}


}

/// @nodoc
abstract mixin class $BranchReviewCopyWith<$Res>  {
  factory $BranchReviewCopyWith(BranchReview value, $Res Function(BranchReview) _then) = _$BranchReviewCopyWithImpl;
@useResult
$Res call({
 int rating, String? text
});




}
/// @nodoc
class _$BranchReviewCopyWithImpl<$Res>
    implements $BranchReviewCopyWith<$Res> {
  _$BranchReviewCopyWithImpl(this._self, this._then);

  final BranchReview _self;
  final $Res Function(BranchReview) _then;

/// Create a copy of BranchReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rating = null,Object? text = freezed,}) {
  return _then(_self.copyWith(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BranchReview].
extension BranchReviewPatterns on BranchReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchReview value)  $default,){
final _that = this;
switch (_that) {
case _BranchReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchReview value)?  $default,){
final _that = this;
switch (_that) {
case _BranchReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rating,  String? text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchReview() when $default != null:
return $default(_that.rating,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rating,  String? text)  $default,) {final _that = this;
switch (_that) {
case _BranchReview():
return $default(_that.rating,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rating,  String? text)?  $default,) {final _that = this;
switch (_that) {
case _BranchReview() when $default != null:
return $default(_that.rating,_that.text);case _:
  return null;

}
}

}

/// @nodoc


class _BranchReview implements BranchReview {
  const _BranchReview({required this.rating, this.text});
  

/// Whole stars, 1 to 5.
@override final  int rating;
/// What the user wrote, read by the merchant only; null when nothing.
@override final  String? text;

/// Create a copy of BranchReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchReviewCopyWith<_BranchReview> get copyWith => __$BranchReviewCopyWithImpl<_BranchReview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchReview&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,rating,text);

@override
String toString() {
  return 'BranchReview(rating: $rating, text: $text)';
}


}

/// @nodoc
abstract mixin class _$BranchReviewCopyWith<$Res> implements $BranchReviewCopyWith<$Res> {
  factory _$BranchReviewCopyWith(_BranchReview value, $Res Function(_BranchReview) _then) = __$BranchReviewCopyWithImpl;
@override @useResult
$Res call({
 int rating, String? text
});




}
/// @nodoc
class __$BranchReviewCopyWithImpl<$Res>
    implements _$BranchReviewCopyWith<$Res> {
  __$BranchReviewCopyWithImpl(this._self, this._then);

  final _BranchReview _self;
  final $Res Function(_BranchReview) _then;

/// Create a copy of BranchReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rating = null,Object? text = freezed,}) {
  return _then(_BranchReview(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
