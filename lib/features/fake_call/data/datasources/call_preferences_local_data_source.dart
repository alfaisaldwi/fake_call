import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/call_preferences.dart';

abstract class CallPreferencesLocalDataSource {
  Future<CallPreferences> getPreferences();

  Future<void> savePreferences(CallPreferences preferences);
}

class CallPreferencesLocalDataSourceImpl
    implements CallPreferencesLocalDataSource {
  static const _ringtoneKey = 'ring_ringtone';
  static const _vibrateKey = 'ring_vibrate';
  static const _initialDurationKey = 'call_initial_duration';

  final SharedPreferences preferences;

  CallPreferencesLocalDataSourceImpl({required this.preferences});

  @override
  Future<CallPreferences> getPreferences() async {
    final ringtone = preferences.getString(_ringtoneKey);
    return CallPreferences(
      ringtone: CallRingtone.values.asNameMap()[ringtone] ?? CallRingtone.app,
      vibrate: preferences.getBool(_vibrateKey) ?? true,
      initialDurationSeconds: preferences.getInt(_initialDurationKey) ?? 0,
    );
  }

  @override
  Future<void> savePreferences(CallPreferences call) async {
    final saved =
        await preferences.setString(_ringtoneKey, call.ringtone.name) &&
        await preferences.setBool(_vibrateKey, call.vibrate) &&
        await preferences.setInt(
          _initialDurationKey,
          call.initialDurationSeconds,
        );
    if (!saved) throw const CacheException(FailureReason.settingsFailed);
  }
}
