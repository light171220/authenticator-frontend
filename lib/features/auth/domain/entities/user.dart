import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final bool isEmailVerified;
  final bool isTwoFactorEnabled;
  final bool isBiometricEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? preferences;
  final List<String> deviceIds;
  final UserSubscription? subscription;
  final SecuritySettings securitySettings;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    required this.isEmailVerified,
    required this.isTwoFactorEnabled,
    required this.isBiometricEnabled,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    this.preferences,
    required this.deviceIds,
    this.subscription,
    required this.securitySettings,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    bool? isEmailVerified,
    bool? isTwoFactorEnabled,
    bool? isBiometricEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? preferences,
    List<String>? deviceIds,
    UserSubscription? subscription,
    SecuritySettings? securitySettings,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      deviceIds: deviceIds ?? this.deviceIds,
      subscription: subscription ?? this.subscription,
      securitySettings: securitySettings ?? this.securitySettings,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatarUrl,
        isEmailVerified,
        isTwoFactorEnabled,
        isBiometricEnabled,
        createdAt,
        updatedAt,
        lastLoginAt,
        preferences,
        deviceIds,
        subscription,
        securitySettings,
      ];
}

class UserSubscription extends Equatable {
  final String id;
  final String plan;
  final String status;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final Map<String, dynamic> features;

  const UserSubscription({
    required this.id,
    required this.plan,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.features,
  });

  @override
  List<Object?> get props => [id, plan, status, startDate, endDate, isActive, features];
}

class SecuritySettings extends Equatable {
  final bool requireBiometricAuth;
  final bool autoLockEnabled;
  final int autoLockTimeout;
  final bool requirePasswordOnStart;
  final bool showNotifications;
  final bool allowScreenshots;
  final String encryptionLevel;
  final bool enableSyncConflictResolution;

  const SecuritySettings({
    required this.requireBiometricAuth,
    required this.autoLockEnabled,
    required this.autoLockTimeout,
    required this.requirePasswordOnStart,
    required this.showNotifications,
    required this.allowScreenshots,
    required this.encryptionLevel,
    required this.enableSyncConflictResolution,
  });

  SecuritySettings copyWith({
    bool? requireBiometricAuth,
    bool? autoLockEnabled,
    int? autoLockTimeout,
    bool? requirePasswordOnStart,
    bool? showNotifications,
    bool? allowScreenshots,
    String? encryptionLevel,
    bool? enableSyncConflictResolution,
  }) {
    return SecuritySettings(
      requireBiometricAuth: requireBiometricAuth ?? this.requireBiometricAuth,
      autoLockEnabled: autoLockEnabled ?? this.autoLockEnabled,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      requirePasswordOnStart: requirePasswordOnStart ?? this.requirePasswordOnStart,
      showNotifications: showNotifications ?? this.showNotifications,
      allowScreenshots: allowScreenshots ?? this.allowScreenshots,
      encryptionLevel: encryptionLevel ?? this.encryptionLevel,
      enableSyncConflictResolution: enableSyncConflictResolution ?? this.enableSyncConflictResolution,
    );
  }

  @override
  List<Object> get props => [
        requireBiometricAuth,
        autoLockEnabled,
        autoLockTimeout,
        requirePasswordOnStart,
        showNotifications,
        allowScreenshots,
        encryptionLevel,
        enableSyncConflictResolution,
      ];
}