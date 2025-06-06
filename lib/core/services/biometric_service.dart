import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import '../utils/logger/app_logger.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      if (!isSupported) return false;

      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      AppLogger.error('Error checking biometric availability: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      AppLogger.error('Error getting available biometrics: $e');
      return [];
    }
  }

  Future<bool> authenticate({
    required String localizedFallbackTitle,
    required String reason,
    bool biometricOnly = false,
  }) async {
    try {
      final isAvailable = await this.isAvailable();
      if (!isAvailable) {
        AppLogger.warning('Biometric authentication not available');
        return false;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedFallbackTitle: localizedFallbackTitle,
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Biometric authentication required',
            cancelButton: 'No thanks',
            biometricHint: 'Verify your identity',
            biometricNotRecognized: 'Not recognized, try again',
            biometricRequiredTitle: 'Biometric required',
            biometricSuccess: 'Biometric authentication succeeded',
            deviceCredentialsRequiredTitle: 'Device credential required',
            deviceCredentialsSetupDescription: 'Device credential setup required',
            goToSettingsButton: 'Go to settings',
            goToSettingsDescription: 'Setup biometric or screen lock',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
            goToSettingsButton: 'Go to settings',
            goToSettingsDescription: 'Setup biometric or screen lock',
            lockOut: 'Please reenable your Touch ID or Face ID',
          ),
        ],
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        AppLogger.info('Biometric authentication successful');
      } else {
        AppLogger.warning('Biometric authentication failed');
      }

      return didAuthenticate;
    } catch (e) {
      AppLogger.error('Biometric authentication error: $e');
      return false;
    }
  }

  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      AppLogger.error('Error checking if can check biometrics: $e');
      return false;
    }
  }

  Future<bool> stopAuthentication() async {
    try {
      return await _localAuth.stopAuthentication();
    } catch (e) {
      AppLogger.error('Error stopping authentication: $e');
      return false;
    }
  }

  String getBiometricTypeString(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
    }
  }

  Future<String> getPrimaryBiometricType() async {
    final availableBiometrics = await getAvailableBiometrics();
    
    if (availableBiometrics.isEmpty) {
      return 'None';
    }

    if (availableBiometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (availableBiometrics.contains(BiometricType.iris)) {
      return 'Iris';
    } else if (availableBiometrics.contains(BiometricType.strong)) {
      return 'Strong Biometric';
    } else {
      return 'Biometric';
    }
  }

  Future<bool> hasEnrolledBiometrics() async {
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.isNotEmpty;
  }
}