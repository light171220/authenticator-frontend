class ApiConstants {
  static const String baseUrl = 'https://api.pqcauth.com/v1';
  static const String stagingUrl = 'https://staging-api.pqcauth.com/v1';
  static const String developmentUrl = 'http://localhost:8080/v1';
  
  static const bool enablePrettyLogging = true;
  static const int defaultTimeout = 30000;
  
  static const String authEndpoint = '/auth';
  static const String accountsEndpoint = '/accounts';
  static const String backupEndpoint = '/backup';
  static const String syncEndpoint = '/sync';
  static const String userEndpoint = '/user';
  
  static const String loginPath = '$authEndpoint/login';
  static const String registerPath = '$authEndpoint/register';
  static const String logoutPath = '$authEndpoint/logout';
  static const String refreshTokenPath = '$authEndpoint/refresh';
  static const String biometricLoginPath = '$authEndpoint/biometric';
  static const String twoFactorPath = '$authEndpoint/2fa';
  static const String passwordResetPath = '$authEndpoint/password-reset';
  static const String emailVerificationPath = '$authEndpoint/verify-email';
  
  static const String getAccountsPath = '$accountsEndpoint';
  static const String addAccountPath = '$accountsEndpoint';
  static const String updateAccountPath = '$accountsEndpoint';
  static const String deleteAccountPath = '$accountsEndpoint';
  static const String generateOtpPath = '$accountsEndpoint/otp';
  static const String exportAccountsPath = '$accountsEndpoint/export';
  static const String importAccountsPath = '$accountsEndpoint/import';
  
  static const String createBackupPath = '$backupEndpoint';
  static const String getBackupsPath = '$backupEndpoint';
  static const String restoreBackupPath = '$backupEndpoint/restore';
  static const String deleteBackupPath = '$backupEndpoint';
  static const String downloadBackupPath = '$backupEndpoint/download';
  
  static const String syncStatusPath = '$syncEndpoint/status';
  static const String syncEventsPath = '$syncEndpoint/events';
  static const String syncConflictsPath = '$syncEndpoint/conflicts';
  static const String devicesPath = '$syncEndpoint/devices';
  
  static const String profilePath = '$userEndpoint/profile';
  static const String securitySettingsPath = '$userEndpoint/security';
  static const String changePasswordPath = '$userEndpoint/password';
  static const String deleteAccountPath = '$userEndpoint/delete';
  static const String sessionsPath = '$userEndpoint/sessions';
  
  static const String websocketUrl = 'wss://api.pqcauth.com/ws';
  static const String stagingWebsocketUrl = 'wss://staging-api.pqcauth.com/ws';
  static const String developmentWebsocketUrl = 'ws://localhost:8080/ws';
  
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'PQCAuthenticator/1.0.0',
    'X-API-Version': 'v1',
  };
  
  static const Map<String, String> authHeaders = {
    'Authorization': 'Bearer',
  };
  
  static const Map<String, String> pqcHeaders = {
    'X-PQC-Algorithm': 'Kyber1024+Dilithium5',
    'X-PQC-Signature': '',
    'X-Device-ID': '',
    'X-Device-Fingerprint': '',
  };
  
  static const List<String> certificatePins = [
    'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
    'sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
  ];
  
  static const Map<String, dynamic> networkConfig = {
    'connectTimeout': 30000,
    'receiveTimeout': 30000,
    'sendTimeout': 30000,
    'maxRedirects': 3,
    'followRedirects': true,
  };
  
  static const Map<String, dynamic> retryConfig = {
    'maxRetries': 3,
    'retryDelay': 1000,
    'exponentialBackoff': true,
    'retryOnConnectionError': true,
    'retryOnTimeout': true,
  };
  
  static const Map<String, dynamic> cacheConfig = {
    'enableCaching': true,
    'maxCacheSize': 50 * 1024 * 1024,
    'defaultCacheDuration': 300000,
    'staleWhileRevalidate': true,
  };
}