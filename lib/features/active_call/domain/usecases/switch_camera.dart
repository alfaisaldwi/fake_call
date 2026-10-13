import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/call_media.dart';
import '../repositories/call_media_repository.dart';

class SwitchCamera implements UseCase<CallMedia, NoParams> {
  final CallMediaRepository repository;

  SwitchCamera(this.repository);

  @override
  Future<Either<Failure, CallMedia>> call(NoParams params) {
    return repository.switchCamera();
  }
}
