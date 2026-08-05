// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intervention_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InterventionDto {

@JsonKey(name: 'id_intervention') int get idIntervention; String get titre; String get description; String get statut; String get priorite;@JsonKey(name: 'id_client') int get idClient;@JsonKey(name: 'id_technicien') int? get idTechnicien; UserDto? get client; UserDto? get technicien;@JsonKey(name: 'motif_blocage') String? get motifBlocage;@JsonKey(name: 'rapport_technique') String? get rapportTechnique;@JsonKey(name: 'note_satisfaction') int? get noteSatisfaction;@JsonKey(name: 'date_cloture') DateTime? get dateCloture;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of InterventionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterventionDtoCopyWith<InterventionDto> get copyWith => _$InterventionDtoCopyWithImpl<InterventionDto>(this as InterventionDto, _$identity);

  /// Serializes this InterventionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterventionDto&&(identical(other.idIntervention, idIntervention) || other.idIntervention == idIntervention)&&(identical(other.titre, titre) || other.titre == titre)&&(identical(other.description, description) || other.description == description)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.priorite, priorite) || other.priorite == priorite)&&(identical(other.idClient, idClient) || other.idClient == idClient)&&(identical(other.idTechnicien, idTechnicien) || other.idTechnicien == idTechnicien)&&(identical(other.client, client) || other.client == client)&&(identical(other.technicien, technicien) || other.technicien == technicien)&&(identical(other.motifBlocage, motifBlocage) || other.motifBlocage == motifBlocage)&&(identical(other.rapportTechnique, rapportTechnique) || other.rapportTechnique == rapportTechnique)&&(identical(other.noteSatisfaction, noteSatisfaction) || other.noteSatisfaction == noteSatisfaction)&&(identical(other.dateCloture, dateCloture) || other.dateCloture == dateCloture)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idIntervention,titre,description,statut,priorite,idClient,idTechnicien,client,technicien,motifBlocage,rapportTechnique,noteSatisfaction,dateCloture,createdAt);

@override
String toString() {
  return 'InterventionDto(idIntervention: $idIntervention, titre: $titre, description: $description, statut: $statut, priorite: $priorite, idClient: $idClient, idTechnicien: $idTechnicien, client: $client, technicien: $technicien, motifBlocage: $motifBlocage, rapportTechnique: $rapportTechnique, noteSatisfaction: $noteSatisfaction, dateCloture: $dateCloture, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $InterventionDtoCopyWith<$Res>  {
  factory $InterventionDtoCopyWith(InterventionDto value, $Res Function(InterventionDto) _then) = _$InterventionDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id_intervention') int idIntervention, String titre, String description, String statut, String priorite,@JsonKey(name: 'id_client') int idClient,@JsonKey(name: 'id_technicien') int? idTechnicien, UserDto? client, UserDto? technicien,@JsonKey(name: 'motif_blocage') String? motifBlocage,@JsonKey(name: 'rapport_technique') String? rapportTechnique,@JsonKey(name: 'note_satisfaction') int? noteSatisfaction,@JsonKey(name: 'date_cloture') DateTime? dateCloture,@JsonKey(name: 'created_at') DateTime createdAt
});


