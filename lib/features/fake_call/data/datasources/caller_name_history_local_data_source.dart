import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/caller_name_history_model.dart';

abstract class CallerNameHistoryLocalDataSource {
  Future<CallerNameHistoryModel> load();

  Future<void> save(CallerNameHistoryModel history);
}

class CallerNameHistoryLocalDataSourceImpl
    implements CallerNameHistoryLocalDataSource {
  static const _key = 'caller_name_history';

  final SharedPreferences preferences;

  CallerNameHistoryLocalDataSourceImpl({required this.preferences});

  @override
  Future<CallerNameHistoryModel> load() async {
    final raw = preferences.getString(_key);
    if (raw == null) return const CallerNameHistoryModel([]);
    try {
      return CallerNameHistoryModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } on FormatException catch (e) {
      throw CacheException(FailureReason.historyFailed, e.message);
    } on TypeError catch (e) {
      throw CacheException(FailureReason.historyFailed, '$e');
    }
  }

  @override
  Future<void> save(CallerNameHistoryModel history) async {
    final saved = await preferences.setString(
      _key,
      jsonEncode(history.toJson()),
    );
    if (!saved) throw const CacheException(FailureReason.historyFailed);
  }
}
