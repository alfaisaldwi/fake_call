import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/widgets/language_menu_button.dart';
import '../bloc/fake_call_bloc.dart';
import '../widgets/call_progress_view.dart';
import '../widgets/call_setup_form.dart';

class CallSetupPage extends StatelessWidget {
  const CallSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocSelector<FakeCallBloc, FakeCallState, bool>(
      selector: (state) => state.isEditable,
      builder: (context, isEditable) => PopScope(
        canPop: isEditable,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.backBlockedHint)));
        },
        child: _buildScaffold(context, l10n),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [LanguageMenuButton()],
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
              invalidField: invalidField,
            ),
            _ => CallSetupForm(config: config),
          };
        },
      ),
    );
  }
}
