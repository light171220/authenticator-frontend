import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/account.dart';
import '../repositories/accounts_repository.dart';

class AddAccountUseCase {
  final AccountsRepository repository;

  AddAccountUseCase(this.repository);

  Future<Either<Failure, Account>> call(AddAccountParams params) async {
    return await repository.addAccount(params.account);
  }
}

class AddAccountParams {
  final Account account;

  const AddAccountParams({
    required this.account,
  });
}