// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationEntity {

 int get id; String get type; String get contenu; int? get idIntervention; bool get lu; DateTime get createdAt;
/// Create a copy of NotificationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationEntityCopyWith<NotificationEntity> get copyWith => _$NotificationEntityCopyWithImpl<NotificationEntity>(this as NotificationEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.contenu, contenu) || other.contenu == contenu)&&(identical(other.idIntervention, idIntervention) || other.idIntervention == idIntervention)&&(identical(other.lu, lu) || other.lu == lu)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,contenu,idIntervention,lu,createdAt);

@override
String toString() {
  return 'NotificationEntity(id: $id, type: $type, contenu: $contenu, idIntervention: $idIntervention, lu: $lu, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $NotificationEntityCopyWith<$Res>  {
  factory $NotificationEntityCopyWith(NotificationEntity value, $Res Function(NotificationEntity) _then) = _$NotificationEntityCopyWithImpl;
@useResult
$Res call({
 int id, String type, String contenu, int? idIntervention, bool lu, DateTime createdAt
});




}
/// @nodoc
class _$NotificationEntityCopyWithImpl<$Res>
    implements $NotificationEntityCopyWith<$Res> {
  _$NotificationEntityCopyWithImpl(this._self, this._then);

  final NotificationEntity _self;
  final $Res Function(NotificationEntity) _then;

/// Create a copy of NotificationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? contenu = null,Object? idIntervention = freezed,Object? lu = null,Object? createdAt = null,}) {
  return _then(NotificationEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,idIntervention: freezed == idIntervention ? _self.idIntervention : idIntervention // ignore: cast_nullable_to_non_nullable
as int?,lu: null == lu ? _self.lu : lu // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationEntity].
extension NotificationEntityPatterns on NotificationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationEntity value)  $default,){
final _that = this;
switch (_that) {
case _NotificationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String type,  String contenu,  int? idIntervention,  bool lu,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationEntity() when $default != null:
return $default(_that.id,_that.type,_that.contenu,_that.idIntervention,_that.lu,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String type,  String contenu,  int? idIntervention,  bool lu,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationEntity():
return $default(_that.id,_that.type,_that.contenu,_that.idIntervention,_that.lu,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String type,  String contenu,  int? idIntervention,  bool lu,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationEntity() when $default != null:
return $default(_that.id,_that.type,_that.contenu,_that.idIntervention,_that.lu,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationEntity implements NotificationEntity {
  const _NotificationEntity({required this.id, required this.type, required this.contenu, this.idIntervention, required this.lu, required this.createdAt});
  

@override final  int id;
@override final  String type;
@override final  String contenu;
@override final  int? idIntervention;
@override final  bool lu;
@override final  DateTime createdAt;

/// Create a copy of NotificationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationEntityCopyWith<_NotificationEntity> get copyWith => __$NotificationEntityCopyWithImpl<_NotificationEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.contenu, contenu) || other.contenu == contenu)&&(identical(other.idIntervention, idIntervention) || other.idIntervention == idIntervention)&&(identical(other.lu, lu) || other.lu == lu)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,contenu,idIntervention,lu,createdAt);

@override
String toString() {
  return 'NotificationEntity(id: $id, type: $type, contenu: $contenu, idIntervention: $idIntervention, lu: $lu, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationEntityCopyWith<$Res> implements $NotificationEntityCopyWith<$Res> {
  factory _$NotificationEntityCopyWith(_NotificationEntity value, $Res Function(_NotificationEntity) _then) = __$NotificationEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String type, String contenu, int? idIntervention, bool lu, DateTime createdAt
});




}
/// @nodoc
class __$NotificationEntityCopyWithImpl<$Res>
    implements _$NotificationEntityCopyWith<$Res> {
  __$NotificationEntityCopyWithImpl(this._self, this._then);

  final _NotificationEntity _self;
  final $Res Function(_NotificationEntity) _then;

/// Create a copy of NotificationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? contenu = null,Object? idIntervention = freezed,Object? lu = null,Object? createdAt = null,}) {
  return _then(_NotificationEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,idIntervention: freezed == idIntervention ? _self.idIntervention : idIntervention // ignore: cast_nullable_to_non_nullable
as int?,lu: null == lu ? _self.lu : lu // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
