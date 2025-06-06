import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/account.dart';
import '../repositories/accounts_repository.dart';

class GetAccountsUseCase {
  final AccountsRepository repository;

  GetAccountsUseCase(this.repository);

  Future<Either<Failure, List<Account>>> call() async {
    return await repository.getAccounts();
  }
}