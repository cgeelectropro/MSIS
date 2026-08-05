// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsState()';
}


}

/// @nodoc
class $NotificationsStateCopyWith<$Res>  {
$NotificationsStateCopyWith(NotificationsState _, $Res Function(NotificationsState) __);
}


/// Adds pattern-matching-related methods to [NotificationsState].
extension NotificationsStatePatterns on NotificationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NotificationsInitial value)?  initial,TResult Function( NotificationsLoading value)?  loading,TResult Function( NotificationsLoaded value)?  loaded,TResult Function( NotificationsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NotificationsInitial() when initial != null:
return initial(_that);case NotificationsLoading() when loading != null:
return loading(_that);case NotificationsLoaded() when loaded != null:
return loaded(_that);case NotificationsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NotificationsInitial value)  initial,required TResult Function( NotificationsLoading value)  loading,required TResult Function( NotificationsLoaded value)  loaded,required TResult Function( NotificationsError value)  error,}){
final _that = this;
switch (_that) {
case NotificationsInitial():
return initial(_that);case NotificationsLoading():
return loading(_that);case NotificationsLoaded():
return loaded(_that);case NotificationsError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NotificationsInitial value)?  initial,TResult? Function( NotificationsLoading value)?  loading,TResult? Function( NotificationsLoaded value)?  loaded,TResult? Function( NotificationsError value)?  error,}){
final _that = this;
switch (_that) {
case NotificationsInitial() when initial != null:
return initial(_that);case NotificationsLoading() when loading != null:
return loading(_that);case NotificationsLoaded() when loaded != null:
return loaded(_that);case NotificationsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<NotificationEntity> items)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NotificationsInitial() when initial != null:
return initial();case NotificationsLoading() when loading != null:
return loading();case NotificationsLoaded() when loaded != null:
return loaded(_that.items);case NotificationsError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<NotificationEntity> items)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case NotificationsInitial():
return initial();case NotificationsLoading():
return loading();case NotificationsLoaded():
return loaded(_that.items);case NotificationsError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<NotificationEntity> items)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case NotificationsInitial() when initial != null:
return initial();case NotificationsLoading() when loading != null:
return loading();case NotificationsLoaded() when loaded != null:
return loaded(_that.items);case NotificationsError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class NotificationsInitial implements NotificationsState {
  const NotificationsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsState.initial()';
}


}




/// @nodoc


class NotificationsLoading implements NotificationsState {
  const NotificationsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsState.loading()';
}


}




/// @nodoc


class NotificationsLoaded implements NotificationsState {
  const NotificationsLoaded( List<NotificationEntity> items): _items = items;
  

 final  List<NotificationEntity> _items;
 List<NotificationEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsLoadedCopyWith<NotificationsLoaded> get copyWith => _$NotificationsLoadedCopyWithImpl<NotificationsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsLoaded&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'NotificationsState.loaded(items: $items)';
}


}

/// @nodoc
abstract mixin class $NotificationsLoadedCopyWith<$Res> implements $NotificationsStateCopyWith<$Res> {
  factory $NotificationsLoadedCopyWith(NotificationsLoaded value, $Res Function(NotificationsLoaded) _then) = _$NotificationsLoadedCopyWithImpl;
@useResult
$Res call({
 List<NotificationEntity> items
});




}
/// @nodoc
class _$NotificationsLoadedCopyWithImpl<$Res>
    implements $NotificationsLoadedCopyWith<$Res> {
  _$NotificationsLoadedCopyWithImpl(this._self, this._then);

  final NotificationsLoaded _self;
  final $Res Function(NotificationsLoaded) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(NotificationsLoaded(
null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationEntity>,
  ));
}


}

/// @nodoc


class NotificationsError implements NotificationsState {
  const NotificationsError(this.failure);
  

 final  Failure failure;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsErrorCopyWith<NotificationsError> get copyWith => _$NotificationsErrorCopyWithImpl<NotificationsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'NotificationsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $NotificationsErrorCopyWith<$Res> implements $NotificationsStateCopyWith<$Res> {
  factory $NotificationsErrorCopyWith(NotificationsError value, $Res Function(NotificationsError) _then) = _$NotificationsErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$NotificationsErrorCopyWithImpl<$Res>
    implements $NotificationsErrorCopyWith<$Res> {
  _$NotificationsErrorCopyWithImpl(this._self, this._then);

  final NotificationsError _self;
  final $Res Function(NotificationsError) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(NotificationsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
