import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

class CheckOnboardingCompleted implements UseCase<bool, NoParams> {
  final OnboardingRepository repository;

  CheckOnboardingCompleted(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.isCompleted();
  }
}
