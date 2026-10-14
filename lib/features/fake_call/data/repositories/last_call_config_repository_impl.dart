import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/call_config.dart';
import '../../domain/repositories/last_call_config_repository.dart';
import '../datasources/last_call_config_local_data_source.dart';
import '../models/call_config_model.dart';

class LastCallConfigRepositoryImpl implements LastCallConfigRepository {
  final LastCallConfigLocalDataSource dataSource;

  LastCallConfigRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, CallConfig?>> load() async {
    try {
      return Right(await dataSource.load());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }

  @override
  Future<Either<Failure, Unit>> save(CallConfig config) async {
    try {
      await dataSource.save(CallConfigModel.fromEntity(config));
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }
}
