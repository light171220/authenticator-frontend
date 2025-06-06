import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entities/account_entity.dart';
import 'entities/backup_entity.dart';
import 'entities/sync_entity.dart';
import 'daos/account_dao.dart';
import 'daos/backup_dao.dart';
import 'daos/sync_dao.dart';

part 'app_database.g.dart';

@Database(
  version: 1,
  entities: [
    AccountEntity,
    BackupEntity,
    SyncEntity,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  AccountDao get accountDao;
  BackupDao get backupDao;
  SyncDao get syncDao;

  static Future<AppDatabase> create() async {
    return await $FloorAppDatabase
        .databaseBuilder('pqc_authenticator.db')
        .addMigrations([])
        .build();
  }
}