import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/duration_format.dart';
import '../../../fake_call/domain/entities/call_config.dart';
import '../bloc/active_call_bloc.dart';
import 'blurred_avatar_background.dart';
import 'call_top_bar.dart';
import 'draggable_pip.dart';
import '../../../../core/widgets/caller_avatar.dart';
import 'local_camera_preview.dart';
import 'remote_video_view.dart';
import 'video_call_actions.dart';

class VideoCallView extends StatefulWidget {
  final CallConfig config;
  final ActiveCallInProgress state;
  final VoidCallback onBack;
  final VoidCallback onEndCall;

  const VideoCallView({
    super.key,
    required this.config,
    required this.state,
    required this.onBack,
    required this.onEndCall,
  });

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  static const _fade = Duration(milliseconds: 200);

  bool _controlsVisible = true;

  static const _topBarHeight = 96.0;
  static const _actionsHeight = 104.0;

  EdgeInsets _pipMargin(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    return EdgeInsets.fromLTRB(
      16,
      padding.top + _topBarHeight,
      16,
      padding.bottom + _actionsHeight,
    );
  }

  void _toggleControls() =>
      setState(() => _controlsVisible = !_controlsVisible);

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final media = state.media;
    final bloc = context.read<ActiveCallBloc>();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleControls,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (media != null)
            RemoteVideoView(
              viewId: media.remoteVideoViewId,
              aspectRatio: media.remoteVideoAspectRatio,
              quarterTurns: media.remoteVideoQuarterTurns,
              isPortrait: media.isRemoteVideoPortrait,
            )
          else
            _ConnectingVideo(config: widget.config),
          const _ScrimGradient(),
          SafeArea(
            child: Column(
              children: [
                AnimatedOpacity(
                  opacity: _controlsVisible ? 1 : 0,
                  duration: _fade,
                  child: CallTopBar(
                    callerName: widget.config.callerName,
                    subtitle: state.elapsed.toCallTimer(),
                    onBack: widget.onBack,
                  ),
                ),
                const Spacer(),
                AnimatedSlide(
                  offset: _controlsVisible ? Offset.zero : const Offset(0, 1.5),
                  duration: _fade,
                  child: VideoCallActions(
                    isCameraOn: state.isCameraOn,
                    isMuted: state.isMuted,
                    canControlCamera: state.canControlCamera,
                    onSwitchCamera: () =>
                        bloc.add(const ActiveCallCameraSwitched()),
                    onToggleVideo: () =>
                        bloc.add(const ActiveCallCameraToggled()),
                    onToggleMute: () => bloc.add(const ActiveCallMuteToggled()),
                    onEndCall: widget.onEndCall,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: DraggablePip(
              size: const Size(
                LocalCameraPreview.width,
                LocalCameraPreview.height,
              ),
              margin: _pipMargin(context),
              child: LocalCameraPreview(
                viewId: media?.cameraViewId,
                aspectRatio: media?.cameraAspectRatio ?? 4 / 3,
                isCameraOn: state.isCameraOn,
                isLoading: state.isMediaLoading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectingVideo extends StatelessWidget {
  final CallConfig config;

  const _ConnectingVideo({required this.config});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        BlurredAvatarBackground(avatarPath: config.callerAvatarPath),
        Center(
          child: CallerAvatar(
            callerName: config.callerName,
            avatarPath: config.callerAvatarPath,
            radius: 64,
          ),
        ),
      ],
    );
  }
}

class _ScrimGradient extends StatelessWidget {
  const _ScrimGradient();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 0.22, 0.7, 1],
            colors: [
              Color(0x8C000000),
              Color(0x00000000),
              Color(0x00000000),
              Color(0x8C000000),
            ],
          ),
        ),
      ),
    );
  }
}
