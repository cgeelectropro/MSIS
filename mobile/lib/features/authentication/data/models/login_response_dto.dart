import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_dto.dart';

part 'login_response_dto.freezed.dart';
part 'login_response_dto.g.dart';

/// SRS §18.5: `POST /auth/login` -> {token, user}.
@freezed
abstract class LoginResponseDto with _$LoginResponseDto {
  const factory LoginResponseDto({required String token, required UserDto user}) =
      _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);
}
