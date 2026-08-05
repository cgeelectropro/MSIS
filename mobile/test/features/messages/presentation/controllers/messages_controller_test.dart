import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:msis_mobile/core/errors/failures.dart';
import 'package:msis_mobile/features/messages/domain/entities/message_entity.dart';
import 'package:msis_mobile/features/messages/domain/repositories/message_repository.dart';
import 'package:msis_mobile/features/messages/presentation/controllers/messages_controller.dart';
import 'package:msis_mobile/features/messages/presentation/controllers/messages_state.dart';
import 'package:msis_mobile/shared/models/result.dart';

class MockMessageRepository extends Mock implements MessageRepository {}

MessageEntity _msg(int id, {String contenu = 'hello', int idExpediteur = 1}) => MessageEntity(
  id: id,
  idIntervention: 10,
  idExpediteur: idExpediteur,
  contenu: contenu,
  livre: false,
  lu: false,
  createdAt: DateTime(2026, 1, 1),
);

void main() {
  late MockMessageRepository repository;
  late StreamController<MessageEntity> realtimeController;

  setUp(() {
    repository = MockMessageRepository();
    realtimeController = StreamController<MessageEntity>.broadcast();
    when(() => repository.watchConversation(any())).thenAnswer((_) => realtimeController.stream);
    when(() => repository.stopWatching(any())).thenReturn(null);
  });

  tearDown(() => realtimeController.close());

  // SRS SCR-08: history loads on init.
  test('loads conversation history on construction', () async {
    when(() => repository.list(10)).thenAnswer((_) async => Result.success([_msg(1), _msg(2)]));

    final controller = MessagesController(repository, 10);
    await Future<void>.delayed(Duration.zero);

    expect(controller.state, isA<MessagesLoaded>());
    expect((controller.state as MessagesLoaded).messages.length, 2);
    controller.disposeController();
  });

  test('a list failure surfaces MessagesError', () async {
    when(() => repository.list(10)).thenAnswer((_) async => const Result.failure(ServerFailure()));

    final controller = MessagesController(repository, 10);
    await Future<void>.delayed(Duration.zero);

    expect(controller.state, isA<MessagesError>());
    controller.disposeController();
  });

  // SRS §21.1: a live event for this conversation is appended to the list.
  test('an incoming realtime message is appended', () async {
    when(() => repository.list(10)).thenAnswer((_) async => Result.success([_msg(1)]));

    final controller = MessagesController(repository, 10);
    await Future<void>.delayed(Duration.zero);

    realtimeController.add(_msg(2, contenu: 'live update'));
    await Future<void>.delayed(Duration.zero);

    final messages = (controller.state as MessagesLoaded).messages;
    expect(messages.length, 2);
    expect(messages.last.contenu, 'live update');
    controller.disposeController();
  });

  // Gap Analysis D-16d-adjacent: a message already present (e.g. via polling)
  // must not be duplicated when the same id arrives over the realtime channel.
  test('a duplicate realtime message (same id) is not appended twice', () async {
    when(() => repository.list(10)).thenAnswer((_) async => Result.success([_msg(1)]));

    final controller = MessagesController(repository, 10);
    await Future<void>.delayed(Duration.zero);

    realtimeController.add(_msg(1, contenu: 'duplicate'));
    await Future<void>.delayed(Duration.zero);

    expect((controller.state as MessagesLoaded).messages.length, 1);
    controller.disposeController();
  });

  // SRS FR-DET-04
  test('send appends the new message on success', () async {
    when(() => repository.list(10)).thenAnswer((_) async => Result.success([_msg(1)]));
    when(() => repository.send(interventionId: 10, contenu: 'hi', attachmentPath: null))
        .thenAnswer((_) async => Result.success(_msg(2, contenu: 'hi')));

    final controller = MessagesController(repository, 10);
    await Future<void>.delayed(Duration.zero);

    await controller.send(contenu: 'hi');

    final state = controller.state as MessagesLoaded;
    expect(state.messages.length, 2);
    expect(state.sending, isFalse);
    controller.disposeController();
  });

  // SRS FR-TRV-04: a network failure during send should not leave the UI stuck "sending".
  test('a failed send clears the sending flag without losing existing messages', () async {
    when(() => repository.list(10)).thenAnswer((_) async => Result.success([_msg(1)]));
    when(() => repository.send(interventionId: 10, contenu: 'hi', attachmentPath: null))
        .thenAnswer((_) async => const Result.failure(NetworkFailure()));

    final controller = MessagesController(repository, 10);
    await Future<void>.delayed(Duration.zero);

    await controller.send(contenu: 'hi');

    final state = controller.state as MessagesLoaded;
    expect(state.messages.length, 1);
    expect(state.sending, isFalse);
    controller.disposeController();
  });

  test('disposeController stops watching and cancels the realtime subscription', () async {
    when(() => repository.list(10)).thenAnswer((_) async => Result.success([_msg(1)]));

    final controller = MessagesController(repository, 10);
    await Future<void>.delayed(Duration.zero);
    controller.disposeController();

    verify(() => repository.stopWatching(10)).called(1);
  });
}
