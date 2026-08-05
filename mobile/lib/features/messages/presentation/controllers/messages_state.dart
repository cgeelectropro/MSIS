import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/message_entity.dart';

part 'messages_state.freezed.dart';

@freezed
sealed class MessagesState with _$MessagesState {
  const factory MessagesState.initial() = MessagesInitial;
  const factory MessagesState.loading() = MessagesLoading;
  const factory MessagesState.loaded(List<MessageEntity> messages, {@Default(false) bool sending}) = MessagesLoaded;
  const factory MessagesState.error(Failure failure) = MessagesError;
}
