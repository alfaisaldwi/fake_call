import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart' as cam;
import 'package:flutter/services.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../../../core/error/exceptions.dart';
import '../models/call_media_model.dart';

abstract class CallMediaLocalDataSource {
  Future<CallMediaModel> startMedia({String? videoPath});

  Future<CallMediaModel> switchCamera();

  Future<void> setCameraEnabled(bool enabled);

  Future<void> setPlaybackPaused(bool paused);

  Future<void> stopMedia();
}

class CallMediaLocalDataSourceImpl implements CallMediaLocalDataSource {
  static const _deniedCodes = {
    'CameraAccessDenied',
    'CameraAccessDeniedWithoutPrompt',
    'CameraAccessRestricted',
  };

  static const _videoInitTimeout = Duration(seconds: 10);

  final String videoAssetPath;

  final VideoPlayerPlatform _videoPlatform = VideoPlayerPlatform.instance;

  cam.CameraController? _camera;
  int? _videoPlayerId;
  double _videoAspectRatio = 9 / 16;
  int _videoQuarterTurns = 0;
  bool _videoPlatformReady = false;

  CallMediaLocalDataSourceImpl({required this.videoAssetPath});

  @override
  Future<CallMediaModel> startMedia({String? videoPath}) async {
    await stopMedia();
    try {
      await _startCamera(cam.CameraLensDirection.front);
      await _startRemoteVideo(videoPath);
      return _currentMedia();
    } catch (_) {
      await stopMedia();
      rethrow;
    }
  }

  @override
  Future<CallMediaModel> switchCamera() async {
    final current = _camera;
    if (current == null) {
      throw const MediaException(FailureReason.cameraUnavailable);
    }
    final nextDirection =
        current.description.lensDirection == cam.CameraLensDirection.front
        ? cam.CameraLensDirection.back
        : cam.CameraLensDirection.front;
    _camera = null;
    await current.dispose();
    await _startCamera(nextDirection);
    return _currentMedia();
  }

  @override
  Future<void> setCameraEnabled(bool enabled) async {
    final camera = _camera;
    if (camera == null) {
      throw const MediaException(FailureReason.cameraUnavailable);
    }
    try {
      enabled ? await camera.resumePreview() : await camera.pausePreview();
    } on cam.CameraException catch (e) {
      throw MediaException(FailureReason.cameraUnavailable, e.description);
    }
  }

  @override
  Future<void> setPlaybackPaused(bool paused) async {
    final videoPlayerId = _videoPlayerId;
    if (videoPlayerId == null) return;
    try {
      paused
          ? await _videoPlatform.pause(videoPlayerId)
          : await _videoPlatform.play(videoPlayerId);
    } on PlatformException catch (e) {
      throw MediaException(FailureReason.videoUnavailable, e.message);
    }
  }

  @override
  Future<void> stopMedia() async {
    final camera = _camera;
    final videoPlayerId = _videoPlayerId;
    _camera = null;
    _videoPlayerId = null;
    await camera?.dispose();
    if (videoPlayerId != null) await _videoPlatform.dispose(videoPlayerId);
  }

  CallMediaModel _currentMedia() {
    final camera = _camera;
    final videoPlayerId = _videoPlayerId;
    if (camera == null || videoPlayerId == null) {
      throw const MediaException(FailureReason.cameraUnavailable);
    }
    return CallMediaModel(
      cameraViewId: camera.cameraId,
      cameraAspectRatio: camera.value.aspectRatio,
      remoteVideoViewId: videoPlayerId,
      remoteVideoAspectRatio: _videoAspectRatio,
      remoteVideoQuarterTurns: _videoQuarterTurns,
    );
  }

  Future<void> _startCamera(cam.CameraLensDirection direction) async {
    try {
      final cameras = await cam.availableCameras();
      if (cameras.isEmpty) {
        throw const MediaException(FailureReason.cameraUnavailable);
      }
      final description = cameras.firstWhere(
        (c) => c.lensDirection == direction,
        orElse: () => cameras.first,
      );
      final controller = cam.CameraController(
        description,
        cam.ResolutionPreset.medium,
        enableAudio: false,
      );
      _camera = controller;
      await controller.initialize();
    } on cam.CameraException catch (e) {
      if (_deniedCodes.contains(e.code)) {
        throw PermissionException(FailureReason.cameraPermissionDenied, e.code);
      }
      throw MediaException(FailureReason.cameraUnavailable, e.description);
    }
  }

  Future<void> _startRemoteVideo(String? customPath) async {
    if (customPath != null && await File(customPath).exists()) {
      try {
        await _playVideo(
          DataSource(
            sourceType: DataSourceType.file,
            uri: Uri.file(customPath).toString(),
          ),
          customPath,
        );
        return;
      } on MediaException {
        await _disposeVideo();
      }
    }
    await _playVideo(
      DataSource(sourceType: DataSourceType.asset, asset: videoAssetPath),
      videoAssetPath,
    );
  }

  Future<void> _playVideo(DataSource source, String label) async {
    try {
      if (!_videoPlatformReady) {
        await _videoPlatform.init();
        await _videoPlatform.setMixWithOthers(true);
        _videoPlatformReady = true;
      }
      final playerId = await _videoPlatform.createWithOptions(
        VideoCreationOptions(
          dataSource: source,
          viewType: VideoViewType.textureView,
        ),
      );
      if (playerId == null) {
        throw MediaException(FailureReason.videoUnavailable, label);
      }
      _videoPlayerId = playerId;
      final initialized = await _videoPlatform
          .videoEventsFor(playerId)
          .firstWhere((e) => e.eventType == VideoEventType.initialized)
          .timeout(_videoInitTimeout);
      await _videoPlatform.setLooping(playerId, true);
      await _videoPlatform.play(playerId);
      final size = initialized.size;
      if (size != null && size.height > 0) {
        _videoAspectRatio = size.width / size.height;
      }
      _videoQuarterTurns = ((initialized.rotationCorrection ?? 0) ~/ 90) % 4;
    } on PlatformException {
      throw MediaException(FailureReason.videoUnavailable, label);
    } on TimeoutException {
      throw MediaException(FailureReason.videoUnavailable, label);
    }
  }

  Future<void> _disposeVideo() async {
    final playerId = _videoPlayerId;
    _videoPlayerId = null;
    if (playerId != null) await _videoPlatform.dispose(playerId);
  }
}
