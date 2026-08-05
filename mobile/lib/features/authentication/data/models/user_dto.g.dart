// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
  id: (json['id'] as num).toInt(),
  nom: json['nom'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  telephone: json['telephone'] as String?,
  actif: json['actif'] as bool,
);

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'nom': instance.nom,
  'email': instance.email,
  'role': instance.role,
  'telephone': instance.telephone,
  'actif': instance.actif,
};
