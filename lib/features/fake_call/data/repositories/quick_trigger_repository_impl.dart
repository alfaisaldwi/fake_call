import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/quick_trigger_repository.dart';
import '../datasources/quick_trigger_data_source.dart';

class QuickTriggerRepositoryImpl implements QuickTriggerRepository {
  final QuickTriggerDataSource dataSource;

  QuickTriggerRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Stream<int>>> listen() async {
    return Right(
      dataSource.triggers.handleError(
        (Object e) => throw const CallKitFailure(FailureReason.unknown),
      ),
    );
  }
}
