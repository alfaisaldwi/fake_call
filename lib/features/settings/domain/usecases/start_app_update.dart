import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/app_update_repository.dart';

class StartAppUpdate implements UseCase<bool, NoParams> {
  final AppUpdateRepository repository;

  StartAppUpdate(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.startUpdate();
  }
}
