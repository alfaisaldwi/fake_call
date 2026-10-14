import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/quick_trigger_repository.dart';

class ListenToQuickTriggers implements UseCase<Stream<int>, NoParams> {
  final QuickTriggerRepository repository;

  ListenToQuickTriggers(this.repository);

  @override
  Future<Either<Failure, Stream<int>>> call(NoParams params) {
    return repository.listen();
  }
}
