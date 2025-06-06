import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/biometric_setup_page.dart';
import '../../features/accounts/presentation/pages/accounts_page.dart';
import '../../features/accounts/presentation/pages/add_account_page.dart';
import '../../features/accounts/presentation/pages/qr_scanner_page.dart';
import '../../features/accounts/presentation/pages/account_details_page.dart';
import '../../features/backup/presentation/pages/backup_page.dart';
import '../../features/backup/presentation/pages/restore_page.dart';
import '../../features/sync/presentation/pages/sync_page.dart';
import '../../features/sync/presentation/pages/devices_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/security_page.dart';
import '../../features/settings/presentation/pages/appearance_page.dart';
import 'guards/auth_guard.dart';
import 'routes.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: Routes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: Routes.biometricSetup,
        name: 'biometric_setup',
        builder: (context, state) => const BiometricSetupPage(),
      ),
      GoRoute(
        path: Routes.accounts,
        name: 'accounts',
        builder: (context, state) => const AccountsPage(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'add_account',
            builder: (context, state) => const AddAccountPage(),
          ),
          GoRoute(
            path: 'scan',
            name: 'qr_scanner',
            builder: (context, state) => const QRScannerPage(),
          ),
          GoRoute(
            path: 'details/:id',
            name: 'account_details',
            builder: (context, state) {
              final accountId = state.pathParameters['id']!;
              return AccountDetailsPage(accountId: accountId);
            },
          ),
        ],
      ),
      GoRoute(
        path: Routes.backup,
        name: 'backup',
        builder: (context, state) => const BackupPage(),
        routes: [
          GoRoute(
            path: 'restore',
            name: 'restore',
            builder: (context, state) => const RestorePage(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.sync,
        name: 'sync',
        builder: (context, state) => const SyncPage(),
        routes: [
          GoRoute(
            path: 'devices',
            name: 'devices',
            builder: (context, state) => const DevicesPage(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            path: 'security',
            name: 'security',
            builder: (context, state) => const SecurityPage(),
          ),
          GoRoute(
            path: 'appearance',
            name: 'appearance',
            builder: (context, state) => const AppearancePage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) => AuthGuard.redirect(context, state),
  );
}