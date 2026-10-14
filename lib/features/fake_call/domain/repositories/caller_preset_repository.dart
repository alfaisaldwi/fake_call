import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/call_config.dart';
import '../entities/caller_preset.dart';

abstract class CallerPresetRepository {
  Future<Either<Failure, List<CallerPreset>>> getPresets();

  Future<Either<Failure, List<CallerPreset>>> savePreset(CallConfig config);

  Future<Either<Failure, List<CallerPreset>>> deletePreset(String id);
}
