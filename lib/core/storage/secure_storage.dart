import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../crypto/pqc_crypto.dart';
import '../utils/logger/app_logger.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'pqc_auth_secure_prefs',
      preferencesKeyPrefix: 'pqc_',
    ),
    iOptions: IOSOptions(
      groupId: 'group.com.yourcompany.pqcauth',
      accountName: 'PQCAuthenticator',
    ),
  );

  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _masterKeyKey = 'master_key';
  static const String _biometricKeyKey = 'biometric_key';
  static const String _pqcPublicKeyKey = 'pqc_public_key';
  static const String _pqcPrivateKeyKey = 'pqc_private_key';
  static const String _encryptionSaltKey = 'encryption_salt';
  static const String _deviceIdKey = 'device_id';
  static const String _lastSyncKey = 'last_sync';

  Future<void> storeAuthToken(String token) async {
    try {
      await _storage.write(key: _authTokenKey, value: token);
      AppLogger.info('Auth token stored securely');
    } catch (e) {
      AppLogger.error('Failed to store auth token: $e');
      rethrow;
    }
  }

  Future<String?> getAuthToken() async {
    try {
      return await _storage.read(key: _authTokenKey);
    } catch (e) {
      AppLogger.error('Failed to retrieve auth token: $e');
      return null;
    }
  }

  Future<void> storeRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
      AppLogger.info('Refresh token stored securely');
    } catch (e) {
      AppLogger.error('Failed to store refresh token: $e');
      rethrow;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      AppLogger.error('Failed to retrieve refresh token: $e');
      return null;
    }
  }

  Future<void> storeUserId(String userId) async {
    try {
      await _storage.write(key: _userIdKey, value: userId);
    } catch (e) {
      AppLogger.error('Failed to store user ID: $e');
      rethrow;
    }
  }

  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _userIdKey);
    } catch (e) {
      AppLogger.error('Failed to retrieve user ID: $e');
      return null;
    }
  }

  Future<void> storeMasterKey(Uint8List key) async {
    try {
      final encoded = base64Encode(key);
      await _storage.write(key: _masterKeyKey, value: encoded);
      AppLogger.info('Master key stored securely');
    } catch (e) {
      AppLogger.error('Failed to store master key: $e');
      rethrow;
    }
  }

  Future<Uint8List?> getMasterKey() async {
    try {
      final encoded = await _storage.read(key: _masterKeyKey);
      if (encoded == null) return null;
      return base64Decode(encoded);
    } catch (e) {
      AppLogger.error('Failed to retrieve master key: $e');
      return null;
    }
  }

  Future<void> storeBiometricKey(String keyAlias, Uint8List key) async {
    try {
      final encoded = base64Encode(key);
      await _storage.write(key: '${_biometricKeyKey}_$keyAlias', value: encoded);
      AppLogger.info('Biometric key stored securely');
    } catch (e) {
      AppLogger.error('Failed to store biometric key: $e');
      rethrow;
    }
  }

  Future<Uint8List?> getBiometricKey(String keyAlias) async {
    try {
      final encoded = await _storage.read(key: '${_biometricKeyKey}_$keyAlias');
      if (encoded == null) return null;
      return base64Decode(encoded);
    } catch (e) {
      AppLogger.error('Failed to retrieve biometric key: $e');
      return null;
    }
  }

  Future<void> storePQCKeyPair(HybridKeyPair keyPair) async {
    try {
      final publicKeyData = {
        'kyber': base64Encode(keyPair.kyberKeyPair.publicKey.bytes),
        'dilithium': base64Encode(keyPair.dilithiumKeyPair.publicKey.bytes),
      };
      final privateKeyData = {
        'kyber': base64Encode(keyPair.kyberKeyPair.privateKey.bytes),
        'dilithium': base64Encode(keyPair.dilithiumKeyPair.privateKey.bytes),
      };

      await _storage.write(
        key: _pqcPublicKeyKey,
        value: jsonEncode(publicKeyData),
      );
      await _storage.write(
        key: _pqcPrivateKeyKey,
        value: jsonEncode(privateKeyData),
      );
      
      AppLogger.info('PQC key pair stored securely');
    } catch (e) {
      AppLogger.error('Failed to store PQC key pair: $e');
      rethrow;
    }
  }

  Future<HybridKeyPair?> getPQCKeyPair() async {
    try {
      final publicKeyJson = await _storage.read(key: _pqcPublicKeyKey);
      final privateKeyJson = await _storage.read(key: _pqcPrivateKeyKey);
      
      if (publicKeyJson == null || privateKeyJson == null) {
        return null;
      }

      final publicKeyData = jsonDecode(publicKeyJson) as Map<String, dynamic>;
      final privateKeyData = jsonDecode(privateKeyJson) as Map<String, dynamic>;

      final kyberKeyPair = KyberKeyPair(
        publicKey: KyberPublicKey(base64Decode(publicKeyData['kyber'])),
        privateKey: KyberPrivateKey(base64Decode(privateKeyData['kyber'])),
      );

      final dilithiumKeyPair = DilithiumKeyPair(
        publicKey: DilithiumPublicKey(base64Decode(publicKeyData['dilithium'])),
        privateKey: DilithiumPrivateKey(base64Decode(privateKeyData['dilithium'])),
      );

      return HybridKeyPair(
        kyberKeyPair: kyberKeyPair,
        dilithiumKeyPair: dilithiumKeyPair,
      );
    } catch (e) {
      AppLogger.error('Failed to retrieve PQC key pair: $e');
      return null;
    }
  }

  Future<void> storeEncryptionSalt(Uint8List salt) async {
    try {
      final encoded = base64Encode(salt);
      await _storage.write(key: _encryptionSaltKey, value: encoded);
    } catch (e) {
      AppLogger.error('Failed to store encryption salt: $e');
      rethrow;
    }
  }

  Future<Uint8List?> getEncryptionSalt() async {
    try {
      final encoded = await _storage.read(key: _encryptionSaltKey);
      if (encoded == null) return null;
      return base64Decode(encoded);
    } catch (e) {
      AppLogger.error('Failed to retrieve encryption salt: $e');
      return null;
    }
  }

  Future<void> storeDeviceId(String deviceId) async {
    try {
      await _storage.write(key: _deviceIdKey, value: deviceId);
    } catch (e) {
      AppLogger.error('Failed to store device ID: $e');
      rethrow;
    }
  }

  Future<String?> getDeviceId() async {
    try {
      return await _storage.read(key: _deviceIdKey);
    } catch (e) {
      AppLogger.error('Failed to retrieve device ID: $e');
      return null;
    }
  }

  Future<void> storeLastSyncTime(DateTime dateTime) async {
    try {
      await _storage.write(
        key: _lastSyncKey,
        value: dateTime.millisecondsSinceEpoch.toString(),
      );
    } catch (e) {
      AppLogger.error('Failed to store last sync time: $e');
      rethrow;
    }
  }

  Future<DateTime?> getLastSyncTime() async {
    try {
      final timestampStr = await _storage.read(key: _lastSyncKey);
      if (timestampStr == null) return null;
      final timestamp = int.tryParse(timestampStr);
      if (timestamp == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      AppLogger.error('Failed to retrieve last sync time: $e');
      return null;
    }
  }

  Future<void> storeCustomData(String key, String value) async {
    try {
      await _storage.write(key: 'custom_$key', value: value);
    } catch (e) {
      AppLogger.error('Failed to store custom data for key $key: $e');
      rethrow;
    }
  }

  Future<String?> getCustomData(String key) async {
    try {
      return await _storage.read(key: 'custom_$key');
    } catch (e) {
      AppLogger.error('Failed to retrieve custom data for key $key: $e');
      return null;
    }
  }

  Future<void> deleteKey(String key) async {
    try {
      await _storage.delete(key: key);
      AppLogger.info('Key $key deleted from secure storage');
    } catch (e) {
      AppLogger.error('Failed to delete key $key: $e');
      rethrow;
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      AppLogger.info('All secure storage data cleared');
    } catch (e) {
      AppLogger.error('Failed to clear secure storage: $e');
      rethrow;
    }
  }

  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      AppLogger.error('Failed to check if key exists: $e');
      return false;
    }
  }

  bool hasAuthToken() {
    try {
      return _storage.read(key: _authTokenKey) != null;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, String>> getAllKeys() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      AppLogger.error('Failed to retrieve all keys: $e');
      return {};
    }
  }
}