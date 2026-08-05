import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

import '../../../../core/network/interceptors/error_interceptor.dart';
import '../../../../core/network/realtime_channel_client.dart';
import '../../../../core/storage/message_outbox.dart';
import '../../../../shared/models/result.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_remote_data_source.dart';
import '../models/message_dto.dart';

class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl({
    required this._remote,
    required this._realtimeClient,
    required this._outbox,
  });

  final MessageRemoteDataSource _remote;
  final RealtimeChannelClient _realtimeClient;
  final MessageOutbox _outbox;
  final _random = Random();

  String _generateTempId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(1 << 32)}';

  @override
  Future<Result<List<MessageEntity>>> list(int interventionId) async {
    try {
      final dtos = await _remote.list(interventionId);
      return Result.success(dtos.map((d) => d.toEntity()).toList());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<MessageEntity>> send({
    required int interventionId,
    String? contenu,
    String? attachmentPath,
  }) async {
    try {
      final dto = await _remote.send(interventionId: interventionId, contenu: contenu, attachmentPath: attachmentPath);
      return Result.success(dto.toEntity());
    } on DioException catch (e) {
      // SRS FR-TRV-04: network failure queues the send instead of failing outright.
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
        final tempId = _generateTempId();
        await _outbox.enqueue(
          QueuedMessage(
            clientTempId: tempId,
            interventionId: interventionId,
            contenu: contenu,
            attachmentPath: attachmentPath,
            queuedAt: DateTime.now(),
          ),
        );
        return Result.success(
          MessageEntity(
            id: -1,
            idIntervention: interventionId,
            idExpediteur: -1,
            contenu: contenu ?? '',
            livre: false,
            lu: false,
            createdAt: DateTime.now(),
            sendStatus: MessageSendStatus.sending,
            clientTempId: tempId,
          ),
        );
      }
      return Result.failure(ErrorMapper.map(e));
    }
  }

  /// SRS §14.4 step 8: replays the outbox in order, exactly once per item.
  Future<void> flushOutbox() async {
    final pending = await _outbox.readAll();
    for (final item in pending) {
      try {
        await _remote.send(interventionId: item.interventionId, contenu: item.contenu, attachmentPath: item.attachmentPath);
        await _outbox.remove(item.clientTempId);
      } on DioException {
        break; // still offline (or server rejected) — stop, retry on next connectivity event
      }
    }
  }

  @override
  Future<Result<MessageEntity>> markSeen(int messageId) async {
    try {
      final dto = await _remote.markSeen(messageId);
      return Result.success(dto.toEntity());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<int>> unreadCount() async {
    try {
      return Result.success(await _remote.unreadCount());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Stream<MessageEntity> watchConversation(int interventionId) {
    _realtimeClient.connectToInterventionChannel(interventionId);

    // `message.read` carries only {id_message, lu_at} (App\Events\MessageRead),
    // not a full message payload — the controller re-fetches the read-state
    // via REST when it needs it (SCR-08's seen indicator), so only the
    // full-payload `message.sent` event (App\Events\MessageSent) is mapped here.
    return _realtimeClient.events
        .where((frame) => frame['event'] == 'message.sent')
        .map((frame) => MessageDto.fromJson(frame['data']['message'] as Map<String, dynamic>).toEntity());
  }

  @override
  void stopWatching(int interventionId) {
    _realtimeClient.disconnect();
  }
}
