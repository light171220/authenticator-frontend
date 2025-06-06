import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, RegisterResult>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
      deviceId: params.deviceId,
      deviceName: params.deviceName,
    );
  }
}

class RegisterParams {
  final String email;
  final String password;
  final String? name;
  final String deviceId;
  final String deviceName;

  const RegisterParams({
    required this.email,
    required this.password,
    this.name,
    required this.deviceId,
    required this.deviceName,
  });
}

class RegisterResult {
  final User user;
  final AuthToken token;
  final bool requiresEmailVerification;

  const RegisterResult({
    required this.user,
    required this.token,
    required this.requiresEmailVerification,
  });
}