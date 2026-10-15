import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/call_preferences.dart';

abstract class CallPreferencesRepository {
  Future<Either<Failure, CallPreferences>> getPreferences();

  Future<Either<Failure, Unit>> savePreferences(CallPreferences preferences);
}
