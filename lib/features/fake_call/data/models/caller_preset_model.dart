import '../../domain/entities/call_config.dart';
import '../../domain/entities/caller_preset.dart';

class CallerPresetModel extends CallerPreset {
  const CallerPresetModel({
    required super.id,
    required super.name,
    required super.callType,
    super.avatarPath,
    super.videoPath,
  });

  factory CallerPresetModel.fromJson(Map<String, dynamic> json) {
    return CallerPresetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      callType: CallType.values.asNameMap()[json['callType']] ?? CallType.video,
      avatarPath: json['avatarPath'] as String?,
      videoPath: json['videoPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'callType': callType.name,
    'avatarPath': avatarPath,
    'videoPath': videoPath,
  };
}
