import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/theme_mode_repository.dart';
import '../datasources/theme_mode_local_data_source.dart';

class ThemeModeRepositoryImpl implements ThemeModeRepository {
  final ThemeModeLocalDataSource dataSource;

  ThemeModeRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, AppThemeMode>> getThemeMode() async {
    try {
      return Right(await dataSource.getThemeMode());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveThemeMode(AppThemeMode mode) async {
    try {
      await dataSource.saveThemeMode(mode);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }
}
