import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/caller_preset_model.dart';

abstract class CallerPresetLocalDataSource {
  Future<List<CallerPresetModel>> load();

  Future<void> save(List<CallerPresetModel> presets);

  Future<String?> keepMedia(String? path, {required String id});

  Future<void> deleteMedia(String? path);
}

class CallerPresetLocalDataSourceImpl implements CallerPresetLocalDataSource {
  static const _key = 'caller_presets';
  static const _folder = 'caller_presets';

  final SharedPreferences preferences;

  CallerPresetLocalDataSourceImpl({required this.preferences});

  @override
  Future<List<CallerPresetModel>> load() async {
    final raw = preferences.getString(_key);
    if (raw == null) return const [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => CallerPresetModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException catch (e) {
      throw CacheException(FailureReason.presetFailed, e.message);
    } on TypeError catch (e) {
      throw CacheException(FailureReason.presetFailed, '$e');
    }
  }

  @override
  Future<void> save(List<CallerPresetModel> presets) async {
    final saved = await preferences.setString(
      _key,
      jsonEncode(presets.map((p) => p.toJson()).toList()),
    );
    if (!saved) throw const CacheException(FailureReason.presetFailed);
  }

  @override
  Future<String?> keepMedia(String? path, {required String id}) async {
    if (path == null || path.isEmpty) return null;
    final source = File(path);
    if (!await source.exists()) return null;
    try {
      final dir = Directory(
        '${(await getApplicationSupportDirectory()).path}/$_folder',
      );
      if (path.startsWith(dir.path)) return path;
      await dir.create(recursive: true);
      final extension = path.contains('.') ? path.split('.').last : 'bin';
      final target = File(
        '${dir.path}/${id}_${DateTime.now().microsecondsSinceEpoch}.$extension',
      );
      return (await source.copy(target.path)).path;
    } on FileSystemException catch (e) {
      throw CacheException(FailureReason.presetFailed, e.message);
    }
  }

  @override
  Future<void> deleteMedia(String? path) async {
    if (path == null) return;
    final file = File(path);
    if (!file.path.contains('/$_folder/')) return;
    try {
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      return;
    }
  }
}
