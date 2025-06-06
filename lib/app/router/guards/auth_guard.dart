import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../../../core/storage/preferences.dart';
import '../../../core/storage/secure_storage.dart';
import '../routes.dart';

class AuthGuard {
  static final _preferences = GetIt.instance<AppPreferences>();
  static final _secureStorage = GetIt.instance<SecureStorage>();

  static String? redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    
    final isOnboarded = _preferences.getBool('is_onboarded') ?? false;
    final hasAuthToken = _secureStorage.hasAuthToken();
    
    final isPublicRoute = _publicRoutes.contains(location);
    final isProtectedRoute = _protectedRoutes.any((route) => location.startsWith(route));
    
    if (!isOnboarded && location != Routes.onboarding) {
      return Routes.onboarding;
    }
    
    if (isOnboarded && location == Routes.splash) {
      if (hasAuthToken) {
        return Routes.accounts;
      } else {
        return Routes.login;
      }
    }
    
    if (!hasAuthToken && isProtectedRoute) {
      return Routes.login;
    }
    
    if (hasAuthToken && isPublicRoute && location != Routes.splash) {
      return Routes.accounts;
    }
    
    return null;
  }

  static final List<String> _publicRoutes = [
    Routes.splash,
    Routes.onboarding,
    Routes.login,
    Routes.register,
  ];

  static final List<String> _protectedRoutes = [
    Routes.accounts,
    Routes.backup,
    Routes.sync,
    Routes.settings,
    Routes.biometricSetup,
  ];
}