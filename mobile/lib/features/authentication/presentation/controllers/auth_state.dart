import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

/// SRS §16.5 loading/error/success states, made explicit rather than a
/// boolean-flag soup (Implementation Plan §9).
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(UserEntity user) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.error(Failure failure) = AuthError;
}
