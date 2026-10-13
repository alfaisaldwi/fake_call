import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_language.dart';
import '../repositories/language_repository.dart';

class SaveAppLanguage implements UseCase<Unit, AppLanguage> {
  final LanguageRepository repository;

  SaveAppLanguage(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AppLanguage language) {
    return repository.saveLanguage(language);
  }
}
