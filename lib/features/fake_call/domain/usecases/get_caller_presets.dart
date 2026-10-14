import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/caller_preset.dart';
import '../repositories/caller_preset_repository.dart';

class GetCallerPresets implements UseCase<List<CallerPreset>, NoParams> {
  final CallerPresetRepository repository;

  GetCallerPresets(this.repository);

  @override
  Future<Either<Failure, List<CallerPreset>>> call(NoParams params) {
    return repository.getPresets();
  }
}
