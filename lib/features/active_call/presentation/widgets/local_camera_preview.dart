import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class LocalCameraPreview extends StatelessWidget {
  final int? viewId;
  final double aspectRatio;
  final bool isCameraOn;
  final bool isLoading;

  const LocalCameraPreview({
    super.key,
    required this.viewId,
    required this.aspectRatio,
    required this.isCameraOn,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final id = viewId;
    return ColoredBox(
      color: AppColors.callSurface,
      child: switch ((id, isCameraOn, isLoading)) {
        (_, _, true) || (null, _, _) => const Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white70,
            ),
          ),
        ),
        (_, false, _) => const Center(
          child: Icon(Icons.videocam_off, color: Colors.white54, size: 32),
        ),
        (final int cameraId, true, false) => SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: 1000,
              height: 1000 * aspectRatio,
              child: CameraPlatform.instance.buildPreview(cameraId),
            ),
          ),
        ),
      },
    );
  }
}
