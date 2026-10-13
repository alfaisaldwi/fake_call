import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/duration_format.dart';
import '../../../fake_call/domain/entities/call_config.dart';
import '../bloc/active_call_bloc.dart';
import 'blurred_avatar_background.dart';
import 'call_top_bar.dart';
import '../../../../core/widgets/caller_avatar.dart';
import 'voice_call_actions.dart';

class VoiceCallView extends StatelessWidget {
  final CallConfig config;
  final ActiveCallInProgress state;
  final VoidCallback onBack;
  final VoidCallback onEndCall;

  const VoiceCallView({
    super.key,
    required this.config,
    required this.state,
    required this.onBack,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ActiveCallBloc>();
    return Stack(
      fit: StackFit.expand,
      children: [
        BlurredAvatarBackground(avatarPath: config.callerAvatarPath),
        Column(
          children: [
            SafeArea(bottom: false, child: CallTopBar(onBack: onBack)),
            Expanded(
              child: _CallerIdentity(
                config: config,
                status: state.isMediaLoading
                    ? AppLocalizations.of(context).switchingToVideo
                    : state.elapsed.toCallTimer(),
              ),
            ),
            VoiceCallActions(
              isSpeakerOn: state.isSpeakerOn,
              isMuted: state.isMuted,
              onToggleSpeaker: () => bloc.add(const ActiveCallSpeakerToggled()),
              onRequestVideo: () => bloc.add(const ActiveCallVideoRequested()),
              onToggleMute: () => bloc.add(const ActiveCallMuteToggled()),
              onEndCall: onEndCall,
            ),
          ],
        ),
      ],
    );
  }
}

class _CallerIdentity extends StatelessWidget {
  final CallConfig config;
  final String status;

  const _CallerIdentity({required this.config, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CallerAvatar(
          callerName: config.callerName,
          avatarPath: config.callerAvatarPath,
          radius: 76,
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            config.callerName,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          status,
          style: const TextStyle(
            color: AppColors.callSecondaryText,
            fontSize: 16,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
