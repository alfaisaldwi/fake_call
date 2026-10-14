import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_theme_mode.dart';
import '../repositories/theme_mode_repository.dart';

class SaveThemeMode implements UseCase<Unit, AppThemeMode> {
  final ThemeModeRepository repository;

  SaveThemeMode(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AppThemeMode mode) {
    return repository.saveThemeMode(mode);
  }
}
