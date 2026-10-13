import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class LocalCameraPreview extends StatelessWidget {
  static const width = 112.0;
  static const height = 168.0;

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
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.callSurface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Color(0x66000000))],
      ),
      clipBehavior: Clip.antiAlias,
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
        (_, false, _) => const Icon(
          Icons.videocam_off,
          color: Colors.white54,
          size: 32,
        ),
        (final int cameraId, true, false) => FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: width,
            height: width * aspectRatio,
            child: CameraPlatform.instance.buildPreview(cameraId),
          ),
        ),
      },
    );
  }
}
