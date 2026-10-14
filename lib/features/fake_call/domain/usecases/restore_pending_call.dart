import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pending_call.dart';
import '../repositories/fake_call_repository.dart';

class RestorePendingCall implements UseCase<PendingCall?, NoParams> {
  final FakeCallRepository repository;

  RestorePendingCall(this.repository);

  @override
  Future<Either<Failure, PendingCall?>> call(NoParams params) {
    return repository.restorePendingCall();
  }
}
