import 'package:equatable/equatable.dart';

import 'call_config.dart';

class CallerPreset extends Equatable {
  static const maxPresets = 8;

  final String id;
  final String name;
  final CallType callType;
  final String? avatarPath;
  final String? videoPath;

  const CallerPreset({
    required this.id,
    required this.name,
    required this.callType,
    this.avatarPath,
    this.videoPath,
  });

  CallConfig applyTo(CallConfig config) {
    return config.copyWith(
      callerName: name,
      callType: callType,
      callerAvatarPath: avatarPath,
      clearAvatar: avatarPath == null,
      callerVideoPath: videoPath,
      clearVideo: videoPath == null,
    );
  }

  bool matches(CallConfig config) =>
      config.callerName.trim().toLowerCase() == name.trim().toLowerCase();

  @override
  List<Object?> get props => [id, name, callType, avatarPath, videoPath];
}
