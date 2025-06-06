import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/biometric_service.dart';
import '../repositories/auth_repository.dart';
import '../usecases/login_usecase.dart';

class BiometricAuthUseCase {
  final AuthRepository authRepository;
  final BiometricService biometricService;

  BiometricAuthUseCase(
    this.authRepository,
    this.biometricService,
  );

  Future<Either<Failure, LoginResult>> call() async {
    final isAvailable = await isBiometricAvailable();
    if (!isAvailable) {
      return Left(BiometricFailure('Biometric authentication not available'));
    }

    final isAuthenticated = await biometricService.authenticate(
      localizedFallbackTitle: 'Use Password',
      reason: 'Authenticate to access your accounts',
    );

    if (!isAuthenticated) {
      return Left(BiometricFailure('Biometric authentication failed'));
    }

    return await authRepository.biometricLogin();
  }

  Future<bool> isBiometricAvailable() async {
    return await biometricService.isAvailable();
  }

  Future<Either<Failure, void>> enableBiometricAuth() async {
    final isAvailable = await isBiometricAvailable();
    if (!isAvailable) {
      return Left(BiometricFailure('Biometric authentication not available'));
    }

    final isAuthenticated = await biometricService.authenticate(
      localizedFallbackTitle: 'Use Password',
      reason: 'Authenticate to enable biometric login',
    );

    if (!isAuthenticated) {
      return Left(BiometricFailure('Biometric authentication failed'));
    }

    return await authRepository.enableBiometricAuth();
  }

  Future<Either<Failure, void>> disableBiometricAuth() async {
    return await authRepository.disableBiometricAuth();
  }
}