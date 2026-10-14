import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource dataSource;

  OnboardingRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, bool>> isCompleted() async {
    try {
      return Right(await dataSource.isCompleted());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }

  @override
  Future<Either<Failure, Unit>> markCompleted() async {
    try {
      await dataSource.markCompleted();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }
}
