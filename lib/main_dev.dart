import 'bootstrap.dart';
import 'firebase_options.dart';

/// Explicit dev entrypoint: `flutter run -t lib/main_dev.dart`. Identical to
/// `main.dart` — exists so the dev/prod split is symmetric with
/// `main_prod.dart` (see `firebase_options_prod.dart` for why there's no
/// native `--flavor` split, just this Dart-side entrypoint difference).
Future<void> main() async {
  await bootstrap(DefaultFirebaseOptions.currentPlatform);
}
