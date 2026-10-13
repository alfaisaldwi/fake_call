import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/call_media_repository.dart';

class StopCallMedia implements UseCase<Unit, NoParams> {
  final CallMediaRepository repository;

  StopCallMedia(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.stopMedia();
  }
}
