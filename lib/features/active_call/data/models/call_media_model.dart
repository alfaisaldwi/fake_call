import '../../domain/entities/call_media.dart';

class CallMediaModel extends CallMedia {
  const CallMediaModel({
    required super.cameraViewId,
    required super.cameraAspectRatio,
    required super.remoteVideoViewId,
    required super.remoteVideoAspectRatio,
    super.remoteVideoQuarterTurns,
    super.isCameraOn,
  });

  factory CallMediaModel.fromJson(Map<String, dynamic> json) {
    return CallMediaModel(
      cameraViewId: json['cameraViewId'] as int,
      cameraAspectRatio: (json['cameraAspectRatio'] as num).toDouble(),
      remoteVideoViewId: json['remoteVideoViewId'] as int,
      remoteVideoQuarterTurns: json['remoteVideoQuarterTurns'] as int? ?? 0,
      remoteVideoAspectRatio: (json['remoteVideoAspectRatio'] as num)
          .toDouble(),
      isCameraOn: json['isCameraOn'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cameraViewId': cameraViewId,
      'cameraAspectRatio': cameraAspectRatio,
      'remoteVideoViewId': remoteVideoViewId,
      'remoteVideoAspectRatio': remoteVideoAspectRatio,
      'remoteVideoQuarterTurns': remoteVideoQuarterTurns,
      'isCameraOn': isCameraOn,
    };
  }
}
