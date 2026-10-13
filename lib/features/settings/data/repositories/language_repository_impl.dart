import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/repositories/language_repository.dart';
import '../datasources/language_local_data_source.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  final LanguageLocalDataSource dataSource;

  LanguageRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, AppLanguage>> getLanguage() async {
    try {
      return Right(await dataSource.getLanguage());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLanguage(AppLanguage language) async {
    try {
      await dataSource.saveLanguage(language);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }
}
