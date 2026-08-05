import 'package:dio/dio.dart';

import '../../constants/api_endpoints.dart';
import '../../storage/secure_token_storage.dart';

/// Implementation Plan §13 / SRS §17.4 SEC-22: on a 401, attempt exactly one
/// `/auth/refresh` (revoke-and-reissue) call and retry the original request.
/// A second failure clears the session and notifies [onSessionExpired] —
/// deliberately decoupled from GoRouter/Riverpod so this stays a pure
/// networking concern; the DI wiring supplies the redirect-to-login callback.
class RefreshInterceptor extends Interceptor {
  RefreshInterceptor({
    required this._dio,
    required this._tokenStorage,
    required this._onSessionExpired,
  });

  final Dio _dio;
  final SecureTokenStorage _tokenStorage;
  final Future<void> Function() _onSessionExpired;
  bool _isRefreshing = false;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isRefreshCall = err.requestOptions.path.contains(ApiEndpoints.refresh);
    final alreadyRetried = err.requestOptions.extra['retried'] == true;

    if (!isUnauthorized || isRefreshCall || alreadyRetried || _isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;
    try {
      final refreshResponse = await _dio.post<Map<String, dynamic>>(ApiEndpoints.refresh);
      final newToken = refreshResponse.data?['token'] as String?;

      if (newToken == null) {
        await _handleSessionExpired(handler, err);
        return;
      }

      await _tokenStorage.saveToken(newToken);

      final retryOptions = err.requestOptions;
      retryOptions.extra['retried'] = true;
      retryOptions.headers['Authorization'] = 'Bearer $newToken';

      final retryResponse = await _dio.fetch(retryOptions);
      handler.resolve(retryResponse);
    } on DioException {
      await _handleSessionExpired(handler, err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _handleSessionExpired(ErrorInterceptorHandler handler, DioException err) async {
    await _tokenStorage.clear();
    await _onSessionExpired();
    handler.next(err);
  }
}
