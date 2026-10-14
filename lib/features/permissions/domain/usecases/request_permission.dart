import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_permission.dart';
import '../repositories/permission_repository.dart';

class RequestPermission implements UseCase<PermissionSnapshot, AppPermission> {
  final PermissionRepository repository;

  RequestPermission(this.repository);

  @override
  Future<Either<Failure, PermissionSnapshot>> call(AppPermission permission) {
    return repository.request(permission);
  }
}
