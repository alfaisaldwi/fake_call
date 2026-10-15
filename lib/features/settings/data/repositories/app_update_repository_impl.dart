import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_update.dart';
import '../../domain/repositories/app_update_repository.dart';
import '../datasources/app_update_data_source.dart';

class AppUpdateRepositoryImpl implements AppUpdateRepository {
  final AppUpdateDataSource dataSource;

  AppUpdateRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, AppUpdateAvailability>> checkForUpdate() async {
    try {
      return Right(await dataSource.checkForUpdate());
    } on UpdateException catch (e) {
      return Left(UpdateFailure(e.reason, detail: e.detail));
    }
  }

  @override
  Future<Either<Failure, bool>> startUpdate() async {
    try {
      return Right(await dataSource.startUpdate());
    } on UpdateException catch (e) {
      return Left(UpdateFailure(e.reason, detail: e.detail));
    }
  }
}
