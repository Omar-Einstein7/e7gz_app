import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  static void info(String message) {
    _log(message, name: 'INFO', ansi: '\x1B[34m');
  }

  static void success(String message) {
    _log(message, name: 'SUCCESS', ansi: '\x1B[32m');
  }

  static void warning(String message) {
    _log(message, name: 'WARNING', ansi: '\x1B[33m');
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(
      message,
      name: 'ERROR',
      ansi: '\x1B[31m',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void _log(
    String message, {
    String name = '',
    String ansi = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    // ── flutter run terminal (stdout) ──────────────────────────────────────────
    // debugPrint is buffered, respects max-line limits, and always shows in
    // `flutter run` output — unlike developer.log which only reaches the IDE.
    const reset = '\x1B[0m';
    final prefix = '$ansi[$name]$reset';
    debugPrint('$prefix $message');
    if (error != null) debugPrint('$prefix   error: $error');
    if (stackTrace != null) debugPrint('$prefix   stack: $stackTrace');

    // ── IDE / Observatory console ──────────────────────────────────────────────
    developer.log(
      '$ansi$message\x1B[0m',
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

// Global helper functions
void logInfo(String msg) => AppLogger.info(msg);
void logSuccess(String msg) => AppLogger.success(msg);
void logWarning(String msg) => AppLogger.warning(msg);
void logError(String msg, [Object? error, StackTrace? stackTrace]) =>
    AppLogger.error(msg, error, stackTrace);
