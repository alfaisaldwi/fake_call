import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/call_preferences.dart';
import '../../domain/repositories/call_preferences_repository.dart';
import '../datasources/call_preferences_local_data_source.dart';

class CallPreferencesRepositoryImpl implements CallPreferencesRepository {
  final CallPreferencesLocalDataSource dataSource;

  CallPreferencesRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, CallPreferences>> getPreferences() async {
    try {
      return Right(await dataSource.getPreferences());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }

  @override
  Future<Either<Failure, Unit>> savePreferences(
    CallPreferences preferences,
  ) async {
    try {
      await dataSource.savePreferences(preferences);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }
}
