import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/message_dto.dart';

class MessageRemoteDataSource {
  MessageRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<MessageDto>> list(int interventionId) async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.interventionMessages(interventionId));
    final data = response.data!['data'] as List;
    return data.map((e) => MessageDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<MessageDto> send({required int interventionId, String? contenu, String? attachmentPath}) async {
    final formData = FormData.fromMap({
      'contenu': ?contenu,
      if (attachmentPath != null) 'attachment': await MultipartFile.fromFile(attachmentPath),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.interventionMessages(interventionId),
      data: formData,
    );
    return MessageDto.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<MessageDto> markSeen(int messageId) async {
    final response = await _dio.patch<Map<String, dynamic>>(ApiEndpoints.messageSeen(messageId));
    return MessageDto.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<int> unreadCount() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.messagesUnread);
    return response.data!['count'] as int;
  }
}
