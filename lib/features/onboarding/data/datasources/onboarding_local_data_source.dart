import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> isCompleted();

  Future<void> markCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  static const _key = 'onboarding_completed';

  final SharedPreferences preferences;

  OnboardingLocalDataSourceImpl({required this.preferences});

  @override
  Future<bool> isCompleted() async => preferences.getBool(_key) ?? false;

  @override
  Future<void> markCompleted() async {
    final saved = await preferences.setBool(_key, true);
    if (!saved) throw const CacheException(FailureReason.settingsFailed);
  }
}
