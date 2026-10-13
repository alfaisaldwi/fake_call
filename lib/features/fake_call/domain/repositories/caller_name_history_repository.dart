import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/caller_name_history.dart';

abstract class CallerNameHistoryRepository {
  Future<Either<Failure, CallerNameHistory>> load();

  Future<Either<Failure, Unit>> save(CallerNameHistory history);
}
