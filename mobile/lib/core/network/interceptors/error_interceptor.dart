import 'package:dio/dio.dart';

import '../../errors/failures.dart';

/// Implementation Plan §17: maps Dio errors / SRS §18.5 HTTP status codes into
/// domain Failures at the data-layer boundary. This is a mapper, not a literal
/// `Interceptor`, since a Failure must be returned to the calling Repository —
/// Repositories call `ErrorMapper.map(e)` inside their `catch (DioException e)`.
class ErrorMapper {
  ErrorMapper._();

  static Failure map(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }

    final status = e.response?.statusCode ?? 0;
    final body = e.response?.data;

    return switch (status) {
      401 => const AuthFailure(),
      403 => const ForbiddenFailure(),
      404 => const NotFoundFailure(),
      422 => _mapValidation(body),
      429 => const RateLimitedFailure(),
      >= 500 => const ServerFailure(),
      _ => const UnknownFailure(),
    };
  }

  static ValidationFailure _mapValidation(dynamic body) {
    final message = (body is Map && body['message'] is String)
        ? body['message'] as String
        : 'Les données fournies sont invalides.';

    final rawErrors = (body is Map && body['errors'] is Map) ? body['errors'] as Map : const {};

    final fieldErrors = rawErrors.map(
      (key, value) => MapEntry(key.toString(), (value as List).map((e) => e.toString()).toList()),
    );

    return ValidationFailure(message, fieldErrors);
  }
}
