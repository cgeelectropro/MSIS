import '../../../../shared/models/result.dart';
import '../../../authentication/domain/entities/user_entity.dart';

/// SRS §9.6/§18.5 Users routes. Admin-only per BRULE-005 (enforced server-side).
abstract class UserRepository {
  Future<Result<List<UserEntity>>> list({UserRole? role, String? search});

  Future<Result<UserEntity>> createTechnician({
    required String nom,
    required String email,
    String? telephone,
  });

  Future<Result<UserEntity>> updateStatus({required int userId, required bool actif});
}
