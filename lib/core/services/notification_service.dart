import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/logger/app_logger.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'pqc_auth_channel';
  static const String _channelName = 'PQC Authenticator';
  static const String _channelDescription = 'Notifications for PQC Authenticator';

  static const String _securityChannelId = 'security_alerts';
  static const String _securityChannelName = 'Security Alerts';
  static const String _securityChannelDescription = 'Important security notifications';

  static const String _syncChannelId = 'sync_notifications';
  static const String _syncChannelName = 'Sync Updates';
  static const String _syncChannelDescription = 'Account synchronization notifications';

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createNotificationChannels();
    AppLogger.info('Notification service initialized');
  }

  Future<void> _createNotificationChannels() async {
    const androidChannels = [
      AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.defaultImportance,
        enableVibration: true,
        playSound: true,
      ),
      AndroidNotificationChannel(
        _securityChannelId,
        _securityChannelName,
        description: _securityChannelDescription,
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      ),
      AndroidNotificationChannel(
        _syncChannelId,
        _syncChannelName,
        description: _syncChannelDescription,
        importance: Importance.low,
        enableVibration: false,
        playSound: false,
      ),
    ];

    for (final channel in androidChannels) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    AppLogger.info('Notification tapped: ${response.payload}');
  }

  Future<bool> requestPermission() async {
    try {
      final status = await Permission.notification.request();
      AppLogger.info('Notification permission status: $status');
      return status == PermissionStatus.granted;
    } catch (e) {
      AppLogger.error('Error requesting notification permission: $e');
      return false;
    }
  }

  Future<bool> areNotificationsEnabled() async {
    try {
      final status = await Permission.notification.status;
      return status == PermissionStatus.granted;
    } catch (e) {
      AppLogger.error('Error checking notification permission: $e');
      return false;
    }
  }

  Future<void> showAccountAddedNotification({
    required String serviceName,
    required String accountName,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Account Added',
      '$serviceName account for $accountName has been added successfully',
      notificationDetails,
      payload: 'account_added',
    );
  }

  Future<void> showBackupCompletedNotification({
    required String backupName,
    required int accountCount,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Backup Completed',
      'Backup "$backupName" created with $accountCount accounts',
      notificationDetails,
      payload: 'backup_completed',
    );
  }

  Future<void> showSyncCompletedNotification({
    required int syncedAccounts,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _syncChannelId,
        _syncChannelName,
        channelDescription: _syncChannelDescription,
        importance: Importance.low,
        priority: Priority.low,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Sync Completed',
      '$syncedAccounts accounts synchronized successfully',
      notificationDetails,
      payload: 'sync_completed',
    );
  }

  Future<void> showSecurityAlertNotification({
    required String title,
    required String message,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _securityChannelId,
        _securityChannelName,
        channelDescription: _securityChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFFEF4444),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      message,
      notificationDetails,
      payload: 'security_alert',
    );
  }

  Future<void> showNewDeviceLoginNotification({
    required String deviceName,
    required String location,
  }) async {
    await showSecurityAlertNotification(
      title: 'New Device Login',
      message: 'Your account was accessed from $deviceName in $location',
    );
  }

  Future<void> showAccountExportNotification({
    required int accountCount,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Export Completed',
      '$accountCount accounts exported successfully',
      notificationDetails,
      payload: 'export_completed',
    );
  }

  Future<void> showConflictResolutionNotification({
    required int conflictCount,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _syncChannelId,
        _syncChannelName,
        channelDescription: _syncChannelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Sync Conflicts Detected',
      '$conflictCount conflicts need your attention',
      notificationDetails,
      payload: 'sync_conflicts',
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  Future<List<ActiveNotification>> getActiveNotifications() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      return await androidImplementation.getActiveNotifications();
    }
    
    return [];
  }
}