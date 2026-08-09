// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intervention_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InterventionEntity {

 int get id; String get titre; String get description; InterventionStatus get statut; InterventionPriority get priorite; int get idClient; int? get idTechnicien; UserEntity? get client; UserEntity? get technicien; String? get motifBlocage; String? get rapportTechnique; int? get noteSatisfaction; DateTime? get dateCloture; DateTime get createdAt; List<AttachmentEntity> get attachments;
/// Create a copy of InterventionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterventionEntityCopyWith<InterventionEntity> get copyWith => _$InterventionEntityCopyWithImpl<InterventionEntity>(this as InterventionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterventionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.titre, titre) || other.titre == titre)&&(identical(other.description, description) || other.description == description)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.priorite, priorite) || other.priorite == priorite)&&(identical(other.idClient, idClient) || other.idClient == idClient)&&(identical(other.idTechnicien, idTechnicien) || other.idTechnicien == idTechnicien)&&(identical(other.client, client) || other.client == client)&&(identical(other.technicien, technicien) || other.technicien == technicien)&&(identical(other.motifBlocage, motifBlocage) || other.motifBlocage == motifBlocage)&&(identical(other.rapportTechnique, rapportTechnique) || other.rapportTechnique == rapportTechnique)&&(identical(other.noteSatisfaction, noteSatisfaction) || other.noteSatisfaction == noteSatisfaction)&&(identical(other.dateCloture, dateCloture) || other.dateCloture == dateCloture)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.attachments, attachments));
}


@override
int get hashCode => Object.hash(runtimeType,id,titre,description,statut,priorite,idClient,idTechnicien,client,technicien,motifBlocage,rapportTechnique,noteSatisfaction,dateCloture,createdAt,const DeepCollectionEquality().hash(attachments));

@override
String toString() {
  return 'InterventionEntity(id: $id, titre: $titre, description: $description, statut: $statut, priorite: $priorite, idClient: $idClient, idTechnicien: $idTechnicien, client: $client, technicien: $technicien, motifBlocage: $motifBlocage, rapportTechnique: $rapportTechnique, noteSatisfaction: $noteSatisfaction, dateCloture: $dateCloture, createdAt: $createdAt, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class $InterventionEntityCopyWith<$Res>  {
  factory $InterventionEntityCopyWith(InterventionEntity value, $Res Function(InterventionEntity) _then) = _$InterventionEntityCopyWithImpl;
@useResult
$Res call({
 int id, String titre, String description, InterventionStatus statut, InterventionPriority priorite, int idClient, int? idTechnicien, UserEntity? client, UserEntity? technicien, String? motifBlocage, String? rapportTechnique, int? noteSatisfaction, DateTime? dateCloture, DateTime createdAt, List<AttachmentEntity> attachments
});


$UserEntityCopyWith<$Res>? get client;$UserEntityCopyWith<$Res>? get technicien;

}
/// @nodoc
class _$InterventionEntityCopyWithImpl<$Res>
    implements $InterventionEntityCopyWith<$Res> {
  _$InterventionEntityCopyWithImpl(this._self, this._then);

  final InterventionEntity _self;
  final $Res Function(InterventionEntity) _then;

/// Create a copy of InterventionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titre = null,Object? description = null,Object? statut = null,Object? priorite = null,Object? idClient = null,Object? idTechnicien = freezed,Object? client = freezed,Object? technicien = freezed,Object? motifBlocage = freezed,Object? rapportTechnique = freezed,Object? noteSatisfaction = freezed,Object? dateCloture = freezed,Object? createdAt = null,Object? attachments = null,}) {
  return _then(InterventionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as InterventionStatus,priorite: null == priorite ? _self.priorite : priorite // ignore: cast_nullable_to_non_nullable
as InterventionPriority,idClient: null == idClient ? _self.idClient : idClient // ignore: cast_nullable_to_non_nullable
as int,idTechnicien: freezed == idTechnicien ? _self.idTechnicien : idTechnicien // ignore: cast_nullable_to_non_nullable
as int?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as UserEntity?,technicien: freezed == technicien ? _self.technicien : technicien // ignore: cast_nullable_to_non_nullable
as UserEntity?,motifBlocage: freezed == motifBlocage ? _self.motifBlocage : motifBlocage // ignore: cast_nullable_to_non_nullable
as String?,rapportTechnique: freezed == rapportTechnique ? _self.rapportTechnique : rapportTechnique // ignore: cast_nullable_to_non_nullable
as String?,noteSatisfaction: freezed == noteSatisfaction ? _self.noteSatisfaction : noteSatisfaction // ignore: cast_nullable_to_non_nullable
as int?,dateCloture: freezed == dateCloture ? _self.dateCloture : dateCloture // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<AttachmentEntity>,
  ));
}
/// Create a copy of InterventionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserEntityCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $UserEntityCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of InterventionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserEntityCopyWith<$Res>? get technicien {
    if (_self.technicien == null) {
    return null;
  }

  return $UserEntityCopyWith<$Res>(_self.technicien!, (value) {
    return _then(_self.copyWith(technicien: value));
  });
}
}


