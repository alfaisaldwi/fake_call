import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/caller_avatar_repository.dart';

class PickCallerAvatar implements UseCase<String?, NoParams> {
  final CallerAvatarRepository repository;

  PickCallerAvatar(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) {
    return repository.pickFromGallery();
  }
}
