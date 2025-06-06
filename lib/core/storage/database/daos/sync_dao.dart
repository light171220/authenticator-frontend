import 'package:floor/floor.dart';
import '../entities/sync_entity.dart';

@dao
abstract class SyncDao {
  @Query('SELECT * FROM sync_events WHERE user_id = :userId ORDER BY sequence_number ASC')
  Future<List<SyncEntity>> getAllSyncEvents(String userId);

  @Query('SELECT * FROM sync_events WHERE user_id = :userId AND sync_status = :status ORDER BY priority DESC, created_at ASC')
  Future<List<SyncEntity>> getSyncEventsByStatus(String userId, String status);

  @Query('SELECT * FROM sync_events WHERE user_id = :userId AND device_id = :deviceId ORDER BY sequence_number ASC')
  Future<List<SyncEntity>> getSyncEventsByDevice(String userId, String deviceId);

  @Query('SELECT * FROM sync_events WHERE user_id = :userId AND entity_type = :entityType ORDER BY sequence_number ASC')
  Future<List<SyncEntity>> getSyncEventsByEntityType(String userId, String entityType);

  @Query('SELECT * FROM sync_events WHERE user_id = :userId AND entity_id = :entityId ORDER BY sequence_number ASC')
  Future<List<SyncEntity>> getSyncEventsByEntityId(String userId, String entityId);

  @Query('SELECT * FROM sync_events WHERE id = :id')
  Future<SyncEntity?> getSyncEventById(String id);

  @Query('SELECT * FROM sync_events WHERE user_id = :userId AND sync_status = "pending" ORDER BY priority DESC, created_at ASC LIMIT :limit')
  Future<List<SyncEntity>> getPendingSyncEvents(String userId, int limit);

  @Query('SELECT * FROM sync_events WHERE user_id = :userId AND sync_status = "failed" AND retry_count < 3 ORDER BY created_at ASC')
  Future<List<SyncEntity>> getFailedSyncEvents(String userId);

  @Query('SELECT * FROM sync_events WHERE user_id = :userId AND expires_at IS NOT NULL AND expires_at < :currentTime')
  Future<List<SyncEntity>> getExpiredSyncEvents(String userId, int currentTime);

  @Query('SELECT MAX(sequence_number) FROM sync_events WHERE user_id = :userId')
  Future<int?> getMaxSequenceNumber(String userId);

  @Query('SELECT COUNT(*) FROM sync_events WHERE user_id = :userId AND sync_status = "pending"')
  Future<int?> getPendingSyncCount(String userId);

  @Query('SELECT DISTINCT device_id FROM sync_events WHERE user_id = :userId')
  Future<List<String>> getDeviceIds(String userId);

  @Query('UPDATE sync_events SET sync_status = :status, synced_at = :syncedAt WHERE id = :id')
  Future<void> updateSyncStatus(String id, String status, int? syncedAt);

  @Query('UPDATE sync_events SET retry_count = retry_count + 1 WHERE id = :id')
  Future<void> incrementRetryCount(String id);

  @Query('UPDATE sync_events SET conflict_resolution = :resolution WHERE id = :id')
  Future<void> updateConflictResolution(String id, String resolution);

  @Query('DELETE FROM sync_events WHERE user_id = :userId AND sync_status = "synced" AND synced_at < :cutoffTime')
  Future<void> deleteOldSyncedEvents(String userId, int cutoffTime);

  @Query('DELETE FROM sync_events WHERE user_id = :userId AND expires_at IS NOT NULL AND expires_at < :currentTime')
  Future<void> deleteExpiredSyncEvents(String userId, int currentTime);

  @Query('DELETE FROM sync_events WHERE user_id = :userId')
  Future<void> deleteAllUserSyncEvents(String userId);

  @insert
  Future<void> insertSyncEvent(SyncEntity syncEvent);

  @insert
  Future<void> insertSyncEvents(List<SyncEntity> syncEvents);

  @update
  Future<void> updateSyncEvent(SyncEntity syncEvent);

  @update
  Future<void> updateSyncEvents(List<SyncEntity> syncEvents);

  @delete
  Future<void> deleteSyncEvent(SyncEntity syncEvent);

  @Query('DELETE FROM sync_events WHERE id = :id')
  Future<void> deleteSyncEventById(String id);
}