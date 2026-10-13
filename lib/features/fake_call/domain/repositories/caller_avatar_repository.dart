import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class CallerAvatarRepository {
  Future<Either<Failure, String?>> pickFromGallery();
}
