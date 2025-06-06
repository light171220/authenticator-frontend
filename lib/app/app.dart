import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../core/di/injection.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/accounts/bloc/accounts_bloc.dart';
import '../features/backup/bloc/backup_bloc.dart';
import '../features/sync/bloc/sync_bloc.dart';
import '../features/settings/bloc/settings_bloc.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class PQCAuthenticatorApp extends StatelessWidget {
  const PQCAuthenticatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
        ),
        BlocProvider<AccountsBloc>(
          create: (context) => getIt<AccountsBloc>(),
        ),
        BlocProvider<BackupBloc>(
          create: (context) => getIt<BackupBloc>(),
        ),
        BlocProvider<SyncBloc>(
          create: (context) => getIt<SyncBloc>(),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => getIt<SettingsBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'PQC Authenticator',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}