import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/call_media.dart';
import '../repositories/call_media_repository.dart';

class StartCallMedia implements UseCase<CallMedia, String?> {
  final CallMediaRepository repository;

  StartCallMedia(this.repository);

  @override
  Future<Either<Failure, CallMedia>> call(String? videoPath) {
    return repository.startMedia(videoPath: videoPath);
  }
}
