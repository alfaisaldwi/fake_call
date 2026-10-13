import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/caller_name_history.dart';
import '../repositories/caller_name_history_repository.dart';

class GetCallerNameHistory implements UseCase<CallerNameHistory, NoParams> {
  final CallerNameHistoryRepository repository;

  GetCallerNameHistory(this.repository);

  @override
  Future<Either<Failure, CallerNameHistory>> call(NoParams params) {
    return repository.load();
  }
}
