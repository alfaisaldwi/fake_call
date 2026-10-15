import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/call_preferences.dart';
import '../repositories/call_preferences_repository.dart';

class SaveCallPreferences implements UseCase<Unit, CallPreferences> {
  final CallPreferencesRepository repository;

  SaveCallPreferences(this.repository);

  @override
  Future<Either<Failure, Unit>> call(CallPreferences preferences) {
    return repository.savePreferences(preferences);
  }
}
