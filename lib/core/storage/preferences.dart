import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger/app_logger.dart';

class AppPreferences {
  static SharedPreferences? _prefs;
  
  static const String _isOnboardedKey = 'is_onboarded';
  static const String _themeMode = 'theme_mode';
  static const String _biometricEnabled = 'biometric_enabled';
  static const String _autoBackupEnabled = 'auto_backup_enabled';
  static const String _syncEnabled = 'sync_enabled';
  static const String _notificationsEnabled = 'notifications_enabled';
  static const String _languageCode = 'language_code';
  static const String _backupFrequency = 'backup_frequency';
  static const String _lastAppVersion = 'last_app_version';
  static const String _showOTPTimer = 'show_otp_timer';
  static const String _sortAccountsBy = 'sort_accounts_by';
  static const String _searchHistory = 'search_history';

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      AppLogger.info('App preferences initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize preferences: $e');
      rethrow;
    }
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('Preferences not initialized. Call init() first.');
    }
    return _prefs!;
  }

  Future<bool> setBool(String key, bool value) async {
    try {
      final result = await prefs.setBool(key, value);
      AppLogger.debug('Set bool preference: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to set bool preference $key: $e');
      return false;
    }
  }

  bool getBool(String key, {bool defaultValue = false}) {
    try {
      return prefs.getBool(key) ?? defaultValue;
    } catch (e) {
      AppLogger.error('Failed to get bool preference $key: $e');
      return defaultValue;
    }
  }

  Future<bool> setString(String key, String value) async {
    try {
      final result = await prefs.setString(key, value);
      AppLogger.debug('Set string preference: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to set string preference $key: $e');
      return false;
    }
  }

  String getString(String key, {String defaultValue = ''}) {
    try {
      return prefs.getString(key) ?? defaultValue;
    } catch (e) {
      AppLogger.error('Failed to get string preference $key: $e');
      return defaultValue;
    }
  }

  Future<bool> setInt(String key, int value) async {
    try {
      final result = await prefs.setInt(key, value);
      AppLogger.debug('Set int preference: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to set int preference $key: $e');
      return false;
    }
  }

  int getInt(String key, {int defaultValue = 0}) {
    try {
      return prefs.getInt(key) ?? defaultValue;
    } catch (e) {
      AppLogger.error('Failed to get int preference $key: $e');
      return defaultValue;
    }
  }

  Future<bool> setDouble(String key, double value) async {
    try {
      final result = await prefs.setDouble(key, value);
      AppLogger.debug('Set double preference: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to set double preference $key: $e');
      return false;
    }
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    try {
      return prefs.getDouble(key) ?? defaultValue;
    } catch (e) {
      AppLogger.error('Failed to get double preference $key: $e');
      return defaultValue;
    }
  }

  Future<bool> setStringList(String key, List<String> value) async {
    try {
      final result = await prefs.setStringList(key, value);
      AppLogger.debug('Set string list preference: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to set string list preference $key: $e');
      return false;
    }
  }

  List<String> getStringList(String key, {List<String> defaultValue = const []}) {
    try {
      return prefs.getStringList(key) ?? defaultValue;
    } catch (e) {
      AppLogger.error('Failed to get string list preference $key: $e');
      return defaultValue;
    }
  }

  Future<bool> remove(String key) async {
    try {
      final result = await prefs.remove(key);
      AppLogger.debug('Removed preference: $key');
      return result;
    } catch (e) {
      AppLogger.error('Failed to remove preference $key: $e');
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      final result = await prefs.clear();
      AppLogger.info('All preferences cleared');
      return result;
    } catch (e) {
      AppLogger.error('Failed to clear preferences: $e');
      return false;
    }
  }

  bool containsKey(String key) {
    try {
      return prefs.containsKey(key);
    } catch (e) {
      AppLogger.error('Failed to check if preference exists $key: $e');
      return false;
    }
  }

  Set<String> getKeys() {
    try {
      return prefs.getKeys();
    } catch (e) {
      AppLogger.error('Failed to get preference keys: $e');
      return <String>{};
    }
  }

  Future<bool> setIsOnboarded(bool value) => setBool(_isOnboardedKey, value);
  bool getIsOnboarded() => getBool(_isOnboardedKey);

  Future<bool> setThemeMode(String value) => setString(_themeMode, value);
  String getThemeMode() => getString(_themeMode, defaultValue: 'system');

  Future<bool> setBiometricEnabled(bool value) => setBool(_biometricEnabled, value);
  bool getBiometricEnabled() => getBool(_biometricEnabled);

  Future<bool> setAutoBackupEnabled(bool value) => setBool(_autoBackupEnabled, value);
  bool getAutoBackupEnabled() => getBool(_autoBackupEnabled);

  Future<bool> setSyncEnabled(bool value) => setBool(_syncEnabled, value);
  bool getSyncEnabled() => getBool(_syncEnabled, defaultValue: true);

  Future<bool> setNotificationsEnabled(bool value) => setBool(_notificationsEnabled, value);
  bool getNotificationsEnabled() => getBool(_notificationsEnabled, defaultValue: true);

  Future<bool> setLanguageCode(String value) => setString(_languageCode, value);
  String getLanguageCode() => getString(_languageCode, defaultValue: 'en');

  Future<bool> setBackupFrequency(String value) => setString(_backupFrequency, value);
  String getBackupFrequency() => getString(_backupFrequency, defaultValue: 'weekly');

  Future<bool> setLastAppVersion(String value) => setString(_lastAppVersion, value);
  String getLastAppVersion() => getString(_lastAppVersion);

  Future<bool> setShowOTPTimer(bool value) => setBool(_showOTPTimer, value);
  bool getShowOTPTimer() => getBool(_showOTPTimer, defaultValue: true);

  Future<bool> setSortAccountsBy(String value) => setString(_sortAccountsBy, value);
  String getSortAccountsBy() => getString(_sortAccountsBy, defaultValue: 'name');

  Future<bool> setSearchHistory(List<String> value) => setStringList(_searchHistory, value);
  List<String> getSearchHistory() => getStringList(_searchHistory);

  Future<void> addToSearchHistory(String query) async {
    final history = getSearchHistory();
    if (!history.contains(query)) {
      history.insert(0, query);
      if (history.length > 10) {
        history.removeLast();
      }
      await setSearchHistory(history);
    }
  }

  Future<void> clearSearchHistory() async {
    await setSearchHistory([]);
  }
}