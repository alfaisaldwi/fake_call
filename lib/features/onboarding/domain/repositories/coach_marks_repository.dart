import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class CoachMarksRepository {
  Future<Either<Failure, bool>> isSeen();

  Future<Either<Failure, Unit>> setSeen(bool seen);
}
