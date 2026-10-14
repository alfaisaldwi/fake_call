import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/call_config.dart';
import '../entities/call_event.dart';
import '../entities/pending_call.dart';

abstract class FakeCallRepository {
  Future<Either<Failure, PendingCall>> scheduleCall(CallConfig config);

  Future<Either<Failure, PendingCall?>> restorePendingCall();

  Future<Either<Failure, bool>> ringDueCall();

  Future<Either<Failure, Unit>> finishDueCall();

  Future<Either<Failure, Stream<CallEvent>>> listenToCallEvents();

  Future<Either<Failure, Unit>> endCall();

  Future<Either<Failure, Unit>> syncActiveCall();
}
