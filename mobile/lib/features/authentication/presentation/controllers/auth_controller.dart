import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injector.dart';
import '../../../../shared/models/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// SRS §9.1/§14.1. Classic (non-codegen) Riverpod — see IMPLEMENTATION_PLAN.md's
/// dependency-conflict note: `riverpod_generator` was dropped in favor of
/// hand-written providers to resolve a `pub` version clash with `drift_dev`.
final authRepositoryProvider = Provider<AuthRepository>((ref) => getIt<AuthRepository>());

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.watch(authRepositoryProvider)),
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState.initial());

  final AuthRepository _repository;

  /// SCR-01 Splash: silently restore a session if a token is already stored.
  Future<void> restoreSession() async {
    final hasSession = await _repository.hasStoredSession();
    if (!hasSession) {
      state = const AuthState.unauthenticated();
      return;
    }

    final result = await _repository.getCurrentUser();
    state = switch (result) {
      Success(:final data) => AuthState.authenticated(data),
      ResultFailure() => const AuthState.unauthenticated(),
    };
  }

  Future<void> login({required String email, required String password, required UserRole role}) async {
    state = const AuthState.loading();
    final result = await _repository.login(email: email, password: password, role: role);
    state = switch (result) {
      Success(:final data) => AuthState.authenticated(data),
      ResultFailure(:final failure) => AuthState.error(failure),
    };
  }

  Future<AuthState> register({
    required String nom,
    required String email,
    required String password,
    String? telephone,
  }) async {
    state = const AuthState.loading();
    final result = await _repository.register(
      nom: nom,
      email: email,
      password: password,
      telephone: telephone,
    );
    state = switch (result) {
      Success() => const AuthState.unauthenticated(), // FR-AUTH-11: verify email, then log in.
      ResultFailure(:final failure) => AuthState.error(failure),
    };
    return state;
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }

  Future<void> logoutAllDevices() async {
    await _repository.logoutAllDevices();
    state = const AuthState.unauthenticated();
  }

  Future<AuthState> forgotPassword(String email) async {
    final result = await _repository.forgotPassword(email);
    return switch (result) {
      Success() => const AuthState.unauthenticated(),
      ResultFailure(:final failure) => AuthState.error(failure),
    };
  }

  Future<AuthState> resetPassword({
    required String token,
    required String email,
    required String password,
  }) async {
    final result = await _repository.resetPassword(token: token, email: email, password: password);
    return switch (result) {
      Success() => const AuthState.unauthenticated(),
      ResultFailure(:final failure) => AuthState.error(failure),
    };
  }
}
