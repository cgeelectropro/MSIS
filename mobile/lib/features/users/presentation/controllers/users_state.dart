import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../../authentication/domain/entities/user_entity.dart';

part 'users_state.freezed.dart';

@freezed
sealed class UsersState with _$UsersState {
  const factory UsersState.initial() = UsersInitial;
  const factory UsersState.loading() = UsersLoading;
  const factory UsersState.loaded(List<UserEntity> items) = UsersLoaded;
  const factory UsersState.error(Failure failure) = UsersError;
}
