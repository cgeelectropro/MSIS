import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants/api_endpoints.dart';

/// SRS §20/§21 push channel. Mirrors the backend's PushNotificationService
/// pattern: safe no-op whenever Firebase hasn't been configured for this
/// build (no `google-services.json`/`GoogleService-Info.plist` ships in this
/// repo — those are per-deployment secrets/config, not something to
/// fabricate). Calling [initialize] on an unconfigured build catches the
/// FirebaseException and leaves push silently disabled rather than crashing
/// app startup — in-app notifications (SCR-14) remain fully functional
/// either way.
class PushNotificationService {
  PushNotificationService(this._dio);

  final Dio _dio;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize({required void Function(String interventionId) onNotificationTap}) async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // No Firebase config bundled for this build — push is disabled, not fatal.
      debugPrint('PushNotificationService: Firebase not configured, push disabled ($e)');
      return;
    }

    await _localNotifications.initialize(
      settings: const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
      onDidReceiveNotificationResponse: (response) {
        final id = response.payload;
        if (id != null) onNotificationTap(id);
      },
    );

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    final token = await messaging.getToken();
    if (token != null) await _registerToken(token);
    messaging.onTokenRefresh.listen(_registerToken);

    // SRS §16.2 "Local Notifications ... Support Android Notification Channels":
    // foreground messages are shown via flutter_local_notifications since FCM
    // does not auto-display a system notification while the app is foregrounded.
    FirebaseMessaging.onMessage.listen(_showLocalNotification);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final interventionId = message.data['id_intervention'];
      if (interventionId != null && interventionId.isNotEmpty) onNotificationTap(interventionId);
    });

    _initialized = true;
  }

  Future<void> _registerToken(String token) async {
    try {
      await _dio.post<void>(ApiEndpoints.deviceRegister, data: {'token': token, 'platform': 'android'});
    } catch (_) {
      // Registration is best-effort — in-app notifications still work regardless.
    }
  }

  Future<void> unregister(String token) async {
    if (!_initialized) return;
    try {
      await _dio.delete<void>(ApiEndpoints.deviceUnregister, data: {'token': token});
    } catch (_) {}
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'msis_default',
      'MSIS Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _localNotifications.show(
      id: message.hashCode,
      title: message.notification?.title ?? 'MSIS',
      body: message.notification?.body ?? '',
      notificationDetails: const NotificationDetails(android: androidDetails),
      payload: message.data['id_intervention'] as String?,
    );
  }
}

/// SRS §16.2 background-message handling: must be a top-level function per
/// the firebase_messaging plugin contract (registered in main.dart before
/// runApp). Kept minimal — the app's own in-app/badge state refreshes on
/// next foreground open rather than doing background DB writes here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
