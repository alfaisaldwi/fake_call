import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/coach_marks_repository.dart';

class SetCoachMarksSeen implements UseCase<Unit, bool> {
  final CoachMarksRepository repository;

  SetCoachMarksSeen(this.repository);

  @override
  Future<Either<Failure, Unit>> call(bool seen) => repository.setSeen(seen);
}
