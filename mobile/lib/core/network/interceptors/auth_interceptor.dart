import 'package:dio/dio.dart';

import '../../storage/secure_token_storage.dart';

/// Implementation Plan §13 — attaches the bearer token to every request.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final SecureTokenStorage _tokenStorage;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.readToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
