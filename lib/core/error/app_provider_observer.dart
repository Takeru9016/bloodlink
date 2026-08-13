import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'crash_reporter.dart';

/// Reports every provider failure (thrown during build, or a Future/Stream
/// emitting an error) to Crashlytics exactly once, regardless of which
/// screen's `AsyncValue.when(error: ...)` branch happens to render it.
///
/// This is the single funnel: screens only need to render friendly copy in
/// their `error:` branch, never call [CrashReporter] themselves — doing it
/// per-screen would re-log on every rebuild instead of once per failure.
base class AppProviderObserver extends ProviderObserver {
  const AppProviderObserver();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    CrashReporter.recordError(error, stackTrace);
  }
}
