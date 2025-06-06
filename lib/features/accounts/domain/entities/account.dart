import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String id;
  final String userId;
  final String secret;
  final String serviceName;
  final String accountName;
  final String issuer;
  final OTPAlgorithm algorithm;
  final int digits;
  final int period;
  final int? counter;
  final OTPType type;
  final String? iconUrl;
  final String? category;
  final List<String> tags;
  final String? notes;
  final String? color;
  final int sortOrder;
  final bool isFavorite;
  final bool isArchived;
  final DateTime? lastUsedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final int version;

  const Account({
    required this.id,
    required this.userId,
    required this.secret,
    required this.serviceName,
    required this.accountName,
    required this.issuer,
    required this.algorithm,
    required this.digits,
    required this.period,
    this.counter,
    required this.type,
    this.iconUrl,
    this.category,
    required this.tags,
    this.notes,
    this.color,
    required this.sortOrder,
    required this.isFavorite,
    required this.isArchived,
    this.lastUsedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.version,
  });

  Account copyWith({
    String? id,
    String? userId,
    String? secret,
    String? serviceName,
    String? accountName,
    String? issuer,
    OTPAlgorithm? algorithm,
    int? digits,
    int? period,
    int? counter,
    OTPType? type,
    String? iconUrl,
    String? category,
    List<String>? tags,
    String? notes,
    String? color,
    int? sortOrder,
    bool? isFavorite,
    bool? isArchived,
    DateTime? lastUsedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    int? version,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      secret: secret ?? this.secret,
      serviceName: serviceName ?? this.serviceName,
      accountName: accountName ?? this.accountName,
      issuer: issuer ?? this.issuer,
      algorithm: algorithm ?? this.algorithm,
      digits: digits ?? this.digits,
      period: period ?? this.period,
      counter: counter ?? this.counter,
      type: type ?? this.type,
      iconUrl: iconUrl ?? this.iconUrl,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
    );
  }

  String get displayName => accountName.isNotEmpty ? accountName : serviceName;
  
  bool get isTimeBasedOTP => type == OTPType.totp;
  
  bool get isCounterBasedOTP => type == OTPType.hotp;

  @override
  List<Object?> get props => [
        id,
        userId,
        secret,
        serviceName,
        accountName,
        issuer,
        algorithm,
        digits,
        period,
        counter,
        type,
        iconUrl,
        category,
        tags,
        notes,
        color,
        sortOrder,
        isFavorite,
        isArchived,
        lastUsedAt,
        createdAt,
        updatedAt,
        syncStatus,
        version,
      ];
}

enum OTPType {
  totp,
  hotp,
}

enum OTPAlgorithm {
  sha1,
  sha256,
  sha512,
}

enum SyncStatus {
  synced,
  pending,
  failed,
  conflict,
}

extension OTPTypeExtension on OTPType {
  String get name {
    switch (this) {
      case OTPType.totp:
        return 'TOTP';
      case OTPType.hotp:
        return 'HOTP';
    }
  }
}

extension OTPAlgorithmExtension on OTPAlgorithm {
  String get name {
    switch (this) {
      case OTPAlgorithm.sha1:
        return 'SHA1';
      case OTPAlgorithm.sha256:
        return 'SHA256';
      case OTPAlgorithm.sha512:
        return 'SHA512';
    }
  }
}

extension SyncStatusExtension on SyncStatus {
  String get name {
    switch (this) {
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.pending:
        return 'Pending';
      case SyncStatus.failed:
        return 'Failed';
      case SyncStatus.conflict:
        return 'Conflict';
    }
  }
}

class AccountCategory extends Equatable {
  final String id;
  final String name;
  final String color;
  final String icon;
  final int accountCount;

  const AccountCategory({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.accountCount,
  });

  @override
  List<Object> get props => [id, name, color, icon, accountCount];
}