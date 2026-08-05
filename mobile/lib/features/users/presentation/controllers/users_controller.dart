import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injector.dart';
import '../../../../shared/models/result.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import 'users_state.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => getIt<UserRepository>());

final usersControllerProvider = StateNotifierProvider<UsersController, UsersState>(
  (ref) => UsersController(ref.watch(userRepositoryProvider)),
);

/// SRS §9.6 — backs SCR-10 (Supervisor user management).
class UsersController extends StateNotifier<UsersState> {
  UsersController(this._repository) : super(const UsersState.initial());

  final UserRepository _repository;

  Future<void> load({UserRole? role, String? search}) async {
    state = const UsersState.loading();
    final result = await _repository.list(role: role, search: search);
    state = switch (result) {
      Success(:final data) => UsersState.loaded(data),
      ResultFailure(:final failure) => UsersState.error(failure),
    };
  }

  Future<bool> createTechnician({required String nom, required String email, String? telephone}) async {
    final result = await _repository.createTechnician(nom: nom, email: email, telephone: telephone);
    if (result.isSuccess) {
      await load(role: UserRole.technicien);
      return true;
    }
    return false;
  }

  Future<bool> updateStatus({required int userId, required bool actif, UserRole? currentFilter}) async {
    final result = await _repository.updateStatus(userId: userId, actif: actif);
    if (result.isSuccess) {
      await load(role: currentFilter);
      return true;
    }
    return false;
  }
}
