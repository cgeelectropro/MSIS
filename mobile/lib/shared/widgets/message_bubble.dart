import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../features/messages/domain/entities/message_entity.dart';

/// Component C.6 (UI_UX_SPECIFICATION.md Part C.6) / SRS FR-DET-04/07/09.
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.isOutgoing, this.onRetry});

  final MessageEntity message;
  final bool isOutgoing;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFailed = message.sendStatus == MessageSendStatus.failed;
    final isSending = message.sendStatus == MessageSendStatus.sending;

    return Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: Opacity(
        opacity: isSending ? 0.7 : 1,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          padding: const EdgeInsets.all(AppSpacing.sm),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: isOutgoing ? AppColors.primaryContainer.withValues(alpha: 0.25) : colorScheme.surface,
            border: isOutgoing ? null : Border.all(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(AppSpacing.radiusStandard),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.attachment != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusStandard),
                  child: Image.network(message.attachment!.url, fit: BoxFit.cover, errorBuilder: (_, _, _) => const Icon(Icons.broken_image)),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
              if (message.contenu.isNotEmpty) Text(message.contenu),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.createdAt),
                    style: const TextStyle(fontSize: 11, fontFamily: 'JetBrainsMono', color: Colors.grey),
                  ),
                  if (isOutgoing) ...[
                    const SizedBox(width: 4),
                    Icon(
                      isFailed
                          ? Icons.error_outline
                          : isSending
                          ? Icons.access_time
                          : message.lu
                          ? Icons.done_all
                          : Icons.done,
                      size: 14,
                      color: isFailed ? AppColors.danger : (message.lu ? AppColors.primary : Colors.grey),
                    ),
                  ],
                ],
              ),
              if (isFailed && onRetry != null)
                TextButton(onPressed: onRetry, child: const Text('Réessayer', style: TextStyle(fontSize: 12))),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) => '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
