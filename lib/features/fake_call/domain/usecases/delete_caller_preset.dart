import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/caller_preset.dart';
import '../repositories/caller_preset_repository.dart';

class DeleteCallerPreset implements UseCase<List<CallerPreset>, String> {
  final CallerPresetRepository repository;

  DeleteCallerPreset(this.repository);

  @override
  Future<Either<Failure, List<CallerPreset>>> call(String id) {
    return repository.deletePreset(id);
  }
}
