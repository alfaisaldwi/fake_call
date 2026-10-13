import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/caller_name_history.dart';
import '../../domain/repositories/caller_name_history_repository.dart';
import '../datasources/caller_name_history_local_data_source.dart';
import '../models/caller_name_history_model.dart';

class CallerNameHistoryRepositoryImpl implements CallerNameHistoryRepository {
  final CallerNameHistoryLocalDataSource dataSource;

  CallerNameHistoryRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, CallerNameHistory>> load() async {
    try {
      return Right(await dataSource.load());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }

  @override
  Future<Either<Failure, Unit>> save(CallerNameHistory history) async {
    try {
      await dataSource.save(CallerNameHistoryModel.fromEntity(history));
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }
}
