import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/message_bubble.dart';
import '../../../authentication/presentation/controllers/auth_controller.dart';
import '../../../authentication/presentation/controllers/auth_state.dart';
import '../../domain/entities/message_entity.dart';
import '../controllers/messages_controller.dart';
import '../controllers/messages_state.dart';

/// UI_UX_SPECIFICATION.md Part F.8 (messaging section of SCR-08) / SRS FR-DET-03..11.
class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key, required this.interventionId, required this.isClosed});

  final int interventionId;
  final bool isClosed;

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _send({String? contenu, String? attachmentPath}) async {
    final text = contenu ?? _textController.text.trim();
    if (text.isEmpty && attachmentPath == null) return;

    _textController.clear();
    await ref
        .read(messagesControllerProvider(widget.interventionId).notifier)
        .send(contenu: text.isEmpty ? null : text, attachmentPath: attachmentPath);
    _scrollToBottom();
  }

  Future<void> _pickAndSendPhoto() async {
    // SRS §22 client-side recompression before upload (FILE-05).
    final picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1920, imageQuality: 80);
    if (picked != null) await _send(attachmentPath: picked.path);
  }

  /// SRS FR-DET-06: marks incoming, not-yet-read messages seen once they're
  /// actually rendered in this conversation. Previously wired end-to-end
  /// (controller/repository/API) but never called from the UI, so `lu` never
  /// flipped and the double-check icon in MessageBubble was permanently dead.
  void _markVisibleAsSeen(List<MessageEntity> messages, int? currentUserId) {
    if (currentUserId == null) return;
    for (final message in messages) {
      if (message.idExpediteur != currentUserId && !message.lu) {
        ref.read(messagesControllerProvider(widget.interventionId).notifier).markSeen(message.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messagesControllerProvider(widget.interventionId));
    final authState = ref.watch(authControllerProvider);
    final currentUserId = authState.maybeWhen(authenticated: (u) => u.id, orElse: () => null);

    if (state is MessagesLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _markVisibleAsSeen(state.messages, currentUserId));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Messagerie')),
      body: Column(
        children: [
          // SRS §20.2 / SEC-27: MVP is server-side encryption at rest, not E2EE —
          // the copy reflects that exactly, never a "zero-knowledge" claim.
          Container(
            width: double.infinity,
            color: AppColors.primaryContainer.withValues(alpha: 0.15),
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: const Row(
              children: [
                Icon(Icons.lock, size: 16, color: AppColors.primary),
                SizedBox(width: AppSpacing.xs),
                Expanded(child: Text('Conversation chiffrée et strictement confidentielle', style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
          Expanded(child: _buildList(state, currentUserId)),
          if (widget.isClosed)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text('Conversation clôturée', style: TextStyle(color: Colors.grey)),
            )
          else
            _buildComposer(state),
        ],
      ),
    );
  }

  Widget _buildList(MessagesState state, int? currentUserId) {
    return switch (state) {
      MessagesInitial() || MessagesLoading() => const Center(child: CircularProgressIndicator()),
      MessagesError(:final failure) => Center(child: Text(failure.message)),
      MessagesLoaded(:final messages) => messages.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
                  SizedBox(height: AppSpacing.sm),
                  Text('Aucune conversation'),
                  Text(
                    'Les conversations démarrées depuis les interventions apparaîtront ici.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageBubble(
                  message: message,
                  isOutgoing: message.idExpediteur == currentUserId,
                  onRetry: message.sendStatus == MessageSendStatus.failed
                      ? () => _send(contenu: message.contenu)
                      : null,
                );
              },
            ),
    };
  }

  Widget _buildComposer(MessagesState state) {
    final sending = state is MessagesLoaded && state.sending;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.photo_camera_outlined), onPressed: sending ? null : _pickAndSendPhoto),
            Expanded(
              child: TextField(
                controller: _textController,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'Écrire un message…', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            IconButton.filled(
              icon: sending
                  ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send),
              onPressed: sending ? null : () => _send(),
            ),
          ],
        ),
      ),
    );
  }
}
