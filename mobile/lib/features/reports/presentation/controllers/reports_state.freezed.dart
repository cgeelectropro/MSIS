// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reports_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReportsState()';
}


}

/// @nodoc
class $ReportsStateCopyWith<$Res>  {
$ReportsStateCopyWith(ReportsState _, $Res Function(ReportsState) __);
}


/// Adds pattern-matching-related methods to [ReportsState].
extension ReportsStatePatterns on ReportsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReportsInitial value)?  initial,TResult Function( ReportsLoading value)?  loading,TResult Function( ReportsLoaded value)?  loaded,TResult Function( ReportsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReportsInitial() when initial != null:
return initial(_that);case ReportsLoading() when loading != null:
return loading(_that);case ReportsLoaded() when loaded != null:
return loaded(_that);case ReportsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReportsInitial value)  initial,required TResult Function( ReportsLoading value)  loading,required TResult Function( ReportsLoaded value)  loaded,required TResult Function( ReportsError value)  error,}){
final _that = this;
switch (_that) {
case ReportsInitial():
return initial(_that);case ReportsLoading():
return loading(_that);case ReportsLoaded():
return loaded(_that);case ReportsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReportsInitial value)?  initial,TResult? Function( ReportsLoading value)?  loading,TResult? Function( ReportsLoaded value)?  loaded,TResult? Function( ReportsError value)?  error,}){
final _that = this;
switch (_that) {
case ReportsInitial() when initial != null:
return initial(_that);case ReportsLoading() when loading != null:
return loading(_that);case ReportsLoaded() when loaded != null:
return loaded(_that);case ReportsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( DashboardReportEntity report)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReportsInitial() when initial != null:
return initial();case ReportsLoading() when loading != null:
return loading();case ReportsLoaded() when loaded != null:
return loaded(_that.report);case ReportsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( DashboardReportEntity report)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case ReportsInitial():
return initial();case ReportsLoading():
return loading();case ReportsLoaded():
return loaded(_that.report);case ReportsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( DashboardReportEntity report)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case ReportsInitial() when initial != null:
return initial();case ReportsLoading() when loading != null:
return loading();case ReportsLoaded() when loaded != null:
return loaded(_that.report);case ReportsError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ReportsInitial implements ReportsState {
  const ReportsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReportsState.initial()';
}


}




/// @nodoc


class ReportsLoading implements ReportsState {
  const ReportsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReportsState.loading()';
}


}




/// @nodoc


class ReportsLoaded implements ReportsState {
  const ReportsLoaded(this.report);
  

 final  DashboardReportEntity report;

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportsLoadedCopyWith<ReportsLoaded> get copyWith => _$ReportsLoadedCopyWithImpl<ReportsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportsLoaded&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode => Object.hash(runtimeType,report);

@override
String toString() {
  return 'ReportsState.loaded(report: $report)';
}


}

/// @nodoc
abstract mixin class $ReportsLoadedCopyWith<$Res> implements $ReportsStateCopyWith<$Res> {
  factory $ReportsLoadedCopyWith(ReportsLoaded value, $Res Function(ReportsLoaded) _then) = _$ReportsLoadedCopyWithImpl;
@useResult
$Res call({
 DashboardReportEntity report
});


$DashboardReportEntityCopyWith<$Res> get report;

}
/// @nodoc
class _$ReportsLoadedCopyWithImpl<$Res>
    implements $ReportsLoadedCopyWith<$Res> {
  _$ReportsLoadedCopyWithImpl(this._self, this._then);

  final ReportsLoaded _self;
  final $Res Function(ReportsLoaded) _then;

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? report = null,}) {
  return _then(ReportsLoaded(
null == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as DashboardReportEntity,
  ));
}

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardReportEntityCopyWith<$Res> get report {
  
  return $DashboardReportEntityCopyWith<$Res>(_self.report, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

/// @nodoc


class ReportsError implements ReportsState {
  const ReportsError(this.failure);
  

 final  Failure failure;

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportsErrorCopyWith<ReportsError> get copyWith => _$ReportsErrorCopyWithImpl<ReportsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ReportsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ReportsErrorCopyWith<$Res> implements $ReportsStateCopyWith<$Res> {
  factory $ReportsErrorCopyWith(ReportsError value, $Res Function(ReportsError) _then) = _$ReportsErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$ReportsErrorCopyWithImpl<$Res>
    implements $ReportsErrorCopyWith<$Res> {
  _$ReportsErrorCopyWithImpl(this._self, this._then);

  final ReportsError _self;
  final $Res Function(ReportsError) _then;

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ReportsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
