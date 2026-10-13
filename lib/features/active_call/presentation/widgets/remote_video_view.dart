import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

class RemoteVideoView extends StatelessWidget {
  static const _blurSigma = 36.0;

  final int viewId;
  final double aspectRatio;
  final int quarterTurns;
  final bool isPortrait;

  const RemoteVideoView({
    super.key,
    required this.viewId,
    required this.aspectRatio,
    required this.quarterTurns,
    required this.isPortrait,
  });

  Widget _video() {
    final view = VideoPlayerPlatform.instance.buildViewWithOptions(
      VideoViewOptions(playerId: viewId),
    );
    return quarterTurns == 0
        ? view
        : RotatedBox(quarterTurns: quarterTurns, child: view);
  }

  Widget _fitted(BoxFit fit) {
    return FittedBox(
      fit: fit,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(width: 1000 * aspectRatio, height: 1000, child: _video()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isPortrait) return SizedBox.expand(child: _fitted(BoxFit.cover));
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: _blurSigma,
              sigmaY: _blurSigma,
              tileMode: TileMode.mirror,
            ),
            child: Transform.scale(scale: 1.15, child: _fitted(BoxFit.cover)),
          ),
        ),
        const ColoredBox(color: Color(0x33000000)),
        Center(child: _fitted(BoxFit.contain)),
      ],
    );
  }
}
