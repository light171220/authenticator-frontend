import 'package:floor/floor.dart';
import '../entities/account_entity.dart';

@dao
abstract class AccountDao {
  @Query('SELECT * FROM accounts WHERE user_id = :userId AND is_archived = 0 ORDER BY sort_order ASC, service_name ASC')
  Future<List<AccountEntity>> getAllAccounts(String userId);

  @Query('SELECT * FROM accounts WHERE user_id = :userId AND is_favorite = 1 AND is_archived = 0 ORDER BY sort_order ASC')
  Future<List<AccountEntity>> getFavoriteAccounts(String userId);

  @Query('SELECT * FROM accounts WHERE user_id = :userId AND is_archived = 1 ORDER BY updated_at DESC')
  Future<List<AccountEntity>> getArchivedAccounts(String userId);

  @Query('SELECT * FROM accounts WHERE id = :id')
  Future<AccountEntity?> getAccountById(String id);

  @Query('SELECT * FROM accounts WHERE user_id = :userId AND (service_name LIKE :query OR account_name LIKE :query OR issuer LIKE :query)')
  Future<List<AccountEntity>> searchAccounts(String userId, String query);

  @Query('SELECT * FROM accounts WHERE user_id = :userId AND category = :category AND is_archived = 0')
  Future<List<AccountEntity>> getAccountsByCategory(String userId, String category);

  @Query('SELECT DISTINCT category FROM accounts WHERE user_id = :userId AND category IS NOT NULL AND is_archived = 0')
  Future<List<String?>> getCategories(String userId);

  @Query('SELECT * FROM accounts WHERE user_id = :userId AND sync_status != "synced"')
  Future<List<AccountEntity>> getUnsyncedAccounts(String userId);

  @Query('SELECT COUNT(*) FROM accounts WHERE user_id = :userId AND is_archived = 0')
  Future<int?> getAccountCount(String userId);

  @Query('UPDATE accounts SET last_used_at = :timestamp WHERE id = :id')
  Future<void> updateLastUsed(String id, int timestamp);

  @Query('UPDATE accounts SET sort_order = :sortOrder WHERE id = :id')
  Future<void> updateSortOrder(String id, int sortOrder);

  @Query('UPDATE accounts SET is_favorite = :isFavorite WHERE id = :id')
  Future<void> updateFavoriteStatus(String id, bool isFavorite);

  @Query('UPDATE accounts SET is_archived = :isArchived WHERE id = :id')
  Future<void> updateArchivedStatus(String id, bool isArchived);

  @Query('UPDATE accounts SET sync_status = :status WHERE id = :id')
  Future<void> updateSyncStatus(String id, String status);

  @Query('DELETE FROM accounts WHERE user_id = :userId AND is_archived = 1')
  Future<void> deleteArchivedAccounts(String userId);

  @Query('DELETE FROM accounts WHERE user_id = :userId')
  Future<void> deleteAllUserAccounts(String userId);

  @insert
  Future<void> insertAccount(AccountEntity account);

  @insert
  Future<void> insertAccounts(List<AccountEntity> accounts);

  @update
  Future<void> updateAccount(AccountEntity account);

  @update
  Future<void> updateAccounts(List<AccountEntity> accounts);

  @delete
  Future<void> deleteAccount(AccountEntity account);

  @Query('DELETE FROM accounts WHERE id = :id')
  Future<void> deleteAccountById(String id);
}