import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_info.dart';

abstract class AppInfoRepository {
  Future<Either<Failure, AppInfo>> getAppInfo();
}
