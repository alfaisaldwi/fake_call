import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/caller_video_repository.dart';
import '../datasources/caller_video_local_data_source.dart';

class CallerVideoRepositoryImpl implements CallerVideoRepository {
  final CallerVideoLocalDataSource dataSource;

  CallerVideoRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, String?>> pickFromGallery() async {
    try {
      return Right(await dataSource.pickFromGallery());
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.reason, detail: e.detail));
    } on MediaException catch (e) {
      return Left(MediaFailure(e.reason, detail: e.detail));
    }
  }
}
