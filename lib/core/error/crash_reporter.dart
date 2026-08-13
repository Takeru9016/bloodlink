import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Single funnel for reporting uncaught errors to Crashlytics.
///
/// Never forwards `error.toString()`/`error.message` for app-thrown
/// exceptions — per CLAUDE.md §5, blood group and donation history must
/// never reach a crash/analytics tool unredacted, and free-text exception
/// messages built from user data (validation errors, etc.) could carry
/// either. Only the exception's type, and — for known SDK exception types
/// whose `.code` is a fixed enum-like string, never user data — the code,
/// are recorded.
class CrashReporter {
  const CrashReporter._();

  static Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
  }) async {
    if (kDebugMode) {
      // Local dev: surface the real error in the console instead of Crashlytics.
      debugPrint('CrashReporter (debug, not sent): $error\n$stackTrace');
      return;
    }
    await FirebaseCrashlytics.instance.recordError(
      _sanitize(error),
      stackTrace,
      fatal: fatal,
    );
  }

  static String _sanitize(Object error) {
    final type = error.runtimeType.toString();
    final code = switch (error) {
      FirebaseException e => e.code,
      _ => null,
    };
    return code == null ? type : '$type(code: $code)';
  }
}
