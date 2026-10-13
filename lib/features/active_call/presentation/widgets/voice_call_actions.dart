import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import 'call_action_button.dart';

class VoiceCallActions extends StatelessWidget {
  final bool isSpeakerOn;
  final bool isMuted;
  final VoidCallback onToggleSpeaker;
  final VoidCallback onRequestVideo;
  final VoidCallback onToggleMute;
  final VoidCallback onEndCall;

  const VoiceCallActions({
    super.key,
    required this.isSpeakerOn,
    required this.isMuted,
    required this.onToggleSpeaker,
    required this.onRequestVideo,
    required this.onToggleMute,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(24, 10, 24, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.callPanel,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CallActionButton(
                icon: isSpeakerOn ? Icons.volume_up : Icons.volume_up_outlined,
                semanticLabel: l10n.speaker,
                isActive: isSpeakerOn,
                onPressed: onToggleSpeaker,
              ),
              CallActionButton(
                icon: Icons.videocam_outlined,
                semanticLabel: l10n.switchToVideo,
                onPressed: onRequestVideo,
              ),
              CallActionButton(
                icon: isMuted ? Icons.mic_off : Icons.mic_none,
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
        ],
      ),
    );
  }
}
