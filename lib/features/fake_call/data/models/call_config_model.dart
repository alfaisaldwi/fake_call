import 'package:flutter_callkit_incoming/entities/entities.dart';

import '../../../../l10n/app_localizations.dart';

import '../../domain/entities/call_config.dart';

class CallConfigModel extends CallConfig {
  static const _appName = 'Fake Call';
  static const _androidRingtone = 'incoming_call';
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
    };
  }

  CallKitParams toCallKitParams({
    required String callId,
    required int attempt,
    required AppLocalizations strings,
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
        ringtonePath: _androidRingtone,
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
        ringtonePath: _iosRingtone,
      ),
    );
  }
}
