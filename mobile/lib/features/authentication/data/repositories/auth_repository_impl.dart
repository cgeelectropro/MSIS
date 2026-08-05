import 'package:dio/dio.dart';

import '../../../../core/network/interceptors/error_interceptor.dart';
import '../../../../core/storage/auth_session_store.dart';
import '../../../../core/storage/secure_token_storage.dart';
import '../../../../shared/models/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._remote,
    required this._tokenStorage,
    required this._sessionStore,
  });

  final AuthRemoteDataSource _remote;
  final SecureTokenStorage _tokenStorage;
  final AuthSessionStore _sessionStore;

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final response = await _remote.login(
        email: email,
        password: password,
        role: role.apiValue,
      );
      await _tokenStorage.saveToken(response.token);
      _sessionStore.setAuthenticated(response.user.role);
      return Result.success(response.user.toEntity());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<void>> register({
    required String nom,
    required String email,
    required String password,
    String? telephone,
  }) async {
    try {
      await _remote.register(nom: nom, email: email, password: password, telephone: telephone);
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remote.logout();
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    } finally {
      await _tokenStorage.clear();
      _sessionStore.clear();
    }
  }

  @override
  Future<Result<void>> logoutAllDevices() async {
    try {
      await _remote.logoutAllDevices();
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    } finally {
      await _tokenStorage.clear();
      _sessionStore.clear();
    }
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      await _remote.forgotPassword(email);
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String email,
    required String password,
  }) async {
    try {
      await _remote.resetPassword(token: token, email: email, password: password);
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    try {
      final dto = await _remote.me();
      _sessionStore.setAuthenticated(dto.role);
      return Result.success(dto.toEntity());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<bool> hasStoredSession() async {
    final token = await _tokenStorage.readToken();
    return token != null;
  }
}
