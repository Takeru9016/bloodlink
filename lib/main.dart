import 'bootstrap.dart';
import 'firebase_options.dart';

// Re-exported so `import 'package:bloodlink/main.dart'` still exposes MyApp
// directly — test/widget_test.dart pumps it from here, per CLAUDE.md line
// 110's lesson about the entrypoint needing real test coverage.
export 'bootstrap.dart' show MyApp;

/// Default entrypoint — same as `main_dev.dart`. Kept so plain `flutter run`
/// / `flutter build` (no `--flavor`/`-t`) still targets `bloodlink-dev-wt`,
/// unchanged from before the dev/prod flavor split.
Future<void> main() async {
  await bootstrap(DefaultFirebaseOptions.currentPlatform);
}
