import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Placeholder for `bloodlink-prod`'s Firebase config.
///
/// `Firebase.initializeApp(options: ...)` (called from `bootstrap.dart`)
/// fully determines which Firebase project every Dart-side call (Firestore,
/// Auth, Storage, Functions, Messaging) targets — that's what this file's
/// `currentPlatform` feeds once real, and it's enough on its own to make
/// `lib/main_prod.dart` talk to a different backend than `lib/main_dev.dart`.
/// `android/app/google-services.json` / `ios/Runner/GoogleService-Info.plist`
/// stay pointed at `bloodlink-dev-wt` regardless — native Android product
/// flavors (a separate `google-services.json` per build variant) were tried
/// and reverted here, because Gradle's `assembleDebug`/`assembleRelease`
/// build every flavor once `flavorDimensions` exists, which broke the plain
/// no-`--flavor` `flutter build apk`/`flutter run` CLAUDE.md's existing
/// release workflow relies on. Revisit native flavors (or a CI matrix per
/// environment) once bloodlink-prod is real and there's a device to verify
/// the split on — until then, `bloodlink-prod` doesn't exist yet (CLAUDE.md
/// §7), so this throws instead of silently booting a prod build against
/// garbage or dev credentials. Once `flutterfire configure
/// --project=bloodlink-prod --out=lib/firebase_options_prod.dart` has been
/// run for real, its generated `DefaultFirebaseOptions` class replaces this
/// file's contents; `lib/main_prod.dart`'s import needs no change.
class DefaultFirebaseOptionsProd {
  static FirebaseOptions get currentPlatform => throw UnsupportedError(
    'bloodlink-prod is not configured yet. Run `flutterfire configure '
    '--project=bloodlink-prod --out=lib/firebase_options_prod.dart` once '
    'the bloodlink-prod Firebase project exists (see CLAUDE.md §7), then '
    'replace this file with the generated output.',
  );
}
