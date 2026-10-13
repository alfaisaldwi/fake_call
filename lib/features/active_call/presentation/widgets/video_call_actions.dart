import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import 'call_action_button.dart';

class VideoCallActions extends StatelessWidget {
  final bool isCameraOn;
  final bool isMuted;
  final bool canControlCamera;
  final VoidCallback onSwitchCamera;
  final VoidCallback onToggleVideo;
  final VoidCallback onToggleMute;
  final VoidCallback onEndCall;

  const VideoCallActions({
    super.key,
    required this.isCameraOn,
    required this.isMuted,
    required this.canControlCamera,
    required this.onSwitchCamera,
    required this.onToggleVideo,
    required this.onToggleMute,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.callPanel,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CallActionButton(
            icon: Icons.cameraswitch_outlined,
            semanticLabel: l10n.switchCamera,
            onPressed: canControlCamera && isCameraOn ? onSwitchCamera : null,
          ),
          CallActionButton(
            icon: isCameraOn ? Icons.videocam : Icons.videocam_off,
            semanticLabel: isCameraOn ? l10n.turnOffVideo : l10n.turnOnVideo,
            isActive: !isCameraOn,
            onPressed: canControlCamera ? onToggleVideo : null,
          ),
          CallActionButton(
            icon: isMuted ? Icons.mic_off : Icons.mic,
            semanticLabel: isMuted ? l10n.unmuteMic : l10n.muteMic,
            isActive: isMuted,
            onPressed: onToggleMute,
          ),
          CallActionButton(
            icon: Icons.call_end,
            semanticLabel: l10n.endCall,
            backgroundColor: AppColors.endCall,
            onPressed: onEndCall,
          ),
        ],
      ),
    );
  }
}
