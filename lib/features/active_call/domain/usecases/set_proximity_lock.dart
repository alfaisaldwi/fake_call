import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/call_media_repository.dart';

class SetProximityLock implements UseCase<Unit, bool> {
  final CallMediaRepository repository;

  SetProximityLock(this.repository);

  @override
  Future<Either<Failure, Unit>> call(bool enabled) {
    return repository.setProximityLock(enabled);
  }
}
