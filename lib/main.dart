import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/application/fcm_background_handler.dart';
import 'features/notifications/application/fcm_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const ProviderScope(child: MyApp()));
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
