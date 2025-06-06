import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/otp_code.dart';
import '../repositories/accounts_repository.dart';

class GenerateOTPUseCase {
  final AccountsRepository repository;

  GenerateOTPUseCase(this.repository);

  Future<Either<Failure, OTPCode>> call(GenerateOTPParams params) async {
    return await repository.generateOTP(params.accountId);
  }
}

class GenerateOTPParams {
  final String accountId;

  const GenerateOTPParams({
    required this.accountId,
  });
}