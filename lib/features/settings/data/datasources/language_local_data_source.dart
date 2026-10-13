import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/app_language.dart';

abstract class LanguageLocalDataSource {
  Future<AppLanguage> getLanguage();

  Future<void> saveLanguage(AppLanguage language);
}

class LanguageLocalDataSourceImpl implements LanguageLocalDataSource {
  static const _key = 'app_language';

  final SharedPreferences preferences;

  LanguageLocalDataSourceImpl({required this.preferences});

  @override
  Future<AppLanguage> getLanguage() async {
    final stored = preferences.getString(_key);
    return AppLanguage.values.asNameMap()[stored] ?? AppLanguage.system;
  }

  @override
  Future<void> saveLanguage(AppLanguage language) async {
    final saved = await preferences.setString(_key, language.name);
    if (!saved) throw const CacheException(FailureReason.settingsFailed);
  }
}
