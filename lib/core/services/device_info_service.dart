import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../utils/logger/app_logger.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  Future<DeviceInfo> getDeviceInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return DeviceInfo(
          deviceId: androidInfo.id,
          deviceName: _getAndroidDeviceName(androidInfo),
          deviceType: 'Android',
          osVersion: androidInfo.version.release,
          appVersion: packageInfo.version,
          buildNumber: packageInfo.buildNumber,
          manufacturer: androidInfo.manufacturer,
          model: androidInfo.model,
          brand: androidInfo.brand,
          isPhysicalDevice: androidInfo.isPhysicalDevice,
          fingerprint: androidInfo.fingerprint,
          supportedAbis: androidInfo.supportedAbis,
        );
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return DeviceInfo(
          deviceId: iosInfo.identifierForVendor ?? 'unknown',
          deviceName: iosInfo.name,
          deviceType: 'iOS',
          osVersion: iosInfo.systemVersion,
          appVersion: packageInfo.version,
          buildNumber: packageInfo.buildNumber,
          manufacturer: 'Apple',
          model: iosInfo.model,
          brand: 'Apple',
          isPhysicalDevice: iosInfo.isPhysicalDevice,
          fingerprint: iosInfo.identifierForVendor ?? 'unknown',
          supportedAbis: [],
        );
      } else {
        return DeviceInfo(
          deviceId: 'unknown',
          deviceName: 'Unknown Device',
          deviceType: Platform.operatingSystem,
          osVersion: Platform.operatingSystemVersion,
          appVersion: packageInfo.version,
          buildNumber: packageInfo.buildNumber,
          manufacturer: 'Unknown',
          model: 'Unknown',
          brand: 'Unknown',
          isPhysicalDevice: true,
          fingerprint: 'unknown',
          supportedAbis: [],
        );
      }
    } catch (e) {
      AppLogger.error('Failed to get device info: $e');
      return DeviceInfo.unknown();
    }
  }

  String _getAndroidDeviceName(AndroidDeviceInfo androidInfo) {
    final manufacturer = androidInfo.manufacturer;
    final model = androidInfo.model;
    
    if (model.toLowerCase().startsWith(manufacturer.toLowerCase())) {
      return model;
    } else {
      return '$manufacturer $model';
    }
  }

  Future<bool> isDeviceRooted() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return !androidInfo.isPhysicalDevice;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return !iosInfo.isPhysicalDevice;
      }
      return false;
    } catch (e) {
      AppLogger.error('Failed to check if device is rooted: $e');
      return false;
    }
  }

  Future<bool> isEmulator() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return !androidInfo.isPhysicalDevice;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return !iosInfo.isPhysicalDevice;
      }
      return false;
    } catch (e) {
      AppLogger.error('Failed to check if device is emulator: $e');
      return false;
    }
  }

  Future<String> generateDeviceFingerprint() async {
    try {
      final deviceInfo = await getDeviceInfo();
      final fingerprint = '${deviceInfo.manufacturer}_${deviceInfo.model}_${deviceInfo.osVersion}_${deviceInfo.deviceId}';
      return fingerprint.replaceAll(' ', '_').toLowerCase();
    } catch (e) {
      AppLogger.error('Failed to generate device fingerprint: $e');
      return 'unknown_device';
    }
  }
}

class DeviceInfo {
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final String osVersion;
  final String appVersion;
  final String buildNumber;
  final String manufacturer;
  final String model;
  final String brand;
  final bool isPhysicalDevice;
  final String fingerprint;
  final List<String> supportedAbis;

  const DeviceInfo({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.osVersion,
    required this.appVersion,
    required this.buildNumber,
    required this.manufacturer,
    required this.model,
    required this.brand,
    required this.isPhysicalDevice,
    required this.fingerprint,
    required this.supportedAbis,
  });

  factory DeviceInfo.unknown() {
    return const DeviceInfo(
      deviceId: 'unknown',
      deviceName: 'Unknown Device',
      deviceType: 'Unknown',
      osVersion: 'Unknown',
      appVersion: '1.0.0',
      buildNumber: '1',
      manufacturer: 'Unknown',
      model: 'Unknown',
      brand: 'Unknown',
      isPhysicalDevice: true,
      fingerprint: 'unknown',
      supportedAbis: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'osVersion': osVersion,
      'appVersion': appVersion,
      'buildNumber': buildNumber,
      'manufacturer': manufacturer,
      'model': model,
      'brand': brand,
      'isPhysicalDevice': isPhysicalDevice,
      'fingerprint': fingerprint,
      'supportedAbis': supportedAbis,
    };
  }

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      deviceId: json['deviceId'] ?? 'unknown',
      deviceName: json['deviceName'] ?? 'Unknown Device',
      deviceType: json['deviceType'] ?? 'Unknown',
      osVersion: json['osVersion'] ?? 'Unknown',
      appVersion: json['appVersion'] ?? '1.0.0',
      buildNumber: json['buildNumber'] ?? '1',
      manufacturer: json['manufacturer'] ?? 'Unknown',
      model: json['model'] ?? 'Unknown',
      brand: json['brand'] ?? 'Unknown',
      isPhysicalDevice: json['isPhysicalDevice'] ?? true,
      fingerprint: json['fingerprint'] ?? 'unknown',
      supportedAbis: List<String>.from(json['supportedAbis'] ?? []),
    );
  }
}