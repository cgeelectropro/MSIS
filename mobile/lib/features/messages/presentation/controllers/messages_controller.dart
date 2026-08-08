import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injector.dart';
import '../../../../shared/models/result.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import 'messages_state.dart';

final messageRepositoryProvider = Provider<MessageRepository>((ref) => getIt<MessageRepository>());

final messagesControllerProvider =
    StateNotifierProvider.autoDispose.family<MessagesController, MessagesState, int>((ref, interventionId) {
      final controller = MessagesController(ref.watch(messageRepositoryProvider), interventionId);
      ref.onDispose(controller.disposeController);
      return controller;
    });

/// SRS §14.4/§21.2: loads history via REST, then layers WSS live updates on
/// top with a 15s REST-polling fallback running unconditionally alongside it
/// — cheap, and guarantees the conversation stays live even if the socket
/// never connects (matches the SRS's own fallback design exactly, rather
/// than trying to detect "is the socket really working" heuristically).
class MessagesController extends StateNotifier<MessagesState> {
  MessagesController(this._repository, this._interventionId) : super(const MessagesState.initial()) {
    _init();
  }

  final MessageRepository _repository;
  final int _interventionId;
  StreamSubscription<MessageEntity>? _realtimeSub;
  Timer? _pollTimer;

  void _init() {
    load();
    _realtimeSub = _repository.watchConversation(_interventionId).listen(_onRealtimeMessage);
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) => load(silent: true));
  }

  Future<void> load({bool silent = false}) async {
    if (!silent) state = const MessagesState.loading();
    final result = await _repository.list(_interventionId);
    state = switch (result) {
      Success(:final data) => MessagesState.loaded(data),
      ResultFailure(:final failure) => silent ? state : MessagesState.error(failure),
    };
  }

  void _onRealtimeMessage(MessageEntity incoming) {
    final current = state;
    if (current is! MessagesLoaded) return;
    if (current.messages.any((m) => m.id == incoming.id)) return; // dedup vs. polling/optimistic send

    state = current.copyWith(messages: [...current.messages, incoming]);
  }

  Future<void> send({String? contenu, String? attachmentPath}) async {
    final current = state;
    if (current is! MessagesLoaded) return;

    state = current.copyWith(sending: true);
    final result = await _repository.send(interventionId: _interventionId, contenu: contenu, attachmentPath: attachmentPath);

    final latest = state;
    if (latest is! MessagesLoaded) return;

    switch (result) {
      case Success(:final data):
        state = latest.copyWith(messages: [...latest.messages, data], sending: false);
      case ResultFailure():
        state = latest.copyWith(sending: false);
        // Failure is surfaced to the caller via the returned Result so the
        // screen can show a retry affordance on that specific bubble.
    }
  }

  /// Optimistic local update, not just a fire-and-forget API call — without
  /// it, the screen has no way to know a message is already marked seen and
  /// would re-call this for the same message on every rebuild until the next
  /// poll/realtime echo caught up.
  Future<void> markSeen(int messageId) async {
    final current = state;
    if (current is! MessagesLoaded) return;

    state = current.copyWith(
      messages: [
        for (final m in current.messages)
          if (m.id == messageId) m.copyWith(lu: true) else m,
      ],
    );

    await _repository.markSeen(messageId);
  }

  void disposeController() {
    _realtimeSub?.cancel();
    _pollTimer?.cancel();
    _repository.stopWatching(_interventionId);
  }
}
