import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/call_media.dart';

abstract class CallMediaRepository {
  Future<Either<Failure, CallMedia>> startMedia({String? videoPath});

  Future<Either<Failure, CallMedia>> switchCamera();

  Future<Either<Failure, Unit>> setCameraEnabled(bool enabled);

  Future<Either<Failure, Unit>> setPlaybackPaused(bool paused);

  Future<Either<Failure, Unit>> stopMedia();

  Future<Either<Failure, Unit>> setProximityLock(bool enabled);
}
