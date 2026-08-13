import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/error/app_provider_observer.dart';
import 'core/error/crash_reporter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/application/fcm_background_handler.dart';
import 'features/notifications/application/fcm_controller.dart';

/// Shared entrypoint body for every flavor (`main.dart`/`main_dev.dart` and
/// `main_prod.dart`, once `bloodlink-prod` exists) — only [options] differs
/// between them.
Future<void> bootstrap(FirebaseOptions options) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: options);
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        !kDebugMode,
      );
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        CrashReporter.recordError(
          details.exception,
          details.stack ?? StackTrace.current,
        );
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        CrashReporter.recordError(error, stack, fatal: true);
        return true;
      };
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      runApp(
        const ProviderScope(
          observers: [AppProviderObserver()],
          child: MyApp(),
        ),
      );
    },
    (error, stack) => CrashReporter.recordError(error, stack, fatal: true),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Registers the token-refresh and foreground/tap listeners for the life
    // of the app, not just while the donor profile setup screen is open.
    ref.watch(fcmControllerProvider);

    return MaterialApp.router(
      title: 'bloodlink',
      theme: AppTheme.light,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
