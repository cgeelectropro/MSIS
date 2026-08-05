import 'dart:async';

import '../../../../shared/models/result.dart';
import '../entities/message_entity.dart';

/// Implementation Plan §1.1: `domain` contract, implemented by `data`.
abstract class MessageRepository {
  Future<Result<List<MessageEntity>>> list(int interventionId);

  Future<Result<MessageEntity>> send({
    required int interventionId,
    String? contenu,
    String? attachmentPath,
  });

  Future<Result<MessageEntity>> markSeen(int messageId);

  Future<Result<int>> unreadCount();

  /// SRS §21.1: live event stream for one conversation — WSS primary, silent
  /// no-op if the realtime channel can't connect (the controller's own
  /// polling timer is the fallback, per §21.2's fallback design).
  Stream<MessageEntity> watchConversation(int interventionId);

  void stopWatching(int interventionId);
}
