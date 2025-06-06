import 'package:floor/floor.dart';

@Entity(tableName: 'sync_events')
class SyncEntity {
  @PrimaryKey()
  final String id;

  @ColumnInfo(name: 'user_id')
  final String userId;

  @ColumnInfo(name: 'device_id')
  final String deviceId;

  @ColumnInfo(name: 'event_type')
  final String eventType;

  @ColumnInfo(name: 'entity_type')
  final String entityType;

  @ColumnInfo(name: 'entity_id')
  final String entityId;

  @ColumnInfo(name: 'action')
  final String action;

  @ColumnInfo(name: 'data')
  final String? data;

  @ColumnInfo(name: 'metadata')
  final String? metadata;

  @ColumnInfo(name: 'sync_status')
  final String syncStatus;

  @ColumnInfo(name: 'conflict_resolution')
  final String? conflictResolution;

  @ColumnInfo(name: 'retry_count')
  final int retryCount;

  @ColumnInfo(name: 'priority')
  final int priority;

  @ColumnInfo(name: 'sequence_number')
  final int sequenceNumber;

  @ColumnInfo(name: 'checksum')
  final String? checksum;

  @ColumnInfo(name: 'created_at')
  final int createdAt;

  @ColumnInfo(name: 'updated_at')
  final int updatedAt;

  @ColumnInfo(name: 'synced_at')
  final int? syncedAt;

  @ColumnInfo(name: 'expires_at')
  final int? expiresAt;

  @ColumnInfo(name: 'version')
  final int version;

  const SyncEntity({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.eventType,
    required this.entityType,
    required this.entityId,
    required this.action,
    this.data,
    this.metadata,
    required this.syncStatus,
    this.conflictResolution,
    required this.retryCount,
    required this.priority,
    required this.sequenceNumber,
    this.checksum,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
    this.expiresAt,
    required this.version,
  });

  SyncEntity copyWith({
    String? id,
    String? userId,
    String? deviceId,
    String? eventType,
    String? entityType,
    String? entityId,
    String? action,
    String? data,
    String? metadata,
    String? syncStatus,
    String? conflictResolution,
    int? retryCount,
    int? priority,
    int? sequenceNumber,
    String? checksum,
    int? createdAt,
    int? updatedAt,
    int? syncedAt,
    int? expiresAt,
    int? version,
  }) {
    return SyncEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      eventType: eventType ?? this.eventType,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      data: data ?? this.data,
      metadata: metadata ?? this.metadata,
      syncStatus: syncStatus ?? this.syncStatus,
      conflictResolution: conflictResolution ?? this.conflictResolution,
      retryCount: retryCount ?? this.retryCount,
      priority: priority ?? this.priority,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      checksum: checksum ?? this.checksum,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      version: version ?? this.version,
    );
  }
}