/// Adds pattern-matching-related methods to [InterventionEntity].
extension InterventionEntityPatterns on InterventionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InterventionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InterventionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InterventionEntity value)  $default,){
final _that = this;
switch (_that) {
case _InterventionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InterventionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _InterventionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String titre,  String description,  InterventionStatus statut,  InterventionPriority priorite,  int idClient,  int? idTechnicien,  UserEntity? client,  UserEntity? technicien,  String? motifBlocage,  String? rapportTechnique,  int? noteSatisfaction,  DateTime? dateCloture,  DateTime createdAt,  List<AttachmentEntity> attachments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InterventionEntity() when $default != null:
return $default(_that.id,_that.titre,_that.description,_that.statut,_that.priorite,_that.idClient,_that.idTechnicien,_that.client,_that.technicien,_that.motifBlocage,_that.rapportTechnique,_that.noteSatisfaction,_that.dateCloture,_that.createdAt,_that.attachments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String titre,  String description,  InterventionStatus statut,  InterventionPriority priorite,  int idClient,  int? idTechnicien,  UserEntity? client,  UserEntity? technicien,  String? motifBlocage,  String? rapportTechnique,  int? noteSatisfaction,  DateTime? dateCloture,  DateTime createdAt,  List<AttachmentEntity> attachments)  $default,) {final _that = this;
switch (_that) {
case _InterventionEntity():
return $default(_that.id,_that.titre,_that.description,_that.statut,_that.priorite,_that.idClient,_that.idTechnicien,_that.client,_that.technicien,_that.motifBlocage,_that.rapportTechnique,_that.noteSatisfaction,_that.dateCloture,_that.createdAt,_that.attachments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String titre,  String description,  InterventionStatus statut,  InterventionPriority priorite,  int idClient,  int? idTechnicien,  UserEntity? client,  UserEntity? technicien,  String? motifBlocage,  String? rapportTechnique,  int? noteSatisfaction,  DateTime? dateCloture,  DateTime createdAt,  List<AttachmentEntity> attachments)?  $default,) {final _that = this;
switch (_that) {
case _InterventionEntity() when $default != null:
return $default(_that.id,_that.titre,_that.description,_that.statut,_that.priorite,_that.idClient,_that.idTechnicien,_that.client,_that.technicien,_that.motifBlocage,_that.rapportTechnique,_that.noteSatisfaction,_that.dateCloture,_that.createdAt,_that.attachments);case _:
  return null;

}
}

}

/// @nodoc


class _InterventionEntity implements InterventionEntity {
  const _InterventionEntity({required this.id, required this.titre, required this.description, required this.statut, required this.priorite, required this.idClient, this.idTechnicien, this.client, this.technicien, this.motifBlocage, this.rapportTechnique, this.noteSatisfaction, this.dateCloture, required this.createdAt,  List<AttachmentEntity> attachments = const []}): _attachments = attachments;
  

@override final  int id;
@override final  String titre;
@override final  String description;
@override final  InterventionStatus statut;
@override final  InterventionPriority priorite;
@override final  int idClient;
@override final  int? idTechnicien;
@override final  UserEntity? client;
@override final  UserEntity? technicien;
@override final  String? motifBlocage;
@override final  String? rapportTechnique;
@override final  int? noteSatisfaction;
@override final  DateTime? dateCloture;
@override final  DateTime createdAt;
 final  List<AttachmentEntity> _attachments;
@override@JsonKey() List<AttachmentEntity> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}


/// Create a copy of InterventionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterventionEntityCopyWith<_InterventionEntity> get copyWith => __$InterventionEntityCopyWithImpl<_InterventionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InterventionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.titre, titre) || other.titre == titre)&&(identical(other.description, description) || other.description == description)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.priorite, priorite) || other.priorite == priorite)&&(identical(other.idClient, idClient) || other.idClient == idClient)&&(identical(other.idTechnicien, idTechnicien) || other.idTechnicien == idTechnicien)&&(identical(other.client, client) || other.client == client)&&(identical(other.technicien, technicien) || other.technicien == technicien)&&(identical(other.motifBlocage, motifBlocage) || other.motifBlocage == motifBlocage)&&(identical(other.rapportTechnique, rapportTechnique) || other.rapportTechnique == rapportTechnique)&&(identical(other.noteSatisfaction, noteSatisfaction) || other.noteSatisfaction == noteSatisfaction)&&(identical(other.dateCloture, dateCloture) || other.dateCloture == dateCloture)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._attachments, _attachments));
}


