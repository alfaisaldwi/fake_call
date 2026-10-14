import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';

import 'package:showcaseview/showcaseview.dart';

import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/coach_mark.dart';
import '../../../../core/widgets/top_toast.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../onboarding/presentation/bloc/coach_marks_bloc.dart';
import '../bloc/fake_call_bloc.dart';
import '../widgets/call_progress_view.dart';
import '../widgets/call_setup_form.dart';
import '../widgets/home_coach_keys.dart';

class CallSetupPage extends StatefulWidget {
  const CallSetupPage({super.key});

  @override
  State<CallSetupPage> createState() => _CallSetupPageState();
}

class _CallSetupPageState extends State<CallSetupPage> {
  static const _scope = 'home';
  static const _startDelay = Duration(milliseconds: 450);

  final _coachKeys = HomeCoachKeys();
  late final ShowcaseView _showcase = ShowcaseView.register(
    scope: _scope,
    enableAutoScroll: true,
    disableScaleAnimation: true,
    onFinish: _onTourEnded,
    onDismiss: (_) => _onTourEnded(),
  );
  int _startedRun = 0;

  @override
  void initState() {
    super.initState();
    _showcase;
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartTour());
  }

  @override
  void dispose() {
    _showcase.unregister();
    super.dispose();
  }

  void _onTourEnded() {
    if (!mounted) return;
    context.read<CoachMarksBloc>().add(const CoachMarksCompleted());
  }

  void _maybeStartTour() {
    if (!mounted) return;
    final coach = context.read<CoachMarksBloc>().state;
    final editable = context.read<FakeCallBloc>().state.isEditable;
    if (coach is! CoachMarksVisible || !editable) return;
    if (coach.run == _startedRun) return;
    _startedRun = coach.run;
    _showcase.startShowCase(_coachKeys.ordered, delay: _startDelay);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    _showcase.globalTooltipActions = coachMarkActions(
      context,
      skip: l10n.coachSkip,
      next: l10n.coachNext,
    );
    return BlocListener<CoachMarksBloc, CoachMarksState>(
      listenWhen: (_, current) => current is CoachMarksVisible,
      listener: (_, _) => WidgetsBinding.instance.addPostFrameCallback(
        (_) => _maybeStartTour(),
      ),
      child: BlocSelector<FakeCallBloc, FakeCallState, bool>(
        selector: (state) => state.isEditable,
        builder: (context, isEditable) => PopScope(
          canPop: isEditable,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            TopToast.show(context, l10n.backBlockedHint);
          },
          child: _buildScaffold(context, l10n),
        ),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      appBar: AppTopBar(
        title: l10n.homeTitle,
        subtitle: l10n.homeSubtitle,
        leading: const TopBarLogo(
          asset: 'assets/img/launcher/launcher_icon.png',
        ),
        actions: [
          CoachMark(
            showcaseKey: _coachKeys.settings,
            title: l10n.coachSettingsTitle,
            description: l10n.coachSettingsBody,
            radius: 24,
            actions: [
              TooltipActionButton(
                type: TooltipDefaultActionType.next,
                name: l10n.coachDone,
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            child: TopBarButton(
              icon: Icons.settings_outlined,
              tooltip: l10n.settingsTooltip,
              onPressed: AppRouter.openSettings,
            ),
          ),
        ],
      ),
      body: BlocBuilder<FakeCallBloc, FakeCallState>(
        builder: (context, state) {
          void cancel() =>
              context.read<FakeCallBloc>().add(const FakeCallEndRequested());
          final config = state.config;
          final attemptLabel = config.autoRecallCount > 0;
          return switch (state) {
            FakeCallCountingDown(:final remainingSeconds) => CallProgressView(
              config: config,
              remainingSeconds: remainingSeconds,
              totalSeconds: config.delayInSeconds,
              title: l10n.progressWillCall(config.callerName),
              subtitle: l10n.progressLockScreenHint,
              onCancel: cancel,
            ),
            FakeCallWaitingRecall(
              :final nextAttempt,
              :final remainingSeconds,
            ) =>
              CallProgressView(
                config: config,
                remainingSeconds: remainingSeconds,
                totalSeconds: config.autoRecallInterval,
                title: l10n.progressRedialIn(remainingSeconds),
                subtitle: l10n.progressAttempt(
                  nextAttempt,
                  config.totalAttempts,
                ),
                onCancel: cancel,
              ),
            FakeCallRinging(:final attempt) => CallProgressView(
              config: config,
              title: l10n.progressRinging,
              subtitle: attemptLabel
                  ? l10n.progressAttempt(attempt, config.totalAttempts)
                  : l10n.progressAnswerHint,
              onCancel: cancel,
            ),
            FakeCallAccepted() => CallProgressView(
              config: config,
              title: l10n.progressInCall,
              subtitle: l10n.progressOpeningCall,
              onCancel: cancel,
            ),
            FakeCallError(:final invalidField) => CallSetupForm(
              config: config,
              coachKeys: _coachKeys,
              invalidField: invalidField,
            ),
            _ => CallSetupForm(config: config, coachKeys: _coachKeys),
          };
        },
      ),
    );
  }
}
