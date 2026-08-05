// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'messages_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MessagesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagesState()';
}


}

/// @nodoc
class $MessagesStateCopyWith<$Res>  {
$MessagesStateCopyWith(MessagesState _, $Res Function(MessagesState) __);
}


/// Adds pattern-matching-related methods to [MessagesState].
extension MessagesStatePatterns on MessagesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MessagesInitial value)?  initial,TResult Function( MessagesLoading value)?  loading,TResult Function( MessagesLoaded value)?  loaded,TResult Function( MessagesError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MessagesInitial() when initial != null:
return initial(_that);case MessagesLoading() when loading != null:
return loading(_that);case MessagesLoaded() when loaded != null:
return loaded(_that);case MessagesError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MessagesInitial value)  initial,required TResult Function( MessagesLoading value)  loading,required TResult Function( MessagesLoaded value)  loaded,required TResult Function( MessagesError value)  error,}){
final _that = this;
switch (_that) {
case MessagesInitial():
return initial(_that);case MessagesLoading():
return loading(_that);case MessagesLoaded():
return loaded(_that);case MessagesError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MessagesInitial value)?  initial,TResult? Function( MessagesLoading value)?  loading,TResult? Function( MessagesLoaded value)?  loaded,TResult? Function( MessagesError value)?  error,}){
final _that = this;
switch (_that) {
case MessagesInitial() when initial != null:
return initial(_that);case MessagesLoading() when loading != null:
return loading(_that);case MessagesLoaded() when loaded != null:
return loaded(_that);case MessagesError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<MessageEntity> messages,  bool sending)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MessagesInitial() when initial != null:
return initial();case MessagesLoading() when loading != null:
return loading();case MessagesLoaded() when loaded != null:
return loaded(_that.messages,_that.sending);case MessagesError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<MessageEntity> messages,  bool sending)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case MessagesInitial():
return initial();case MessagesLoading():
return loading();case MessagesLoaded():
return loaded(_that.messages,_that.sending);case MessagesError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<MessageEntity> messages,  bool sending)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case MessagesInitial() when initial != null:
return initial();case MessagesLoading() when loading != null:
return loading();case MessagesLoaded() when loaded != null:
return loaded(_that.messages,_that.sending);case MessagesError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MessagesInitial implements MessagesState {
  const MessagesInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagesState.initial()';
}


}




/// @nodoc


class MessagesLoading implements MessagesState {
  const MessagesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessagesState.loading()';
}


}




/// @nodoc


class MessagesLoaded implements MessagesState {
  const MessagesLoaded( List<MessageEntity> messages, {this.sending = false}): _messages = messages;
  

 final  List<MessageEntity> _messages;
 List<MessageEntity> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@JsonKey() final  bool sending;

/// Create a copy of MessagesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessagesLoadedCopyWith<MessagesLoaded> get copyWith => _$MessagesLoadedCopyWithImpl<MessagesLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagesLoaded&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.sending, sending) || other.sending == sending));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),sending);

@override
String toString() {
  return 'MessagesState.loaded(messages: $messages, sending: $sending)';
}


}

/// @nodoc
abstract mixin class $MessagesLoadedCopyWith<$Res> implements $MessagesStateCopyWith<$Res> {
  factory $MessagesLoadedCopyWith(MessagesLoaded value, $Res Function(MessagesLoaded) _then) = _$MessagesLoadedCopyWithImpl;
@useResult
$Res call({
 List<MessageEntity> messages, bool sending
});




}
/// @nodoc
class _$MessagesLoadedCopyWithImpl<$Res>
    implements $MessagesLoadedCopyWith<$Res> {
  _$MessagesLoadedCopyWithImpl(this._self, this._then);

  final MessagesLoaded _self;
  final $Res Function(MessagesLoaded) _then;

/// Create a copy of MessagesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? sending = null,}) {
  return _then(MessagesLoaded(
null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageEntity>,sending: null == sending ? _self.sending : sending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class MessagesError implements MessagesState {
  const MessagesError(this.failure);
  

 final  Failure failure;

/// Create a copy of MessagesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessagesErrorCopyWith<MessagesError> get copyWith => _$MessagesErrorCopyWithImpl<MessagesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagesError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'MessagesState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MessagesErrorCopyWith<$Res> implements $MessagesStateCopyWith<$Res> {
  factory $MessagesErrorCopyWith(MessagesError value, $Res Function(MessagesError) _then) = _$MessagesErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$MessagesErrorCopyWithImpl<$Res>
    implements $MessagesErrorCopyWith<$Res> {
  _$MessagesErrorCopyWithImpl(this._self, this._then);

  final MessagesError _self;
  final $Res Function(MessagesError) _then;

/// Create a copy of MessagesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(MessagesError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
