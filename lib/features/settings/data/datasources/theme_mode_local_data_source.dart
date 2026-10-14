import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/app_theme_mode.dart';

abstract class ThemeModeLocalDataSource {
  Future<AppThemeMode> getThemeMode();

  Future<void> saveThemeMode(AppThemeMode mode);
}

class ThemeModeLocalDataSourceImpl implements ThemeModeLocalDataSource {
  static const _key = 'app_theme_mode';

  final SharedPreferences preferences;

  ThemeModeLocalDataSourceImpl({required this.preferences});

  @override
  Future<AppThemeMode> getThemeMode() async {
    final stored = preferences.getString(_key);
    return AppThemeMode.values.asNameMap()[stored] ?? AppThemeMode.system;
  }

  @override
  Future<void> saveThemeMode(AppThemeMode mode) async {
    final saved = await preferences.setString(_key, mode.name);
    if (!saved) throw const CacheException(FailureReason.settingsFailed);
  }
}
