import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';

/// SRS §18.3 `messages` / FR-DET-01..11. Pure domain entity.
enum MessageSendStatus { sent, sending, failed }

@freezed
abstract class AttachmentEntity with _$AttachmentEntity {
  const factory AttachmentEntity({
    required int id,
    required String typeMime,
    required int tailleOctets,
    required String url,
  }) = _AttachmentEntity;
}

@freezed
abstract class MessageEntity with _$MessageEntity {
  const factory MessageEntity({
    required int id,
    required int idIntervention,
    required int idExpediteur,
    String? expediteurNom,
    required String contenu,
    AttachmentEntity? attachment,
    required bool livre,
    required bool lu,
    required DateTime createdAt,
    // Client-only, never sent by the server: local send-state for optimistic
    // UI + the offline outbox (SRS §14.4 step 8 / FR-TRV-04).
    @Default(MessageSendStatus.sent) MessageSendStatus sendStatus,
    String? clientTempId,
  }) = _MessageEntity;
}
