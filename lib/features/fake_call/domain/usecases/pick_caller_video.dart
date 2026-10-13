import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/caller_video_repository.dart';

class PickCallerVideo implements UseCase<String?, NoParams> {
  final CallerVideoRepository repository;

  PickCallerVideo(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) {
    return repository.pickFromGallery();
  }
}
