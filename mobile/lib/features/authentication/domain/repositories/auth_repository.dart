import '../../../../shared/models/result.dart';
import '../entities/user_entity.dart';

/// Implementation Plan §1.1: `domain` contract, implemented by `data`.
/// `presentation` depends on this interface only, never on the impl directly.
abstract class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
    required UserRole role,
  });

  Future<Result<void>> register({
    required String nom,
    required String email,
    required String password,
    String? telephone,
  });

  Future<Result<void>> logout();

  Future<Result<void>> logoutAllDevices();

  Future<Result<void>> forgotPassword(String email);

  Future<Result<void>> resetPassword({
    required String token,
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> getCurrentUser();

  /// Restores a session from secure storage on cold start (SCR-01 Splash).
  Future<bool> hasStoredSession();
}
