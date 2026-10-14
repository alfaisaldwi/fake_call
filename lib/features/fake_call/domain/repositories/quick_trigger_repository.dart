import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class QuickTriggerRepository {
  Future<Either<Failure, Stream<int>>> listen();
}
