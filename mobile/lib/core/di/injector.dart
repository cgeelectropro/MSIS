import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/api_client.dart';
import '../network/connectivity_service.dart';
import '../network/realtime_channel_client.dart';
import '../services/push_notification_service.dart';
import '../storage/auth_session_store.dart';
import '../storage/message_outbox.dart';
import '../storage/secure_token_storage.dart';
import '../../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/interventions/data/datasources/intervention_remote_data_source.dart';
import '../../features/interventions/data/repositories/intervention_repository_impl.dart';
import '../../features/interventions/domain/repositories/intervention_repository.dart';
import '../../features/messages/data/datasources/message_remote_data_source.dart';
import '../../features/messages/data/repositories/message_repository_impl.dart';
import '../../features/messages/domain/repositories/message_repository.dart';
import '../../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/reports/data/datasources/report_remote_data_source.dart';
import '../../features/reports/data/repositories/report_repository_impl.dart';
import '../../features/reports/domain/repositories/report_repository.dart';
import '../../features/users/data/datasources/user_remote_data_source.dart';
import '../../features/users/data/repositories/user_repository_impl.dart';
import '../../features/users/domain/repositories/user_repository.dart';

/// Implementation Plan §1.1/§6: GetIt service-locator root, consumed by
/// Riverpod providers (each feature's controller reads its repository from
/// here rather than constructing it). Registered once in `main.dart` before
/// `runApp`.
final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final tokenStorage = SecureTokenStorage();
  final sessionStore = AuthSessionStore();

  getIt.registerSingleton<SecureTokenStorage>(tokenStorage);
  getIt.registerSingleton<AuthSessionStore>(sessionStore);

  final dio = ApiClient.build(
    tokenStorage: tokenStorage,
    onSessionExpired: () async {
      sessionStore.clear();
    },
  );
  getIt.registerSingleton<Dio>(dio);

  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(getIt<Dio>()));
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: getIt<AuthRemoteDataSource>(),
      tokenStorage: getIt<SecureTokenStorage>(),
      sessionStore: getIt<AuthSessionStore>(),
    ),
  );

  getIt.registerLazySingleton<InterventionRemoteDataSource>(() => InterventionRemoteDataSource(getIt<Dio>()));
  getIt.registerLazySingleton<InterventionRepository>(
    () => InterventionRepositoryImpl(getIt<InterventionRemoteDataSource>()),
  );

  getIt.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSource(getIt<Dio>()));
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt<UserRemoteDataSource>()));

  getIt.registerLazySingleton<MessageOutbox>(() => MessageOutbox());
  // Factory (not singleton): each conversation screen gets its own socket
  // connection/subscription lifecycle, torn down on dispose (MessagesController.disposeController).
  getIt.registerFactory<RealtimeChannelClient>(() => RealtimeChannelClient(getIt<Dio>()));
  getIt.registerLazySingleton<MessageRemoteDataSource>(() => MessageRemoteDataSource(getIt<Dio>()));
  getIt.registerFactory<MessageRepository>(
    () => MessageRepositoryImpl(
      remote: getIt<MessageRemoteDataSource>(),
      realtimeClient: getIt<RealtimeChannelClient>(),
      outbox: getIt<MessageOutbox>(),
    ),
  );

  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  getIt.registerLazySingleton<PushNotificationService>(() => PushNotificationService(getIt<Dio>()));

  getIt.registerLazySingleton<NotificationRemoteDataSource>(() => NotificationRemoteDataSource(getIt<Dio>()));
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt<NotificationRemoteDataSource>()),
  );

  getIt.registerLazySingleton<ReportRemoteDataSource>(() => ReportRemoteDataSource(getIt<Dio>()));
  getIt.registerLazySingleton<ReportRepository>(() => ReportRepositoryImpl(getIt<ReportRemoteDataSource>()));
}
