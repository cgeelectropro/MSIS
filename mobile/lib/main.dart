import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/di/injector.dart';
import 'core/services/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  // SRS §20/§21: safe no-op if this build has no Firebase config bundled
  // (see PushNotificationService's doc comment) — never blocks app startup.
  unawaited(
    getIt<PushNotificationService>().initialize(onNotificationTap: openInterventionFromNotification),
  );

  runApp(const ProviderScope(child: App()));
}
