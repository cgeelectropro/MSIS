import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/login_response_dto.dart';
import '../models/user_dto.dart';

/// Implementation Plan §6: talks to the API only; throws [DioException] on
/// failure, which the Repository catches and maps via `ErrorMapper`.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<LoginResponseDto> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password, 'role': role},
    );
    return LoginResponseDto.fromJson(response.data!);
  }

  Future<void> register({
    required String nom,
    required String email,
    required String password,
    String? telephone,
  }) => _dio.post<void>(
    ApiEndpoints.register,
    data: {
      'nom': nom,
      'email': email,
      'password': password,
      'password_confirmation': password,
      'telephone': ?telephone,
    },
  );

  Future<void> logout() => _dio.post<void>(ApiEndpoints.logout);

  Future<void> logoutAllDevices() => _dio.post<void>(ApiEndpoints.logoutAll);

  Future<void> forgotPassword(String email) =>
      _dio.post<void>(ApiEndpoints.forgotPassword, data: {'email': email});

  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
  }) => _dio.post<void>(
    ApiEndpoints.resetPassword,
    data: {
      'token': token,
      'email': email,
      'password': password,
      'password_confirmation': password,
    },
  );

  Future<UserDto> me() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.me);
    return UserDto.fromJson(response.data!['data'] as Map<String, dynamic>);
  }
}
