import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';

abstract class CoachMarksLocalDataSource {
  Future<bool> isSeen();

  Future<void> setSeen(bool seen);
}

class CoachMarksLocalDataSourceImpl implements CoachMarksLocalDataSource {
  static const _key = 'coach_marks_seen';

  final SharedPreferences preferences;

  CoachMarksLocalDataSourceImpl({required this.preferences});

  @override
  Future<bool> isSeen() async => preferences.getBool(_key) ?? false;

  @override
  Future<void> setSeen(bool seen) async {
    final saved = await preferences.setBool(_key, seen);
    if (!saved) throw const CacheException(FailureReason.settingsFailed);
  }
}
