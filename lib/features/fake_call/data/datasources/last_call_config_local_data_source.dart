import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/call_config_model.dart';

abstract class LastCallConfigLocalDataSource {
  Future<CallConfigModel?> load();

  Future<void> save(CallConfigModel config);
}

class LastCallConfigLocalDataSourceImpl
    implements LastCallConfigLocalDataSource {
  static const _key = 'last_call_config';

  final SharedPreferences preferences;

  LastCallConfigLocalDataSourceImpl({required this.preferences});

  @override
  Future<CallConfigModel?> load() async {
    final raw = preferences.getString(_key);
    if (raw == null) return null;
    try {
      return CallConfigModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException catch (e) {
      throw CacheException(FailureReason.settingsFailed, e.message);
    } on TypeError catch (e) {
      throw CacheException(FailureReason.settingsFailed, '$e');
    }
  }

  @override
  Future<void> save(CallConfigModel config) async {
    final saved = await preferences.setString(
      _key,
      jsonEncode(config.toJson()),
    );
    if (!saved) throw const CacheException(FailureReason.settingsFailed);
  }
}
