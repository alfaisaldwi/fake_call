import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/l10n/app_locale_holder.dart';
import '../models/call_config_model.dart';

abstract class MissedCallNotificationDataSource {
  Future<void> showMissedCall(CallConfigModel config, {required int count});
}

class MissedCallNotificationDataSourceImpl
    implements MissedCallNotificationDataSource {
  static const _channel = MethodChannel('com.elumi.prankcall/missed_call');
  static const _iosThread = 'missed_calls';

  final FlutterLocalNotificationsPlugin plugin;
  final AppLocaleHolder localeHolder;

  bool _iosInitialized = false;

  MissedCallNotificationDataSourceImpl({
    required this.plugin,
    required this.localeHolder,
  });

  @override
  Future<void> showMissedCall(
    CallConfigModel config, {
    required int count,
  }) async {
    final strings = localeHolder.strings;
    final title = config.callerName.trim();
    final body = switch ((config.isVideoCall, count > 1)) {
      (true, true) => strings.missedVideoCalls(count),
      (true, false) => strings.missedVideoCall,
      (false, true) => strings.missedVoiceCalls(count),
      (false, false) => strings.missedVoiceCall,
    };
    final id = title.toLowerCase().hashCode & 0x7fffffff;
    if (Platform.isAndroid) {
      await _channel.invokeMethod<void>('showMissedCall', {
        'id': id,
        'title': title,
        'body': body,
        'channelName': strings.nativeMissedChannel,
        'avatarPath': config.callerAvatarPath,
        'count': count,
      });
      return;
    }
    await _ensureIosInitialized();
    await plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        iOS: DarwinNotificationDetails(threadIdentifier: _iosThread),
      ),
    );
  }

  Future<void> _ensureIosInitialized() async {
    if (_iosInitialized) return;
    await plugin.initialize(
      settings: const InitializationSettings(
        iOS: DarwinInitializationSettings(),
      ),
    );
    _iosInitialized = true;
  }
}