@override
int get hashCode => Object.hash(runtimeType,id,titre,description,statut,priorite,idClient,idTechnicien,client,technicien,motifBlocage,rapportTechnique,noteSatisfaction,dateCloture,createdAt,const DeepCollectionEquality().hash(_attachments));

@override
String toString() {
  return 'InterventionEntity(id: $id, titre: $titre, description: $description, statut: $statut, priorite: $priorite, idClient: $idClient, idTechnicien: $idTechnicien, client: $client, technicien: $technicien, motifBlocage: $motifBlocage, rapportTechnique: $rapportTechnique, noteSatisfaction: $noteSatisfaction, dateCloture: $dateCloture, createdAt: $createdAt, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class _$InterventionEntityCopyWith<$Res> implements $InterventionEntityCopyWith<$Res> {
  factory _$InterventionEntityCopyWith(_InterventionEntity value, $Res Function(_InterventionEntity) _then) = __$InterventionEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String titre, String description, InterventionStatus statut, InterventionPriority priorite, int idClient, int? idTechnicien, UserEntity? client, UserEntity? technicien, String? motifBlocage, String? rapportTechnique, int? noteSatisfaction, DateTime? dateCloture, DateTime createdAt, List<AttachmentEntity> attachments
});


@override $UserEntityCopyWith<$Res>? get client;@override $UserEntityCopyWith<$Res>? get technicien;

}
/// @nodoc
class __$InterventionEntityCopyWithImpl<$Res>
    implements _$InterventionEntityCopyWith<$Res> {
  __$InterventionEntityCopyWithImpl(this._self, this._then);

  final _InterventionEntity _self;
  final $Res Function(_InterventionEntity) _then;

/// Create a copy of InterventionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titre = null,Object? description = null,Object? statut = null,Object? priorite = null,Object? idClient = null,Object? idTechnicien = freezed,Object? client = freezed,Object? technicien = freezed,Object? motifBlocage = freezed,Object? rapportTechnique = freezed,Object? noteSatisfaction = freezed,Object? dateCloture = freezed,Object? createdAt = null,Object? attachments = null,}) {
  return _then(_InterventionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as InterventionStatus,priorite: null == priorite ? _self.priorite : priorite // ignore: cast_nullable_to_non_nullable
as InterventionPriority,idClient: null == idClient ? _self.idClient : idClient // ignore: cast_nullable_to_non_nullable
as int,idTechnicien: freezed == idTechnicien ? _self.idTechnicien : idTechnicien // ignore: cast_nullable_to_non_nullable
as int?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as UserEntity?,technicien: freezed == technicien ? _self.technicien : technicien // ignore: cast_nullable_to_non_nullable
as UserEntity?,motifBlocage: freezed == motifBlocage ? _self.motifBlocage : motifBlocage // ignore: cast_nullable_to_non_nullable
as String?,rapportTechnique: freezed == rapportTechnique ? _self.rapportTechnique : rapportTechnique // ignore: cast_nullable_to_non_nullable
as String?,noteSatisfaction: freezed == noteSatisfaction ? _self.noteSatisfaction : noteSatisfaction // ignore: cast_nullable_to_non_nullable
as int?,dateCloture: freezed == dateCloture ? _self.dateCloture : dateCloture // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<AttachmentEntity>,
  ));
}

/// Create a copy of InterventionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserEntityCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $UserEntityCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of InterventionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserEntityCopyWith<$Res>? get technicien {
    if (_self.technicien == null) {
    return null;
  }

  return $UserEntityCopyWith<$Res>(_self.technicien!, (value) {
    return _then(_self.copyWith(technicien: value));
  });
}
}

// dart format on
