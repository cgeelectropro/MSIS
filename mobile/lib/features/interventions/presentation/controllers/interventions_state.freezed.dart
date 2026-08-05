// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interventions_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InterventionsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterventionsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InterventionsState()';
}


}

/// @nodoc
class $InterventionsStateCopyWith<$Res>  {
$InterventionsStateCopyWith(InterventionsState _, $Res Function(InterventionsState) __);
}


/// Adds pattern-matching-related methods to [InterventionsState].
extension InterventionsStatePatterns on InterventionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InterventionsInitial value)?  initial,TResult Function( InterventionsLoading value)?  loading,TResult Function( InterventionsLoaded value)?  loaded,TResult Function( InterventionsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InterventionsInitial() when initial != null:
return initial(_that);case InterventionsLoading() when loading != null:
return loading(_that);case InterventionsLoaded() when loaded != null:
return loaded(_that);case InterventionsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InterventionsInitial value)  initial,required TResult Function( InterventionsLoading value)  loading,required TResult Function( InterventionsLoaded value)  loaded,required TResult Function( InterventionsError value)  error,}){
final _that = this;
switch (_that) {
case InterventionsInitial():
return initial(_that);case InterventionsLoading():
return loading(_that);case InterventionsLoaded():
return loaded(_that);case InterventionsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InterventionsInitial value)?  initial,TResult? Function( InterventionsLoading value)?  loading,TResult? Function( InterventionsLoaded value)?  loaded,TResult? Function( InterventionsError value)?  error,}){
final _that = this;
switch (_that) {
case InterventionsInitial() when initial != null:
return initial(_that);case InterventionsLoading() when loading != null:
return loading(_that);case InterventionsLoaded() when loaded != null:
return loaded(_that);case InterventionsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<InterventionEntity> items)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InterventionsInitial() when initial != null:
return initial();case InterventionsLoading() when loading != null:
return loading();case InterventionsLoaded() when loaded != null:
return loaded(_that.items);case InterventionsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<InterventionEntity> items)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case InterventionsInitial():
return initial();case InterventionsLoading():
return loading();case InterventionsLoaded():
return loaded(_that.items);case InterventionsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<InterventionEntity> items)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case InterventionsInitial() when initial != null:
return initial();case InterventionsLoading() when loading != null:
return loading();case InterventionsLoaded() when loaded != null:
return loaded(_that.items);case InterventionsError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class InterventionsInitial implements InterventionsState {
  const InterventionsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterventionsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InterventionsState.initial()';
}


}




/// @nodoc


class InterventionsLoading implements InterventionsState {
  const InterventionsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterventionsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InterventionsState.loading()';
}


}




/// @nodoc


class InterventionsLoaded implements InterventionsState {
  const InterventionsLoaded( List<InterventionEntity> items): _items = items;
  

 final  List<InterventionEntity> _items;
 List<InterventionEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of InterventionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterventionsLoadedCopyWith<InterventionsLoaded> get copyWith => _$InterventionsLoadedCopyWithImpl<InterventionsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterventionsLoaded&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'InterventionsState.loaded(items: $items)';
}


}

/// @nodoc
abstract mixin class $InterventionsLoadedCopyWith<$Res> implements $InterventionsStateCopyWith<$Res> {
  factory $InterventionsLoadedCopyWith(InterventionsLoaded value, $Res Function(InterventionsLoaded) _then) = _$InterventionsLoadedCopyWithImpl;
@useResult
$Res call({
 List<InterventionEntity> items
});




}
/// @nodoc
class _$InterventionsLoadedCopyWithImpl<$Res>
    implements $InterventionsLoadedCopyWith<$Res> {
  _$InterventionsLoadedCopyWithImpl(this._self, this._then);

  final InterventionsLoaded _self;
  final $Res Function(InterventionsLoaded) _then;

/// Create a copy of InterventionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(InterventionsLoaded(
null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<InterventionEntity>,
  ));
}


}

/// @nodoc


class InterventionsError implements InterventionsState {
  const InterventionsError(this.failure);
  

 final  Failure failure;

/// Create a copy of InterventionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterventionsErrorCopyWith<InterventionsError> get copyWith => _$InterventionsErrorCopyWithImpl<InterventionsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterventionsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'InterventionsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $InterventionsErrorCopyWith<$Res> implements $InterventionsStateCopyWith<$Res> {
  factory $InterventionsErrorCopyWith(InterventionsError value, $Res Function(InterventionsError) _then) = _$InterventionsErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$InterventionsErrorCopyWithImpl<$Res>
    implements $InterventionsErrorCopyWith<$Res> {
  _$InterventionsErrorCopyWithImpl(this._self, this._then);

  final InterventionsError _self;
  final $Res Function(InterventionsError) _then;

/// Create a copy of InterventionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(InterventionsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
