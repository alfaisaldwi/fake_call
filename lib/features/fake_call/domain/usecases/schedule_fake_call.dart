import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/call_config.dart';
import '../entities/call_config_issue.dart';
import '../repositories/fake_call_repository.dart';

class ScheduleFakeCall implements UseCase<Unit, CallConfig> {
  final FakeCallRepository repository;

  ScheduleFakeCall(this.repository);

  @override
  Future<Either<Failure, Unit>> call(CallConfig config) async {
    final issue = config.validationIssue;
    if (issue != null) return Left(InvalidCallConfigFailure(issue));
    return repository.scheduleCall(config);
  }
}
