import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../network/api_client.dart';
import '../storage/secure_storage.dart';
import '../storage/preferences.dart';
import '../storage/database/app_database.dart';
import '../crypto/pqc_crypto.dart';
import '../services/biometric_service.dart';
import '../services/notification_service.dart';
import '../services/background_service.dart';
import '../services/device_info_service.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/biometric_auth_usecase.dart';
import '../../features/auth/bloc/auth_bloc.dart';

import '../../features/accounts/data/datasources/accounts_remote_datasource.dart';
import '../../features/accounts/data/datasources/accounts_local_datasource.dart';
import '../../features/accounts/data/repositories/accounts_repository_impl.dart';
import '../../features/accounts/domain/repositories/accounts_repository.dart';
import '../../features/accounts/domain/usecases/add_account_usecase.dart';
import '../../features/accounts/domain/usecases/get_accounts_usecase.dart';
import '../../features/accounts/domain/usecases/delete_account_usecase.dart';
import '../../features/accounts/domain/usecases/generate_otp_usecase.dart';
import '../../features/accounts/domain/usecases/scan_qr_usecase.dart';
import '../../features/accounts/bloc/accounts_bloc.dart';

import '../../features/backup/data/datasources/backup_remote_datasource.dart';
import '../../features/backup/data/datasources/backup_local_datasource.dart';
import '../../features/backup/data/repositories/backup_repository_impl.dart';
import '../../features/backup/domain/repositories/backup_repository.dart';
import '../../features/backup/domain/usecases/create_backup_usecase.dart';
import '../../features/backup/domain/usecases/restore_backup_usecase.dart';
import '../../features/backup/domain/usecases/list_backups_usecase.dart';
import '../../features/backup/domain/usecases/delete_backup_usecase.dart';
import '../../features/backup/bloc/backup_bloc.dart';

import '../../features/sync/data/datasources/sync_remote_datasource.dart';
import '../../features/sync/data/datasources/sync_local_datasource.dart';
import '../../features/sync/data/repositories/sync_repository_impl.dart';
import '../../features/sync/domain/repositories/sync_repository.dart';
import '../../features/sync/domain/usecases/start_sync_usecase.dart';
import '../../features/sync/domain/usecases/stop_sync_usecase.dart';
import '../../features/sync/domain/usecases/resolve_conflict_usecase.dart';
import '../../features/sync/domain/usecases/get_devices_usecase.dart';
import '../../features/sync/bloc/sync_bloc.dart';

import '../../features/settings/bloc/settings_bloc.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await _registerCoreServices();
  await _registerDataSources();
  await _registerRepositories();
  await _registerUseCases();
  await _registerBlocs();
}

Future<void> _registerCoreServices() async {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());
  getIt.registerLazySingleton<AppPreferences>(() => AppPreferences());
  
  final database = await AppDatabase.create();
  getIt.registerLazySingleton<AppDatabase>(() => database);
  
  getIt.registerLazySingleton<PQCCrypto>(() => PQCCrypto());
  getIt.registerLazySingleton<BiometricService>(() => BiometricService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<BackgroundOTPService>(() => BackgroundOTPService());
  getIt.registerLazySingleton<DeviceInfoService>(() => DeviceInfoService());
}

Future<void> _registerDataSources() async {
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt<SecureStorage>()),
  );
  
  getIt.registerLazySingleton<AccountsRemoteDataSource>(
    () => AccountsRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<AccountsLocalDataSource>(
    () => AccountsLocalDataSourceImpl(getIt<AppDatabase>()),
  );
  
  getIt.registerLazySingleton<BackupRemoteDataSource>(
    () => BackupRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<BackupLocalDataSource>(
    () => BackupLocalDataSourceImpl(getIt<AppDatabase>()),
  );
  
  getIt.registerLazySingleton<SyncRemoteDataSource>(
    () => SyncRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<SyncLocalDataSource>(
    () => SyncLocalDataSourceImpl(getIt<AppDatabase>()),
  );
}

Future<void> _registerRepositories() async {
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
    ),
  );
  
  getIt.registerLazySingleton<AccountsRepository>(
    () => AccountsRepositoryImpl(
      getIt<AccountsRemoteDataSource>(),
      getIt<AccountsLocalDataSource>(),
    ),
  );
  
  getIt.registerLazySingleton<BackupRepository>(
    () => BackupRepositoryImpl(
      getIt<BackupRemoteDataSource>(),
      getIt<BackupLocalDataSource>(),
    ),
  );
  
  getIt.registerLazySingleton<SyncRepository>(
    () => SyncRepositoryImpl(
      getIt<SyncRemoteDataSource>(),
      getIt<SyncLocalDataSource>(),
    ),
  );
}

Future<void> _registerUseCases() async {
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => BiometricAuthUseCase(
    getIt<AuthRepository>(),
    getIt<BiometricService>(),
  ));
  
  getIt.registerLazySingleton(() => AddAccountUseCase(getIt<AccountsRepository>()));
  getIt.registerLazySingleton(() => GetAccountsUseCase(getIt<AccountsRepository>()));
  getIt.registerLazySingleton(() => DeleteAccountUseCase(getIt<AccountsRepository>()));
  getIt.registerLazySingleton(() => GenerateOTPUseCase(getIt<AccountsRepository>()));
  getIt.registerLazySingleton(() => ScanQRUseCase(getIt<AccountsRepository>()));
  
  getIt.registerLazySingleton(() => CreateBackupUseCase(getIt<BackupRepository>()));
  getIt.registerLazySingleton(() => RestoreBackupUseCase(getIt<BackupRepository>()));
  getIt.registerLazySingleton(() => ListBackupsUseCase(getIt<BackupRepository>()));
  getIt.registerLazySingleton(() => DeleteBackupUseCase(getIt<BackupRepository>()));
  
  getIt.registerLazySingleton(() => StartSyncUseCase(getIt<SyncRepository>()));
  getIt.registerLazySingleton(() => StopSyncUseCase(getIt<SyncRepository>()));
  getIt.registerLazySingleton(() => ResolveConflictUseCase(getIt<SyncRepository>()));
  getIt.registerLazySingleton(() => GetDevicesUseCase(getIt<SyncRepository>()));
}

Future<void> _registerBlocs() async {
  getIt.registerFactory(() => AuthBloc(
    getIt<LoginUseCase>(),
    getIt<RegisterUseCase>(),
    getIt<LogoutUseCase>(),
    getIt<BiometricAuthUseCase>(),
  ));
  
  getIt.registerFactory(() => AccountsBloc(
    getIt<GetAccountsUseCase>(),
    getIt<AddAccountUseCase>(),
    getIt<DeleteAccountUseCase>(),
    getIt<GenerateOTPUseCase>(),
    getIt<ScanQRUseCase>(),
  ));
  
  getIt.registerFactory(() => BackupBloc(
    getIt<CreateBackupUseCase>(),
    getIt<RestoreBackupUseCase>(),
    getIt<ListBackupsUseCase>(),
    getIt<DeleteBackupUseCase>(),
  ));
  
  getIt.registerFactory(() => SyncBloc(
    getIt<StartSyncUseCase>(),
    getIt<StopSyncUseCase>(),
    getIt<ResolveConflictUseCase>(),
    getIt<GetDevicesUseCase>(),
  ));
  
  getIt.registerFactory(() => SettingsBloc());
}