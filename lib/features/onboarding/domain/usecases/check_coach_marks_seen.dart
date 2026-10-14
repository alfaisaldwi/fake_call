import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/coach_marks_repository.dart';

class CheckCoachMarksSeen implements UseCase<bool, NoParams> {
  final CoachMarksRepository repository;

  CheckCoachMarksSeen(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) => repository.isSeen();
}
