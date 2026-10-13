import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/call_media_repository.dart';

class SetPlaybackPaused implements UseCase<Unit, bool> {
  final CallMediaRepository repository;

  SetPlaybackPaused(this.repository);

  @override
  Future<Either<Failure, Unit>> call(bool paused) {
    return repository.setPlaybackPaused(paused);
  }
}
