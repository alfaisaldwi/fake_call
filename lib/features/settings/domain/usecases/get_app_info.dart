import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_info.dart';
import '../repositories/app_info_repository.dart';

class GetAppInfo implements UseCase<AppInfo, NoParams> {
  final AppInfoRepository repository;

  GetAppInfo(this.repository);

  @override
  Future<Either<Failure, AppInfo>> call(NoParams params) {
    return repository.getAppInfo();
  }
}
