import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/biometric_auth_usecase.dart';
import '../domain/entities/user.dart';
import '../domain/entities/auth_token.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final BiometricAuthUseCase biometricAuthUseCase;

  AuthBloc(
    this.loginUseCase,
    this.registerUseCase,
    this.logoutUseCase,
    this.biometricAuthUseCase,
  ) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<BiometricLoginRequested>(_onBiometricLoginRequested);
    on<TokenRefreshRequested>(_onTokenRefreshRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<UpdateSecuritySettings>(_onUpdateSecuritySettings);
    on<EnableBiometricAuth>(_onEnableBiometricAuth);
    on<DisableBiometricAuth>(_onDisableBiometricAuth);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginUseCase(LoginParams(
      email: event.email,
      password: event.password,
      deviceId: event.deviceId,
      deviceName: event.deviceName,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (loginResult) {
        if (loginResult.requiresTwoFactor) {
          emit(TwoFactorRequired(
            user: loginResult.user,
            twoFactorToken: loginResult.twoFactorToken!,
          ));
        } else {
          emit(Authenticated(
            user: loginResult.user,
            token: loginResult.token,
          ));
        }
      },
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await registerUseCase(RegisterParams(
      email: event.email,
      password: event.password,
      name: event.name,
      deviceId: event.deviceId,
      deviceName: event.deviceName,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (registerResult) {
        if (registerResult.requiresEmailVerification) {
          emit(EmailVerificationRequired(
            user: registerResult.user,
          ));
        } else {
          emit(Authenticated(
            user: registerResult.user,
            token: registerResult.token,
          ));
        }
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  Future<void> _onBiometricLoginRequested(
    BiometricLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await biometricAuthUseCase();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authResult) => emit(Authenticated(
        user: authResult.user,
        token: authResult.token,
      )),
    );
  }

  Future<void> _onTokenRefreshRequested(
    TokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! Authenticated) return;

    final currentState = state as Authenticated;
    
    final result = await loginUseCase.repository.refreshToken(
      currentState.token.refreshToken,
    );

    result.fold(
      (failure) => emit(const Unauthenticated()),
      (newToken) => emit(currentState.copyWith(token: newToken)),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginUseCase.repository.getCurrentUser();

    result.fold(
      (failure) => emit(const Unauthenticated()),
      (userWithToken) => emit(Authenticated(
        user: userWithToken.user,
        token: userWithToken.token,
      )),
    );
  }

  Future<void> _onUpdateSecuritySettings(
    UpdateSecuritySettings event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! Authenticated) return;

    final currentState = state as Authenticated;
    
    final result = await loginUseCase.repository.updateSecuritySettings(
      event.settings,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (updatedUser) => emit(currentState.copyWith(user: updatedUser)),
    );
  }

  Future<void> _onEnableBiometricAuth(
    EnableBiometricAuth event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! Authenticated) return;

    final currentState = state as Authenticated;
    
    final isAvailable = await biometricAuthUseCase.isBiometricAvailable();
    
    if (!isAvailable) {
      emit(const BiometricUnavailable());
      return;
    }

    final result = await biometricAuthUseCase.enableBiometricAuth();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {
        final updatedUser = currentState.user.copyWith(
          isBiometricEnabled: true,
        );
        emit(currentState.copyWith(user: updatedUser));
        emit(const BiometricEnabled());
      },
    );
  }

  Future<void> _onDisableBiometricAuth(
    DisableBiometricAuth event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! Authenticated) return;

    final currentState = state as Authenticated;
    
    final result = await biometricAuthUseCase.disableBiometricAuth();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {
        final updatedUser = currentState.user.copyWith(
          isBiometricEnabled: false,
        );
        emit(currentState.copyWith(user: updatedUser));
        emit(const BiometricDisabled());
      },
    );
  }
}