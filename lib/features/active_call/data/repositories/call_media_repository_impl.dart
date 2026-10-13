import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/call_media.dart';
import '../../domain/repositories/call_media_repository.dart';
import '../datasources/call_media_local_data_source.dart';

class CallMediaRepositoryImpl implements CallMediaRepository {
  final CallMediaLocalDataSource dataSource;

  CallMediaRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, CallMedia>> startMedia({String? videoPath}) {
    return _guard(() => dataSource.startMedia(videoPath: videoPath));
  }

  @override
  Future<Either<Failure, CallMedia>> switchCamera() {
    return _guard(dataSource.switchCamera);
  }

  @override
  Future<Either<Failure, Unit>> setPlaybackPaused(bool paused) {
    return _guard(() async {
      await dataSource.setPlaybackPaused(paused);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> stopMedia() {
    return _guard(() async {
      await dataSource.stopMedia();
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> setCameraEnabled(bool enabled) {
    return _guard(() async {
      await dataSource.setCameraEnabled(enabled);
      return unit;
    });
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.reason, detail: e.detail));
    } on MediaException catch (e) {
      return Left(MediaFailure(e.reason, detail: e.detail));
    }
  }
}
