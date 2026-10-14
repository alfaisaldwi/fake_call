import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/call_config.dart';
import '../repositories/last_call_config_repository.dart';

class SaveLastCallConfig implements UseCase<Unit, CallConfig> {
  final LastCallConfigRepository repository;

  SaveLastCallConfig(this.repository);

  @override
  Future<Either<Failure, Unit>> call(CallConfig config) {
    return repository.save(config);
  }
}
