import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_permission.dart';

abstract class PermissionRepository {
  Future<Either<Failure, PermissionSnapshot>> check();

  Future<Either<Failure, PermissionSnapshot>> request(AppPermission permission);
}
