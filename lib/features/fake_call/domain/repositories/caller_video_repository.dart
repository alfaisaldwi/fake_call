import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class CallerVideoRepository {
  Future<Either<Failure, String?>> pickFromGallery();
}
