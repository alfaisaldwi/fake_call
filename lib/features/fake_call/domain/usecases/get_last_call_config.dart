import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/call_config.dart';
import '../repositories/last_call_config_repository.dart';

class GetLastCallConfig implements UseCase<CallConfig?, NoParams> {
  final LastCallConfigRepository repository;

  GetLastCallConfig(this.repository);

  @override
  Future<Either<Failure, CallConfig?>> call(NoParams params) {
    return repository.load();
  }
}
