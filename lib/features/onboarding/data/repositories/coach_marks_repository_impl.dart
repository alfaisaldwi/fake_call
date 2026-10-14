import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/coach_marks_repository.dart';
import '../datasources/coach_marks_local_data_source.dart';

class CoachMarksRepositoryImpl implements CoachMarksRepository {
  final CoachMarksLocalDataSource dataSource;

  CoachMarksRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, bool>> isSeen() async {
    try {
      return Right(await dataSource.isSeen());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }

  @override
  Future<Either<Failure, Unit>> setSeen(bool seen) async {
    try {
      await dataSource.setSeen(seen);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }
}
