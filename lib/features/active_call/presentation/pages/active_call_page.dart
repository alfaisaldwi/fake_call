import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../fake_call/domain/entities/call_config.dart';
import '../../../fake_call/presentation/bloc/fake_call_bloc.dart';
import '../bloc/active_call_bloc.dart';
import '../../../../core/widgets/app_foreground_listener.dart';
import '../../../../core/widgets/tap_guard.dart';
import '../widgets/video_call_view.dart';
import '../widgets/voice_call_view.dart';

class ActiveCallPage extends StatelessWidget {
  final CallConfig config;

  const ActiveCallPage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ActiveCallBloc>()
        ..add(
          ActiveCallStarted(config.callType, videoPath: config.callerVideoPath),
        ),
      child: AppForegroundListener(
        onChanged: (context, isForeground) => context
            .read<ActiveCallBloc>()
            .add(ActiveCallForegroundChanged(isForeground)),
        child: _ActiveCallView(config: config),
      ),
    );
  }
}

class _ActiveCallView extends StatelessWidget {
  final CallConfig config;

  const _ActiveCallView({required this.config});

  void _endCall(BuildContext context) {
    context.read<ActiveCallBloc>().add(const ActiveCallStopped());
    context.read<FakeCallBloc>().add(const FakeCallEndRequested());
  }

  void _showError(BuildContext context, ActiveCallState state) {
    if (state is! ActiveCallError) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(state.message)));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _endCall(context);
        },
        child: Scaffold(
          backgroundColor: AppColors.callBackground,
          body: TapGuard(
            child: BlocConsumer<ActiveCallBloc, ActiveCallState>(
              listenWhen: (_, current) => current is ActiveCallError,
              listener: _showError,
              buildWhen: (_, current) => current is! ActiveCallError,
              builder: (context, state) {
                if (state is! ActiveCallInProgress) {
                  return const SizedBox.expand();
                }
                return state.isVideoMode
                    ? VideoCallView(
                        config: config,
                        state: state,
                        onBack: () => _endCall(context),
                        onEndCall: () => _endCall(context),
                      )
                    : VoiceCallView(
                        config: config,
                        state: state,
                        onBack: () => _endCall(context),
                        onEndCall: () => _endCall(context),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
