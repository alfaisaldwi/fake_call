import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_theme_mode.dart';
import '../repositories/theme_mode_repository.dart';

class GetThemeMode implements UseCase<AppThemeMode, NoParams> {
  final ThemeModeRepository repository;

  GetThemeMode(this.repository);

  @override
  Future<Either<Failure, AppThemeMode>> call(NoParams params) {
    return repository.getThemeMode();
  }
}
