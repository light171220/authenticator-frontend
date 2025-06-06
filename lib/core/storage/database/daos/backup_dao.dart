import 'package:floor/floor.dart';
import '../entities/backup_entity.dart';

@dao
abstract class BackupDao {
  @Query('SELECT * FROM backups WHERE user_id = :userId ORDER BY created_at DESC')
  Future<List<BackupEntity>> getAllBackups(String userId);

  @Query('SELECT * FROM backups WHERE user_id = :userId AND backup_status = :status ORDER BY created_at DESC')
  Future<List<BackupEntity>> getBackupsByStatus(String userId, String status);

  @Query('SELECT * FROM backups WHERE user_id = :userId AND is_auto_backup = 1 ORDER BY created_at DESC')
  Future<List<BackupEntity>> getAutoBackups(String userId);

  @Query('SELECT * FROM backups WHERE user_id = :userId AND backup_type = :type ORDER BY created_at DESC')
  Future<List<BackupEntity>> getBackupsByType(String userId, String type);

  @Query('SELECT * FROM backups WHERE id = :id')
  Future<BackupEntity?> getBackupById(String id);

  @Query('SELECT * FROM backups WHERE user_id = :userId AND name = :name')
  Future<BackupEntity?> getBackupByName(String userId, String name);

  @Query('SELECT * FROM backups WHERE user_id = :userId AND checksum = :checksum')
  Future<BackupEntity?> getBackupByChecksum(String userId, String checksum);

  @Query('SELECT COUNT(*) FROM backups WHERE user_id = :userId')
  Future<int?> getBackupCount(String userId);

  @Query('SELECT SUM(file_size) FROM backups WHERE user_id = :userId')
  Future<int?> getTotalBackupSize(String userId);

  @Query('SELECT * FROM backups WHERE user_id = :userId AND expires_at IS NOT NULL AND expires_at < :currentTime')
  Future<List<BackupEntity>> getExpiredBackups(String userId, int currentTime);

  @Query('SELECT * FROM backups WHERE user_id = :userId AND created_at >= :startTime AND created_at <= :endTime ORDER BY created_at DESC')
  Future<List<BackupEntity>> getBackupsInRange(String userId, int startTime, int endTime);

  @Query('UPDATE backups SET backup_status = :status WHERE id = :id')
  Future<void> updateBackupStatus(String id, String status);

  @Query('UPDATE backups SET restore_count = restore_count + 1 WHERE id = :id')
  Future<void> incrementRestoreCount(String id);

  @Query('UPDATE backups SET last_verified_at = :timestamp WHERE id = :id')
  Future<void> updateLastVerified(String id, int timestamp);

  @Query('DELETE FROM backups WHERE user_id = :userId AND expires_at IS NOT NULL AND expires_at < :currentTime')
  Future<void> deleteExpiredBackups(String userId, int currentTime);

  @Query('DELETE FROM backups WHERE user_id = :userId')
  Future<void> deleteAllUserBackups(String userId);

  @insert
  Future<void> insertBackup(BackupEntity backup);

  @insert
  Future<void> insertBackups(List<BackupEntity> backups);

  @update
  Future<void> updateBackup(BackupEntity backup);

  @update
  Future<void> updateBackups(List<BackupEntity> backups);

  @delete
  Future<void> deleteBackup(BackupEntity backup);

  @Query('DELETE FROM backups WHERE id = :id')
  Future<void> deleteBackupById(String id);
}