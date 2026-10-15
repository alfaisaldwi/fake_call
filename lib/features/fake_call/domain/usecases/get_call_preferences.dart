import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/call_preferences.dart';
import '../repositories/call_preferences_repository.dart';

class GetCallPreferences implements UseCase<CallPreferences, NoParams> {
  final CallPreferencesRepository repository;

  GetCallPreferences(this.repository);

  @override
  Future<Either<Failure, CallPreferences>> call(NoParams params) {
    return repository.getPreferences();
  }
}
