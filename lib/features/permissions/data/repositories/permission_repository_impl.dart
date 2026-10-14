import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_permission.dart';
import '../../domain/repositories/permission_repository.dart';
import '../datasources/permission_data_source.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  final PermissionDataSource dataSource;

  PermissionRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, PermissionSnapshot>> check() async {
    try {
      return Right(await _snapshot());
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.reason, detail: e.detail));
    }
  }

  @override
  Future<Either<Failure, PermissionSnapshot>> request(
    AppPermission permission,
  ) async {
    try {
      await dataSource.request(permission);
      return Right(await _snapshot());
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.reason, detail: e.detail));
    }
  }

  Future<PermissionSnapshot> _snapshot() async {
    return PermissionSnapshot({
      for (final permission in AppPermission.values)
        permission: await dataSource.isGranted(permission),
    });
  }
}
