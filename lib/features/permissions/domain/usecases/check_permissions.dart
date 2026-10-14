import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_permission.dart';
import '../repositories/permission_repository.dart';

class CheckPermissions implements UseCase<PermissionSnapshot, NoParams> {
  final PermissionRepository repository;

  CheckPermissions(this.repository);

  @override
  Future<Either<Failure, PermissionSnapshot>> call(NoParams params) {
    return repository.check();
  }
}
