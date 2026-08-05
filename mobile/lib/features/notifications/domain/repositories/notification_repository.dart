import '../../../../shared/models/result.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Result<List<NotificationEntity>>> list();
  Future<Result<void>> markRead(int id);
  Future<Result<void>> markAllRead();
}
