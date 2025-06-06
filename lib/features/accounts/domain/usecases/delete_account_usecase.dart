import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/accounts_repository.dart';

class DeleteAccountUseCase {
  final AccountsRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<Either<Failure, void>> call(DeleteAccountParams params) async {
    return await repository.deleteAccount(params.accountId);
  }
}

class DeleteAccountParams {
  final String accountId;

  const DeleteAccountParams({
    required this.accountId,
  });
}