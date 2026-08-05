import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

/// Wire format for `App\Http\Resources\UserResource` (SRS §18.5). Mapping to
/// [UserEntity] happens once, at the Repository boundary, per Implementation
/// Plan §1.1 — `domain`/`presentation` never see this class.
@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required int id,
    required String nom,
    required String email,
    required String role,
    String? telephone,
    required bool actif,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}

extension UserDtoMapper on UserDto {
  UserEntity toEntity() => UserEntity(
    id: id,
    nom: nom,
    email: email,
    role: UserRoleX.fromApi(role),
    telephone: telephone,
    actif: actif,
  );
}
