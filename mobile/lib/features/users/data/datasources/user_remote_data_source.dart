import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../authentication/data/models/user_dto.dart';

class UserRemoteDataSource {
  UserRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<UserDto>> list({String? role, String? search}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.users,
      queryParameters: {'role': ?role, 'search': ?search},
    );
    final data = response.data!['data'] as List;
    return data.map((e) => UserDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<UserDto> createTechnician({required String nom, required String email, String? telephone}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.users,
      data: {'nom': nom, 'email': email, 'telephone': ?telephone},
    );
    return UserDto.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<UserDto> updateStatus({required int userId, required bool actif}) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.userStatus(userId),
      data: {'actif': actif},
    );
    return UserDto.fromJson(response.data!['data'] as Map<String, dynamic>);
  }
}
