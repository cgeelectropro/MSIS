import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// SRS §7 Actors / §18.3 `users`. Pure domain entity — no JSON/Dio here.
enum UserRole { admin, technicien, client }

extension UserRoleX on UserRole {
  static UserRole fromApi(String value) => switch (value) {
    'ADMIN' => UserRole.admin,
    'TECHNICIEN' => UserRole.technicien,
    'CLIENT' => UserRole.client,
    _ => throw ArgumentError('Unknown role: $value'),
  };

  String get apiValue => switch (this) {
    UserRole.admin => 'ADMIN',
    UserRole.technicien => 'TECHNICIEN',
    UserRole.client => 'CLIENT',
  };
}

@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required int id,
    required String nom,
    required String email,
    required UserRole role,
    String? telephone,
    required bool actif,
  }) = _UserEntity;
}
