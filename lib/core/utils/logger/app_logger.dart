import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

class AppLogger {
  static LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.info;
  static const String _name = 'PQCAuth';

  static void initialize({LogLevel minLevel = LogLevel.info}) {
    _minLevel = minLevel;
    info('Logger initialized with level: ${minLevel.name}');
  }

  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, error: error, stackTrace: stackTrace);
  }

  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  static void fatal(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.fatal, message, error: error, stackTrace: stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _minLevel.index) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelName = level.name.toUpperCase().padRight(7);
    final formattedMessage = '[$timestamp] [$levelName] [$_name] $message';

    if (kDebugMode) {
      print(formattedMessage);
      if (error != null) {
        print('Error: $error');
      }
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }

    developer.log(
      message,
      time: DateTime.now(),
      level: _getDeveloperLogLevel(level),
      name: _name,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static int _getDeveloperLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.fatal:
        return 1200;
    }
  }

  static void logApiRequest(String method, String url, {Map<String, dynamic>? data}) {
    debug('API Request: $method $url${data != null ? ' with data: $data' : ''}');
  }

  static void logApiResponse(String method, String url, int statusCode, {Object? data}) {
    if (statusCode >= 200 && statusCode < 300) {
      debug('API Response: $method $url -> $statusCode${data != null ? ' with data: $data' : ''}');
    } else {
      warning('API Response: $method $url -> $statusCode${data != null ? ' with data: $data' : ''}');
    }
  }

  static void logBlocEvent(String blocName, String eventName) {
    debug('BLoC Event: $blocName -> $eventName');
  }

  static void logBlocState(String blocName, String stateName) {
    debug('BLoC State: $blocName -> $stateName');
  }

  static void logNavigation(String from, String to) {
    info('Navigation: $from -> $to');
  }

  static void logUserAction(String action, {Map<String, dynamic>? data}) {
    info('User Action: $action${data != null ? ' with data: $data' : ''}');
  }

  static void logSecurityEvent(String event, {Map<String, dynamic>? data}) {
    warning('Security Event: $event${data != null ? ' with data: $data' : ''}');
  }

  static void logPerformance(String operation, Duration duration, {Map<String, dynamic>? data}) {
    info('Performance: $operation took ${duration.inMilliseconds}ms${data != null ? ' with data: $data' : ''}');
  }

  static void logCrypto(String operation, {bool success = true, String? algorithm}) {
    final status = success ? 'SUCCESS' : 'FAILED';
    info('Crypto: $operation $status${algorithm != null ? ' using $algorithm' : ''}');
  }

  static void logSync(String operation, {int? itemCount, bool success = true}) {
    final status = success ? 'SUCCESS' : 'FAILED';
    info('Sync: $operation $status${itemCount != null ? ' for $itemCount items' : ''}');
  }

  static void logBackup(String operation, {int? accountCount, bool success = true}) {
    final status = success ? 'SUCCESS' : 'FAILED';
    info('Backup: $operation $status${accountCount != null ? ' for $accountCount accounts' : ''}');
  }
}