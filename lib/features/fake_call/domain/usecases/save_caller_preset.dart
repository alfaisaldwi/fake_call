import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/call_config.dart';
import '../entities/call_config_issue.dart';
import '../entities/caller_preset.dart';
import '../repositories/caller_preset_repository.dart';

class SaveCallerPreset implements UseCase<List<CallerPreset>, CallConfig> {
  final CallerPresetRepository repository;

  SaveCallerPreset(this.repository);

  @override
  Future<Either<Failure, List<CallerPreset>>> call(CallConfig config) async {
    if (config.callerName.trim().isEmpty) {
      return Left(
        InvalidCallConfigFailure(
          const CallConfigIssue(
            CallConfigField.callerName,
            FailureReason.callerNameRequired,
          ),
        ),
      );
    }
    return repository.savePreset(config);
  }
}
