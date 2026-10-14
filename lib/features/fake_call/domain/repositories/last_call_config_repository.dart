import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/call_config.dart';

abstract class LastCallConfigRepository {
  Future<Either<Failure, CallConfig?>> load();

  Future<Either<Failure, Unit>> save(CallConfig config);
}
