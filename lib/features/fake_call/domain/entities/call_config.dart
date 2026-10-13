import 'package:equatable/equatable.dart';

import '../../../../core/error/failure_reason.dart';
import 'call_config_issue.dart';

enum CallType { voice, video }

class CallConfig extends Equatable {
  static const defaultRingSeconds = 30;
  static const maxRecallCount = 10;
  static const minRecallIntervalSeconds = 3;

  final int delayInSeconds;
  final String callerName;
  final CallType callType;
  final String? callerAvatarPath;
  final String? callerVideoPath;
  final int autoHangupSeconds;
  final int autoRecallCount;
  final int autoRecallInterval;

  const CallConfig({
    required this.delayInSeconds,
    required this.callerName,
    this.callType = CallType.video,
    this.callerAvatarPath,
    this.callerVideoPath,
    this.autoHangupSeconds = 0,
    this.autoRecallCount = 0,
    this.autoRecallInterval = 10,
  });

  bool get isVideoCall => callType == CallType.video;

  bool get hasAvatar => callerAvatarPath?.isNotEmpty ?? false;

  bool get hasCustomVideo => callerVideoPath?.isNotEmpty ?? false;

  bool get hasAutoHangup => autoHangupSeconds > 0;

  int get totalAttempts => autoRecallCount + 1;

  int get ringTimeoutSeconds =>
      hasAutoHangup ? autoHangupSeconds : defaultRingSeconds;

  bool canRecallAfter(int attempt) => attempt < totalAttempts;

  CallConfigIssue? get validationIssue {
    if (callerName.trim().isEmpty) {
      return const CallConfigIssue(
        CallConfigField.callerName,
        FailureReason.callerNameRequired,
      );
    }
    if (delayInSeconds < 0) {
      return const CallConfigIssue(
        CallConfigField.delay,
        FailureReason.invalidDelay,
      );
    }
    if (autoHangupSeconds < 0) {
      return const CallConfigIssue(
        CallConfigField.autoHangup,
        FailureReason.invalidAutoHangup,
      );
    }
    if (autoRecallCount < 0 || autoRecallCount > maxRecallCount) {
      return const CallConfigIssue(
        CallConfigField.autoRecall,
        FailureReason.invalidRecallCount,
        limit: maxRecallCount,
      );
    }
    if (autoRecallCount > 0 && autoRecallInterval < minRecallIntervalSeconds) {
      return const CallConfigIssue(
        CallConfigField.autoRecall,
        FailureReason.recallIntervalTooShort,
        limit: minRecallIntervalSeconds,
      );
    }
    return null;
  }

  CallConfig copyWith({
    int? delayInSeconds,
    String? callerName,
    CallType? callType,
    String? callerAvatarPath,
    bool clearAvatar = false,
    String? callerVideoPath,
    bool clearVideo = false,
    int? autoHangupSeconds,
    int? autoRecallCount,
    int? autoRecallInterval,
  }) {
    return CallConfig(
      delayInSeconds: delayInSeconds ?? this.delayInSeconds,
      callerName: callerName ?? this.callerName,
      callType: callType ?? this.callType,
      callerAvatarPath: clearAvatar
          ? null
          : callerAvatarPath ?? this.callerAvatarPath,
      callerVideoPath: clearVideo
          ? null
          : callerVideoPath ?? this.callerVideoPath,
      autoHangupSeconds: autoHangupSeconds ?? this.autoHangupSeconds,
      autoRecallCount: autoRecallCount ?? this.autoRecallCount,
      autoRecallInterval: autoRecallInterval ?? this.autoRecallInterval,
    );
  }

  @override
  List<Object?> get props => [
    delayInSeconds,
    callerName,
    callType,
    callerAvatarPath,
    callerVideoPath,
    autoHangupSeconds,
    autoRecallCount,
    autoRecallInterval,
  ];
}
