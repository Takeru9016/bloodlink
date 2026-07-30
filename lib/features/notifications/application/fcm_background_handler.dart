import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../firebase_options.dart';

/// Runs in a separate isolate with no access to the running app's state, so
/// Firebase has to be re-initialized here even though `main()` already did it.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
