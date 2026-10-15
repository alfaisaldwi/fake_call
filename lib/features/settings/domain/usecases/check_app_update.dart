import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_update.dart';
import '../repositories/app_update_repository.dart';

class CheckAppUpdate implements UseCase<AppUpdateAvailability, NoParams> {
  final AppUpdateRepository repository;

  CheckAppUpdate(this.repository);

  @override
  Future<Either<Failure, AppUpdateAvailability>> call(NoParams params) {
    return repository.checkForUpdate();
  }
}
