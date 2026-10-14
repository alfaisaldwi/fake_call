import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_info.dart';
import '../../domain/repositories/app_info_repository.dart';
import '../datasources/app_info_data_source.dart';

class AppInfoRepositoryImpl implements AppInfoRepository {
  final AppInfoDataSource dataSource;

  AppInfoRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, AppInfo>> getAppInfo() async {
    try {
      return Right(await dataSource.getAppInfo());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }
}
