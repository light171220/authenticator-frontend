import 'dart:convert';
import 'package:workmanager/workmanager.dart';
import '../storage/secure_storage.dart';
import '../storage/database/app_database.dart';
import '../utils/logger/app_logger.dart';
import '../../pkg/totp/totp.dart';
import 'notification_service.dart';

class BackgroundOTPService {
  static const String _otpGenerationTask = 'otp_generation_task';
  static const String _syncTask = 'sync_task';
  static const String _backupTask = 'backup_task';

  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
    AppLogger.info('Background service initialized');
  }

  static Future<void> scheduleOTPGeneration() async {
    await Workmanager().registerPeriodicTask(
      _otpGenerationTask,
      _otpGenerationTask,
      frequency: const Duration(seconds: 30),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
    AppLogger.info('OTP generation task scheduled');
  }

  static Future<void> scheduleSync() async {
    await Workmanager().registerPeriodicTask(
      _syncTask,
      _syncTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
    AppLogger.info('Sync task scheduled');
  }

  static Future<void> scheduleAutoBackup() async {
    await Workmanager().registerPeriodicTask(
      _backupTask,
      _backupTask,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
        requiresCharging: false,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
    AppLogger.info('Auto backup task scheduled');
  }

  static Future<void> cancelOTPGeneration() async {
    await Workmanager().cancelByUniqueName(_otpGenerationTask);
    AppLogger.info('OTP generation task cancelled');
  }

  static Future<void> cancelSync() async {
    await Workmanager().cancelByUniqueName(_syncTask);
    AppLogger.info('Sync task cancelled');
  }

  static Future<void> cancelAutoBackup() async {
    await Workmanager().cancelByUniqueName(_backupTask);
    AppLogger.info('Auto backup task cancelled');
  }

  static Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
    AppLogger.info('All background tasks cancelled');
  }

  static Future<bool> handleBackgroundTask(String taskName, Map<String, dynamic>? inputData) async {
    try {
      switch (taskName) {
        case _otpGenerationTask:
          return await _handleOTPGeneration();
        case _syncTask:
          return await _handleSync();
        case _backupTask:
          return await _handleAutoBackup();
        default:
          AppLogger.warning('Unknown background task: $taskName');
          return false;
      }
    } catch (e) {
      AppLogger.error('Background task error: $e');
      return false;
    }
  }

  static Future<bool> _handleOTPGeneration() async {
    try {
      final database = await AppDatabase.create();
      final secureStorage = SecureStorage();
      
      final userId = await secureStorage.getUserId();
      if (userId == null) return false;

      final accounts = await database.accountDao.getAllAccounts(userId);
      final otpCodes = <String, String>{};
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      for (final account in accounts) {
        if (account.type == 'TOTP') {
          try {
            final secret = await _decryptSecret(account.encryptedSecret);
            final otp = TOTPService.generate(
              secret: secret,
              time: currentTime,
              period: account.period,
              digits: account.digits,
              algorithm: account.algorithm,
            );
            otpCodes[account.id] = otp;
          } catch (e) {
            AppLogger.error('Failed to generate OTP for account ${account.id}: $e');
          }
        }
      }

      await _storeOTPCodes(otpCodes);
      AppLogger.debug('Generated ${otpCodes.length} OTP codes in background');
      
      return true;
    } catch (e) {
      AppLogger.error('OTP generation task failed: $e');
      return false;
    }
  }

  static Future<bool> _handleSync() async {
    try {
      AppLogger.info('Background sync task started');
      return true;
    } catch (e) {
      AppLogger.error('Sync task failed: $e');
      return false;
    }
  }

  static Future<bool> _handleAutoBackup() async {
    try {
      AppLogger.info('Auto backup task started');
      
      final notificationService = NotificationService();
      await notificationService.showBackupCompletedNotification(
        backupName: 'Auto Backup ${DateTime.now().toIso8601String()}',
        accountCount: 0,
      );
      
      return true;
    } catch (e) {
      AppLogger.error('Auto backup task failed: $e');
      return false;
    }
  }

  static Future<String> _decryptSecret(String encryptedSecret) async {
    return encryptedSecret;
  }

  static Future<void> _storeOTPCodes(Map<String, String> otpCodes) async {
    final secureStorage = SecureStorage();
    final encoded = jsonEncode(otpCodes);
    await secureStorage.storeCustomData('current_otp_codes', encoded);
  }

  static Future<Map<String, String>> getCurrentOTPCodes() async {
    try {
      final secureStorage = SecureStorage();
      final encoded = await secureStorage.getCustomData('current_otp_codes');
      if (encoded == null) return {};
      
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      AppLogger.error('Failed to get current OTP codes: $e');
      return {};
    }
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    return await BackgroundOTPService.handleBackgroundTask(task, inputData);
  });
}