$UserDtoCopyWith<$Res>? get client;$UserDtoCopyWith<$Res>? get technicien;

}
/// @nodoc
class _$InterventionDtoCopyWithImpl<$Res>
    implements $InterventionDtoCopyWith<$Res> {
  _$InterventionDtoCopyWithImpl(this._self, this._then);

  final InterventionDto _self;
  final $Res Function(InterventionDto) _then;

/// Create a copy of InterventionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idIntervention = null,Object? titre = null,Object? description = null,Object? statut = null,Object? priorite = null,Object? idClient = null,Object? idTechnicien = freezed,Object? client = freezed,Object? technicien = freezed,Object? motifBlocage = freezed,Object? rapportTechnique = freezed,Object? noteSatisfaction = freezed,Object? dateCloture = freezed,Object? createdAt = null,}) {
  return _then(InterventionDto(
idIntervention: null == idIntervention ? _self.idIntervention : idIntervention // ignore: cast_nullable_to_non_nullable
as int,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,priorite: null == priorite ? _self.priorite : priorite // ignore: cast_nullable_to_non_nullable
as String,idClient: null == idClient ? _self.idClient : idClient // ignore: cast_nullable_to_non_nullable
as int,idTechnicien: freezed == idTechnicien ? _self.idTechnicien : idTechnicien // ignore: cast_nullable_to_non_nullable
as int?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as UserDto?,technicien: freezed == technicien ? _self.technicien : technicien // ignore: cast_nullable_to_non_nullable
as UserDto?,motifBlocage: freezed == motifBlocage ? _self.motifBlocage : motifBlocage // ignore: cast_nullable_to_non_nullable
as String?,rapportTechnique: freezed == rapportTechnique ? _self.rapportTechnique : rapportTechnique // ignore: cast_nullable_to_non_nullable
as String?,noteSatisfaction: freezed == noteSatisfaction ? _self.noteSatisfaction : noteSatisfaction // ignore: cast_nullable_to_non_nullable
as int?,dateCloture: freezed == dateCloture ? _self.dateCloture : dateCloture // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of InterventionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $UserDtoCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of InterventionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res>? get technicien {
    if (_self.technicien == null) {
    return null;
  }

  return $UserDtoCopyWith<$Res>(_self.technicien!, (value) {
    return _then(_self.copyWith(technicien: value));
  });
}
}


/// Adds pattern-matching-related methods to [InterventionDto].
extension InterventionDtoPatterns on InterventionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InterventionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InterventionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InterventionDto value)  $default,){
final _that = this;
switch (_that) {
case _InterventionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InterventionDto value)?  $default,){
final _that = this;
switch (_that) {
case _InterventionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_intervention')  int idIntervention,  String titre,  String description,  String statut,  String priorite, @JsonKey(name: 'id_client')  int idClient, @JsonKey(name: 'id_technicien')  int? idTechnicien,  UserDto? client,  UserDto? technicien, @JsonKey(name: 'motif_blocage')  String? motifBlocage, @JsonKey(name: 'rapport_technique')  String? rapportTechnique, @JsonKey(name: 'note_satisfaction')  int? noteSatisfaction, @JsonKey(name: 'date_cloture')  DateTime? dateCloture, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InterventionDto() when $default != null:
return $default(_that.idIntervention,_that.titre,_that.description,_that.statut,_that.priorite,_that.idClient,_that.idTechnicien,_that.client,_that.technicien,_that.motifBlocage,_that.rapportTechnique,_that.noteSatisfaction,_that.dateCloture,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_intervention')  int idIntervention,  String titre,  String description,  String statut,  String priorite, @JsonKey(name: 'id_client')  int idClient, @JsonKey(name: 'id_technicien')  int? idTechnicien,  UserDto? client,  UserDto? technicien, @JsonKey(name: 'motif_blocage')  String? motifBlocage, @JsonKey(name: 'rapport_technique')  String? rapportTechnique, @JsonKey(name: 'note_satisfaction')  int? noteSatisfaction, @JsonKey(name: 'date_cloture')  DateTime? dateCloture, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _InterventionDto():
return $default(_that.idIntervention,_that.titre,_that.description,_that.statut,_that.priorite,_that.idClient,_that.idTechnicien,_that.client,_that.technicien,_that.motifBlocage,_that.rapportTechnique,_that.noteSatisfaction,_that.dateCloture,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id_intervention')  int idIntervention,  String titre,  String description,  String statut,  String priorite, @JsonKey(name: 'id_client')  int idClient, @JsonKey(name: 'id_technicien')  int? idTechnicien,  UserDto? client,  UserDto? technicien, @JsonKey(name: 'motif_blocage')  String? motifBlocage, @JsonKey(name: 'rapport_technique')  String? rapportTechnique, @JsonKey(name: 'note_satisfaction')  int? noteSatisfaction, @JsonKey(name: 'date_cloture')  DateTime? dateCloture, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _InterventionDto() when $default != null:
return $default(_that.idIntervention,_that.titre,_that.description,_that.statut,_that.priorite,_that.idClient,_that.idTechnicien,_that.client,_that.technicien,_that.motifBlocage,_that.rapportTechnique,_that.noteSatisfaction,_that.dateCloture,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InterventionDto implements InterventionDto {
  const _InterventionDto({@JsonKey(name: 'id_intervention') required this.idIntervention, required this.titre, required this.description, required this.statut, required this.priorite, @JsonKey(name: 'id_client') required this.idClient, @JsonKey(name: 'id_technicien') this.idTechnicien, this.client, this.technicien, @JsonKey(name: 'motif_blocage') this.motifBlocage, @JsonKey(name: 'rapport_technique') this.rapportTechnique, @JsonKey(name: 'note_satisfaction') this.noteSatisfaction, @JsonKey(name: 'date_cloture') this.dateCloture, @JsonKey(name: 'created_at') required this.createdAt});
  factory _InterventionDto.fromJson(Map<String, dynamic> json) => _$InterventionDtoFromJson(json);

@override@JsonKey(name: 'id_intervention') final  int idIntervention;
@override final  String titre;
@override final  String description;
@override final  String statut;
@override final  String priorite;
@override@JsonKey(name: 'id_client') final  int idClient;
@override@JsonKey(name: 'id_technicien') final  int? idTechnicien;
@override final  UserDto? client;
@override final  UserDto? technicien;
@override@JsonKey(name: 'motif_blocage') final  String? motifBlocage;
@override@JsonKey(name: 'rapport_technique') final  String? rapportTechnique;
@override@JsonKey(name: 'note_satisfaction') final  int? noteSatisfaction;
@override@JsonKey(name: 'date_cloture') final  DateTime? dateCloture;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of InterventionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterventionDtoCopyWith<_InterventionDto> get copyWith => __$InterventionDtoCopyWithImpl<_InterventionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InterventionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InterventionDto&&(identical(other.idIntervention, idIntervention) || other.idIntervention == idIntervention)&&(identical(other.titre, titre) || other.titre == titre)&&(identical(other.description, description) || other.description == description)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.priorite, priorite) || other.priorite == priorite)&&(identical(other.idClient, idClient) || other.idClient == idClient)&&(identical(other.idTechnicien, idTechnicien) || other.idTechnicien == idTechnicien)&&(identical(other.client, client) || other.client == client)&&(identical(other.technicien, technicien) || other.technicien == technicien)&&(identical(other.motifBlocage, motifBlocage) || other.motifBlocage == motifBlocage)&&(identical(other.rapportTechnique, rapportTechnique) || other.rapportTechnique == rapportTechnique)&&(identical(other.noteSatisfaction, noteSatisfaction) || other.noteSatisfaction == noteSatisfaction)&&(identical(other.dateCloture, dateCloture) || other.dateCloture == dateCloture)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idIntervention,titre,description,statut,priorite,idClient,idTechnicien,client,technicien,motifBlocage,rapportTechnique,noteSatisfaction,dateCloture,createdAt);

@override
String toString() {
  return 'InterventionDto(idIntervention: $idIntervention, titre: $titre, description: $description, statut: $statut, priorite: $priorite, idClient: $idClient, idTechnicien: $idTechnicien, client: $client, technicien: $technicien, motifBlocage: $motifBlocage, rapportTechnique: $rapportTechnique, noteSatisfaction: $noteSatisfaction, dateCloture: $dateCloture, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$InterventionDtoCopyWith<$Res> implements $InterventionDtoCopyWith<$Res> {
  factory _$InterventionDtoCopyWith(_InterventionDto value, $Res Function(_InterventionDto) _then) = __$InterventionDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id_intervention') int idIntervention, String titre, String description, String statut, String priorite,@JsonKey(name: 'id_client') int idClient,@JsonKey(name: 'id_technicien') int? idTechnicien, UserDto? client, UserDto? technicien,@JsonKey(name: 'motif_blocage') String? motifBlocage,@JsonKey(name: 'rapport_technique') String? rapportTechnique,@JsonKey(name: 'note_satisfaction') int? noteSatisfaction,@JsonKey(name: 'date_cloture') DateTime? dateCloture,@JsonKey(name: 'created_at') DateTime createdAt
});


@override $UserDtoCopyWith<$Res>? get client;@override $UserDtoCopyWith<$Res>? get technicien;

}
/// @nodoc
class __$InterventionDtoCopyWithImpl<$Res>
    implements _$InterventionDtoCopyWith<$Res> {
  __$InterventionDtoCopyWithImpl(this._self, this._then);

  final _InterventionDto _self;
  final $Res Function(_InterventionDto) _then;

/// Create a copy of InterventionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idIntervention = null,Object? titre = null,Object? description = null,Object? statut = null,Object? priorite = null,Object? idClient = null,Object? idTechnicien = freezed,Object? client = freezed,Object? technicien = freezed,Object? motifBlocage = freezed,Object? rapportTechnique = freezed,Object? noteSatisfaction = freezed,Object? dateCloture = freezed,Object? createdAt = null,}) {
  return _then(_InterventionDto(
idIntervention: null == idIntervention ? _self.idIntervention : idIntervention // ignore: cast_nullable_to_non_nullable
as int,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,priorite: null == priorite ? _self.priorite : priorite // ignore: cast_nullable_to_non_nullable
as String,idClient: null == idClient ? _self.idClient : idClient // ignore: cast_nullable_to_non_nullable
as int,idTechnicien: freezed == idTechnicien ? _self.idTechnicien : idTechnicien // ignore: cast_nullable_to_non_nullable
as int?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as UserDto?,technicien: freezed == technicien ? _self.technicien : technicien // ignore: cast_nullable_to_non_nullable
as UserDto?,motifBlocage: freezed == motifBlocage ? _self.motifBlocage : motifBlocage // ignore: cast_nullable_to_non_nullable
as String?,rapportTechnique: freezed == rapportTechnique ? _self.rapportTechnique : rapportTechnique // ignore: cast_nullable_to_non_nullable
as String?,noteSatisfaction: freezed == noteSatisfaction ? _self.noteSatisfaction : noteSatisfaction // ignore: cast_nullable_to_non_nullable
as int?,dateCloture: freezed == dateCloture ? _self.dateCloture : dateCloture // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of InterventionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $UserDtoCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of InterventionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res>? get technicien {
    if (_self.technicien == null) {
    return null;
  }

  return $UserDtoCopyWith<$Res>(_self.technicien!, (value) {
    return _then(_self.copyWith(technicien: value));
  });
}
}

// dart format on
