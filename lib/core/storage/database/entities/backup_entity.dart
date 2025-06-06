import 'package:floor/floor.dart';

@Entity(tableName: 'backups')
class BackupEntity {
  @PrimaryKey()
  final String id;

  @ColumnInfo(name: 'user_id')
  final String userId;

  @ColumnInfo(name: 'name')
  final String name;

  @ColumnInfo(name: 'description')
  final String? description;

  @ColumnInfo(name: 'file_path')
  final String? filePath;

  @ColumnInfo(name: 'remote_url')
  final String? remoteUrl;

  @ColumnInfo(name: 'file_size')
  final int fileSize;

  @ColumnInfo(name: 'compressed_size')
  final int? compressedSize;

  @ColumnInfo(name: 'encryption_algorithm')
  final String encryptionAlgorithm;

  @ColumnInfo(name: 'compression_algorithm')
  final String? compressionAlgorithm;

  @ColumnInfo(name: 'checksum')
  final String checksum;

  @ColumnInfo(name: 'account_count')
  final int accountCount;

  @ColumnInfo(name: 'backup_type')
  final String backupType;

  @ColumnInfo(name: 'backup_status')
  final String backupStatus;

  @ColumnInfo(name: 'is_auto_backup')
  final bool isAutoBackup;

  @ColumnInfo(name: 'is_encrypted')
  final bool isEncrypted;

  @ColumnInfo(name: 'password_protected')
  final bool passwordProtected;

  @ColumnInfo(name: 'metadata')
  final String? metadata;

  @ColumnInfo(name: 'created_at')
  final int createdAt;

  @ColumnInfo(name: 'updated_at')
  final int updatedAt;

  @ColumnInfo(name: 'expires_at')
  final int? expiresAt;

  @ColumnInfo(name: 'last_verified_at')
  final int? lastVerifiedAt;

  @ColumnInfo(name: 'restore_count')
  final int restoreCount;

  @ColumnInfo(name: 'version')
  final int version;

  const BackupEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.filePath,
    this.remoteUrl,
    required this.fileSize,
    this.compressedSize,
    required this.encryptionAlgorithm,
    this.compressionAlgorithm,
    required this.checksum,
    required this.accountCount,
    required this.backupType,
    required this.backupStatus,
    required this.isAutoBackup,
    required this.isEncrypted,
    required this.passwordProtected,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.expiresAt,
    this.lastVerifiedAt,
    required this.restoreCount,
    required this.version,
  });

  BackupEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? filePath,
    String? remoteUrl,
    int? fileSize,
    int? compressedSize,
    String? encryptionAlgorithm,
    String? compressionAlgorithm,
    String? checksum,
    int? accountCount,
    String? backupType,
    String? backupStatus,
    bool? isAutoBackup,
    bool? isEncrypted,
    bool? passwordProtected,
    String? metadata,
    int? createdAt,
    int? updatedAt,
    int? expiresAt,
    int? lastVerifiedAt,
    int? restoreCount,
    int? version,
  }) {
    return BackupEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      fileSize: fileSize ?? this.fileSize,
      compressedSize: compressedSize ?? this.compressedSize,
      encryptionAlgorithm: encryptionAlgorithm ?? this.encryptionAlgorithm,
      compressionAlgorithm: compressionAlgorithm ?? this.compressionAlgorithm,
      checksum: checksum ?? this.checksum,
      accountCount: accountCount ?? this.accountCount,
      backupType: backupType ?? this.backupType,
      backupStatus: backupStatus ?? this.backupStatus,
      isAutoBackup: isAutoBackup ?? this.isAutoBackup,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      passwordProtected: passwordProtected ?? this.passwordProtected,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
      restoreCount: restoreCount ?? this.restoreCount,
      version: version ?? this.version,
    );
  }
}