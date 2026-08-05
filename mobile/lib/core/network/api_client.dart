import 'package:dio/dio.dart';

import '../config/env.dart';
import '../storage/secure_token_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/refresh_interceptor.dart';

/// Implementation Plan §11: one shared Dio instance for the whole app, built
/// once by `core/di/injector.dart` and injected into every feature's
/// RemoteDataSource — no feature constructs its own Dio.
class ApiClient {
  static Dio build({
    required SecureTokenStorage tokenStorage,
    required Future<void> Function() onSessionExpired,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(tokenStorage),
      RefreshInterceptor(dio: dio, tokenStorage: tokenStorage, onSessionExpired: onSessionExpired),
      LoggingInterceptor(),
    ]);

    return dio;
  }
}
