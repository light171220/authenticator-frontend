import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/account.dart';
import '../entities/otp_code.dart';
import '../repositories/accounts_repository.dart';

class ScanQRUseCase {
  final AccountsRepository repository;

  ScanQRUseCase(this.repository);

  Future<Either<Failure, QRScanResult>> call(ScanQRParams params) async {
    return await repository.parseQRCode(params.qrCode);
  }

  Future<Either<Failure, Account>> addAccountFromQR(QRScanResult qrResult) async {
    return await repository.addAccountFromQR(qrResult);
  }
}

class ScanQRParams {
  final String qrCode;

  const ScanQRParams({
    required this.qrCode,
  });
}