import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/notification_dto.dart';

class NotificationRemoteDataSource {
  NotificationRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<NotificationDto>> list() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.notifications);
    final data = response.data!['data'] as List;
    return data.map((e) => NotificationDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> markRead(int id) => _dio.patch<void>(ApiEndpoints.notificationRead(id));

  Future<void> markAllRead() => _dio.patch<void>(ApiEndpoints.notificationsReadAll);
}
