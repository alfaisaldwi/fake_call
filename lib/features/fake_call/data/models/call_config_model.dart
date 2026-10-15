import 'package:flutter_callkit_incoming/entities/entities.dart';

import '../../../../l10n/app_localizations.dart';

import '../../domain/entities/call_config.dart';
import '../../domain/entities/clock_time.dart';
import '../../domain/entities/call_preferences.dart';

class CallConfigModel extends CallConfig {
  static const _appName = 'Fake Calling';
  static const _androidRingtones = {
    CallRingtone.app: 'incoming_call',
    CallRingtone.system: 'system_ringtone_default',
    CallRingtone.silent: 'silence',
  };
  static const _systemRingtone = 'system_ringtone_default';
  static const _iosRingtone = 'incoming_call.caf';

  const CallConfigModel({
    required super.delayInSeconds,
    required super.callerName,
    super.callType,
    super.callerAvatarPath,
    super.callerVideoPath,
    super.autoHangupSeconds,
    super.autoRecallCount,
    super.autoRecallInterval,
    super.ringAt,
  });

  factory CallConfigModel.fromEntity(CallConfig entity) {
    return CallConfigModel(
      delayInSeconds: entity.delayInSeconds,
      callerName: entity.callerName,
      callType: entity.callType,
      callerAvatarPath: entity.callerAvatarPath,
      callerVideoPath: entity.callerVideoPath,
      autoHangupSeconds: entity.autoHangupSeconds,
      autoRecallCount: entity.autoRecallCount,
      autoRecallInterval: entity.autoRecallInterval,
      ringAt: entity.ringAt,
    );
  }

  factory CallConfigModel.fromJson(Map<String, dynamic> json) {
    return CallConfigModel(
      delayInSeconds: json['delayInSeconds'] as int,
      callerName: json['callerName'] as String,
      callType: CallType.values.byName(json['callType'] as String? ?? 'video'),
      callerAvatarPath: json['callerAvatarPath'] as String?,
      callerVideoPath: json['callerVideoPath'] as String?,
      autoHangupSeconds: json['autoHangupSeconds'] as int? ?? 0,
      autoRecallCount: json['autoRecallCount'] as int? ?? 0,
      autoRecallInterval: json['autoRecallInterval'] as int? ?? 10,
      ringAt: _clockTimeFromJson(json['ringAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'delayInSeconds': delayInSeconds,
      'callerName': callerName,
      'callType': callType.name,
      'callerAvatarPath': callerAvatarPath,
      'callerVideoPath': callerVideoPath,
      'autoHangupSeconds': autoHangupSeconds,
      'autoRecallCount': autoRecallCount,
      'autoRecallInterval': autoRecallInterval,
      'ringAt': ringAt == null
          ? null
          : {'hour': ringAt!.hour, 'minute': ringAt!.minute},
    };
  }

  static ClockTime? _clockTimeFromJson(Object? json) {
    if (json is! Map) return null;
    final hour = json['hour'];
    final minute = json['minute'];
    if (hour is! int || minute is! int) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return ClockTime(hour, minute);
  }

  CallKitParams toCallKitParams({
    required String callId,
    required int attempt,
    required AppLocalizations strings,
    CallRingtone ringtone = CallRingtone.app,
    String? nativeAvatarUrl,
  }) {
    return CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: _appName,
      avatar: nativeAvatarUrl,
      handle: isVideoCall
          ? strings.incomingVideoCall
          : strings.incomingVoiceCall,
      type: isVideoCall ? 1 : 0,
      duration: ringTimeoutSeconds * 1000,
      extra: {...toJson(), 'attempt': attempt},
      missedCallNotification: NotificationParams(
        showNotification: false,
        subtitle: strings.nativeMissedCall,
        isShowCallback: false,
      ),
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        isShowCallID: true,
        backgroundUrl: isVideoCall ? nativeAvatarUrl : null,
        ringtonePath: _androidRingtones[ringtone],
        backgroundColor: '#0B141A',
        actionColor: '#25D366',
        textColor: '#FFFFFF',
        incomingCallNotificationChannelName: strings.nativeIncomingChannel,
        missedCallNotificationChannelName: strings.nativeMissedChannel,
        isShowFullLockedScreen: true,
        isImportant: true,
        textAccept: strings.nativeAccept,
        textDecline: strings.nativeDecline,
      ),
      ios: IOSParams(
        handleType: 'generic',
        supportsVideo: isVideoCall,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: isVideoCall ? 'videoChat' : 'voiceChat',
        supportsDTMF: false,
        supportsHolding: false,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: ringtone == CallRingtone.system
            ? _systemRingtone
            : _iosRingtone,
      ),
    );
  }
}
