import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/call_event.dart';
import '../repositories/fake_call_repository.dart';

class ListenToCallEvents implements UseCase<Stream<CallEvent>, NoParams> {
  final FakeCallRepository repository;

  ListenToCallEvents(this.repository);

  @override
  Future<Either<Failure, Stream<CallEvent>>> call(NoParams params) {
    return repository.listenToCallEvents();
  }
}
