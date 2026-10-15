import 'package:equatable/equatable.dart';

class CallMedia extends Equatable {
  final int cameraViewId;
  final double cameraAspectRatio;
  final int remoteVideoViewId;
  final double remoteVideoAspectRatio;
  final int remoteVideoQuarterTurns;
  final bool isCameraOn;

  const CallMedia({
    required this.cameraViewId,
    required this.cameraAspectRatio,
    required this.remoteVideoViewId,
    required this.remoteVideoAspectRatio,
    this.remoteVideoQuarterTurns = 0,
    this.isCameraOn = true,
  });

  bool get isRemoteVideoPortrait => remoteVideoAspectRatio < 0.9;

  @override
  List<Object> get props => [
    cameraViewId,
    cameraAspectRatio,
    remoteVideoViewId,
    remoteVideoAspectRatio,
    remoteVideoQuarterTurns,
    isCameraOn,
  ];
}
