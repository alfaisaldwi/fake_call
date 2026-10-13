import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_language.dart';
import '../repositories/language_repository.dart';

class GetAppLanguage implements UseCase<AppLanguage, NoParams> {
  final LanguageRepository repository;

  GetAppLanguage(this.repository);

  @override
  Future<Either<Failure, AppLanguage>> call(NoParams params) {
    return repository.getLanguage();
  }
}
