import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_update.dart';

abstract class AppUpdateRepository {
  Future<Either<Failure, AppUpdateAvailability>> checkForUpdate();

  Future<Either<Failure, bool>> startUpdate();
}
