import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// SRS FR-TRV-04 / §14.4 step 8 / §20.4: offline outbox for queued message
/// sends, replayed in chronological order on reconnection with a client
/// idempotency key so the server dedups (`GAP_ANALYSIS.md` D-16d/§27.3 "no
/// duplication"). Backed by a JSON file in app storage — Hive/drift were the
/// Implementation Plan's original picks (§24.1 of the SRS), but the concrete
/// `pub` dependency conflict documented in IMPLEMENTATION_PLAN.md ruled out
/// adding another codegen package here; a single flat JSON file is more than
/// sufficient for a queue of this size and needs no schema/build_runner step.
class QueuedMessage {
  QueuedMessage({
    required this.clientTempId,
    required this.interventionId,
    this.contenu,
    this.attachmentPath,
    required this.queuedAt,
  });

  final String clientTempId;
  final int interventionId;
  final String? contenu;
  final String? attachmentPath;
  final DateTime queuedAt;

  Map<String, dynamic> toJson() => {
    'clientTempId': clientTempId,
    'interventionId': interventionId,
    'contenu': contenu,
    'attachmentPath': attachmentPath,
    'queuedAt': queuedAt.toIso8601String(),
  };

  factory QueuedMessage.fromJson(Map<String, dynamic> json) => QueuedMessage(
    clientTempId: json['clientTempId'] as String,
    interventionId: json['interventionId'] as int,
    contenu: json['contenu'] as String?,
    attachmentPath: json['attachmentPath'] as String?,
    queuedAt: DateTime.parse(json['queuedAt'] as String),
  );
}

class MessageOutbox {
  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/msis_message_outbox.json');
  }

  Future<List<QueuedMessage>> readAll() async {
    final file = await _file();
    if (!await file.exists()) return [];

    final content = await file.readAsString();
    if (content.isEmpty) return [];

    final list = jsonDecode(content) as List;
    return list.map((e) => QueuedMessage.fromJson(e as Map<String, dynamic>)).toList()
      ..sort((a, b) => a.queuedAt.compareTo(b.queuedAt)); // chronological replay order
  }

  Future<void> enqueue(QueuedMessage message) async {
    final all = await readAll();
    all.add(message);
    await _writeAll(all);
  }

  Future<void> remove(String clientTempId) async {
    final all = await readAll();
    all.removeWhere((m) => m.clientTempId == clientTempId);
    await _writeAll(all);
  }

  Future<void> _writeAll(List<QueuedMessage> messages) async {
    final file = await _file();
    await file.writeAsString(jsonEncode(messages.map((m) => m.toJson()).toList()));
  }
}
