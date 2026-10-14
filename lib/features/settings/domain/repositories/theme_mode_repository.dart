import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_theme_mode.dart';

abstract class ThemeModeRepository {
  Future<Either<Failure, AppThemeMode>> getThemeMode();

  Future<Either<Failure, Unit>> saveThemeMode(AppThemeMode mode);
}
