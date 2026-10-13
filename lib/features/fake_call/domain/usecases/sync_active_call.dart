import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/fake_call_repository.dart';

class SyncActiveCall implements UseCase<Unit, NoParams> {
  final FakeCallRepository repository;

  SyncActiveCall(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.syncActiveCall();
  }
}
