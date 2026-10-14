import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/call_config.dart';
import '../../domain/entities/caller_preset.dart';
import '../../domain/repositories/caller_preset_repository.dart';
import '../datasources/caller_preset_local_data_source.dart';
import '../models/caller_preset_model.dart';

class CallerPresetRepositoryImpl implements CallerPresetRepository {
  final CallerPresetLocalDataSource dataSource;
  final Uuid uuid;

  CallerPresetRepositoryImpl({required this.dataSource, required this.uuid});

  @override
  Future<Either<Failure, List<CallerPreset>>> getPresets() {
    return _guard(dataSource.load);
  }

  @override
  Future<Either<Failure, List<CallerPreset>>> savePreset(CallConfig config) {
    return _guard(() async {
      final presets = await dataSource.load();
      final existing = presets.where((p) => p.matches(config)).firstOrNull;
      final id = existing?.id ?? uuid.v4();
      final preset = CallerPresetModel(
        id: id,
        name: config.callerName.trim(),
        callType: config.callType,
        avatarPath: await dataSource.keepMedia(config.callerAvatarPath, id: id),
        videoPath: await dataSource.keepMedia(config.callerVideoPath, id: id),
      );
      if (existing != null) {
        if (existing.avatarPath != preset.avatarPath) {
          await dataSource.deleteMedia(existing.avatarPath);
        }
        if (existing.videoPath != preset.videoPath) {
          await dataSource.deleteMedia(existing.videoPath);
        }
      }
      final others = presets.where((p) => p.id != id).toList();
      final updated = [preset, ...others];
      for (final dropped in updated.skip(CallerPreset.maxPresets)) {
        await dataSource.deleteMedia(dropped.avatarPath);
        await dataSource.deleteMedia(dropped.videoPath);
      }
      final kept = updated.take(CallerPreset.maxPresets).toList();
      await dataSource.save(kept);
      return kept;
    });
  }

  @override
  Future<Either<Failure, List<CallerPreset>>> deletePreset(String id) {
    return _guard(() async {
      final presets = await dataSource.load();
      final target = presets.where((p) => p.id == id).firstOrNull;
      if (target == null) return presets;
      await dataSource.deleteMedia(target.avatarPath);
      await dataSource.deleteMedia(target.videoPath);
      final kept = presets.where((p) => p.id != id).toList();
      await dataSource.save(kept);
      return kept;
    });
  }

  Future<Either<Failure, List<CallerPreset>>> _guard(
    Future<List<CallerPresetModel>> Function() action,
  ) async {
    try {
      return Right(await action());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.reason, detail: e.detail));
    }
  }
}
