import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/call_config.dart';
import '../entities/call_event.dart';

abstract class FakeCallRepository {
  Future<Either<Failure, Unit>> scheduleCall(CallConfig config);

  Future<Either<Failure, Stream<CallEvent>>> listenToCallEvents();

  Future<Either<Failure, Unit>> endCall();

  Future<Either<Failure, Unit>> syncActiveCall();
}
