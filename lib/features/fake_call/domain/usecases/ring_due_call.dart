import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/fake_call_repository.dart';

class RingDueCall implements UseCase<bool, NoParams> {
  final FakeCallRepository repository;

  RingDueCall(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.ringDueCall();
  }
}
