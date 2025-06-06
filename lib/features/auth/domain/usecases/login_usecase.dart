import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, LoginResult>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
      deviceId: params.deviceId,
      deviceName: params.deviceName,
    );
  }
}

class LoginParams {
  final String email;
  final String password;
  final String deviceId;
  final String deviceName;

  const LoginParams({
    required this.email,
    required this.password,
    required this.deviceId,
    required this.deviceName,
  });
}

class LoginResult {
  final User user;
  final AuthToken token;
  final bool requiresTwoFactor;
  final String? twoFactorToken;

  const LoginResult({
    required this.user,
    required this.token,
    required this.requiresTwoFactor,
    this.twoFactorToken,
  });
}