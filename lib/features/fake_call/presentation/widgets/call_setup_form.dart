import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/coach_mark.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/call_config.dart';
import '../../domain/entities/call_config_issue.dart';
import '../../domain/entities/caller_preset.dart';
import '../bloc/caller_suggestions_bloc.dart';
import '../bloc/fake_call_bloc.dart';
import 'call_preview_card.dart';
import 'call_type_selector.dart';
import 'caller_name_suggestions.dart';
import 'caller_preset_bar.dart';
import 'caller_video_picker.dart';
import 'home_coach_keys.dart';
import 'option_group.dart';
import 'recall_count_stepper.dart';
import 'schedule_bar.dart';
import 'seconds_option_selector.dart';
import 'section_card.dart';

class CallSetupForm extends StatefulWidget {
  final CallConfig config;
  final CallConfigField? invalidField;
  final HomeCoachKeys coachKeys;

  const CallSetupForm({
    super.key,
    required this.config,
    required this.coachKeys,
    this.invalidField,
  });

  @override
  State<CallSetupForm> createState() => _CallSetupFormState();
}

class _CallSetupFormState extends State<CallSetupForm> {
  static const _delayOptions = [0, 10, 30, 60, 300, 600, 1200, 1800];
  static const _hangupOptions = [0, 10, 15, 30, 60, 120];
  static const _recallIntervalOptions = [5, 10, 30, 60];
  static const _sectionGap = SizedBox(height: 12);

  late final _nameController = TextEditingController(
    text: widget.config.callerName,
  );
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(_onNameFocusChanged);
  }

  @override
  void didUpdateWidget(CallSetupForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    final name = widget.config.callerName;
    if (!_nameFocus.hasFocus && _nameController.text != name) {
      _nameController.value = TextEditingValue(
        text: name,
        selection: TextSelection.collapsed(offset: name.length),
      );
    }
  }

  @override
  void dispose() {
    _nameFocus.removeListener(_onNameFocusChanged);
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void _onNameFocusChanged() {
    if (_nameFocus.hasFocus) {
      context.read<CallerSuggestionsBloc>().add(
        const CallerSuggestionsRequested(),
      );
    }
    setState(() {});
  }

  void _applyPreset(CallerPreset preset) {
    _nameController.value = TextEditingValue(
      text: preset.name,
      selection: TextSelection.collapsed(offset: preset.name.length),
    );
    _update(preset.applyTo);
    _nameFocus.unfocus();
  }

  void _selectSuggestion(String name) {
    _nameController.value = TextEditingValue(
      text: name,
      selection: TextSelection.collapsed(offset: name.length),
    );
    _update((c) => c.copyWith(callerName: name));
    _nameFocus.unfocus();
  }

  FakeCallBloc get _bloc => context.read<FakeCallBloc>();

  HomeCoachKeys get _keys => widget.coachKeys;

  AppLocalizations get _l10n => AppLocalizations.of(context);

  void _update(CallConfig Function(CallConfig current) change) {
    _bloc.add(FakeCallConfigChanged(change(_bloc.state.config)));
  }

  Future<void> _showInvalidConfig(BuildContext context, FakeCallState state) {
    if (state is! FakeCallError) return Future.value();
    return showAppDialog(
      context: context,
      icon: Icons.edit_note_rounded,
      tone: DialogTone.warning,
      title: _l10n.invalidConfigTitle,
      message: state.message,
      confirmLabel: _l10n.ok,
    ).then((_) {
      if (mounted && state.invalidField == CallConfigField.callerName) {
        _nameFocus.requestFocus();
      }
    });
  }

  String _summary(CallConfig config) {
    final l10n = _l10n;
    final parts = [
      config.isVideoCall ? l10n.summaryVideoCall : l10n.summaryVoiceCall,
      config.delayInSeconds == 0
          ? l10n.summaryRingsNow
          : l10n.summaryRingsIn(
              SecondsOptionSelector.label(l10n, config.delayInSeconds),
            ),
      if (config.autoRecallCount > 0)
        l10n.summaryRedial(config.autoRecallCount),
    ];
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    return BlocListener<FakeCallBloc, FakeCallState>(
      listenWhen: (_, current) =>
          current is FakeCallError && current.invalidField != null,
      listener: _showInvalidConfig,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                CoachMark(
                  showcaseKey: _keys.preview,
                  title: _l10n.coachPreviewTitle,
                  description: _l10n.coachPreviewBody,
                  radius: 24,
                  child: CallPreviewCard(
                    callerName: config.callerName,
                    avatarPath: config.callerAvatarPath,
                    isVideoCall: config.isVideoCall,
                    onPickPhoto: () =>
                        _bloc.add(const FakeCallAvatarPickRequested()),
                    onRemovePhoto: () =>
                        _bloc.add(const FakeCallAvatarRemoved()),
                  ),
                ),
                _sectionGap,
                CoachMark(
                  showcaseKey: _keys.presets,
                  title: _l10n.coachPresetsTitle,
                  description: _l10n.coachPresetsBody,
                  radius: 16,
                  padding: const EdgeInsets.all(8),
                  child: CallerPresetBar(config: config, onApply: _applyPreset),
                ),
                _sectionGap,
                _buildCallerCard(config),
                _sectionGap,
                CoachMark(
                  showcaseKey: _keys.timing,
                  title: _l10n.coachTimingTitle,
                  description: _l10n.coachTimingBody,
                  child: _buildTimingCard(config),
                ),
                _sectionGap,
                _buildRecallCard(config),
              ],
            ),
          ),
          CoachMark(
            showcaseKey: _keys.schedule,
            title: _l10n.coachScheduleTitle,
            description: _l10n.coachScheduleBody,
            radius: 16,
            padding: EdgeInsets.zero,
            child: ScheduleBar(
              summary: _summary(config),
              onSchedule: () => _bloc.add(const FakeCallScheduleRequested()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallerCard(CallConfig config) {
    return SectionCard(
      icon: Icons.person,
      title: _l10n.callerSectionTitle,
      subtitle: _l10n.callerSectionSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoachMark(
            showcaseKey: _keys.name,
            title: _l10n.coachNameTitle,
            description: _l10n.coachNameBody,
            radius: 16,
            padding: const EdgeInsets.all(8),
            child: OptionGroup(
              title: _l10n.callerNameLabel,
              child: TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: _l10n.callerNameHint,
                  prefixIcon: const Icon(Icons.badge_outlined),
                  errorText: widget.invalidField == CallConfigField.callerName
                      ? _l10n.callerNameRequiredShort
                      : null,
                ),
                onChanged: (name) =>
                    _update((c) => c.copyWith(callerName: name)),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            alignment: Alignment.topCenter,
            child: _buildNameSuggestions(config),
          ),
          const SizedBox(height: 20),
          CoachMark(
            showcaseKey: _keys.callType,
            title: _l10n.coachTypeTitle,
            description: _l10n.coachTypeBody,
            radius: 16,
            padding: const EdgeInsets.all(8),
            child: OptionGroup(
              title: _l10n.callTypeLabel,
              child: CallTypeSelector(
                selected: config.callType,
                onChanged: (type) => _update((c) => c.copyWith(callType: type)),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: config.isVideoCall
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: OptionGroup(
                      title: _l10n.callerVideoLabel,
                      description: _l10n.callerVideoDescription,
                      child: CallerVideoPicker(
                        videoPath: config.callerVideoPath,
                        onPick: () =>
                            _bloc.add(const FakeCallVideoPickRequested()),
                        onUseDefault: () =>
                            _bloc.add(const FakeCallVideoRemoved()),
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _buildNameSuggestions(CallConfig config) {
    if (!_nameFocus.hasFocus) return const SizedBox(width: double.infinity);
    return BlocBuilder<CallerSuggestionsBloc, CallerSuggestionsState>(
      builder: (context, state) {
        final names = state.history.suggestionsFor(config.callerName);
        if (names.isEmpty) return const SizedBox(width: double.infinity);
        return CallerNameSuggestions(
          names: names,
          onSelected: _selectSuggestion,
          onRemoved: (name) => context.read<CallerSuggestionsBloc>().add(
            CallerSuggestionRemoved(name),
          ),
        );
      },
    );
  }

  Widget _buildTimingCard(CallConfig config) {
    return SectionCard(
      icon: Icons.timer_outlined,
      title: _l10n.timingSectionTitle,
      subtitle: _l10n.timingSectionSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OptionGroup(
            title: _l10n.ringAfterLabel,
            child: SecondsOptionSelector(
              options: _delayOptions,
              selected: config.delayInSeconds,
              onChanged: (s) => _update((c) => c.copyWith(delayInSeconds: s)),
            ),
          ),
          const Divider(),
          OptionGroup(
            title: _l10n.autoHangupLabel,
            description: _l10n.autoHangupDescription,
            child: SecondsOptionSelector(
              options: _hangupOptions,
              selected: config.autoHangupSeconds,
              zeroLabel: _l10n.optionOff,
              onChanged: (s) =>
                  _update((c) => c.copyWith(autoHangupSeconds: s)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecallCard(CallConfig config) {
    return SectionCard(
      icon: Icons.replay,
      title: _l10n.recallSectionTitle,
      subtitle: _l10n.recallSectionSubtitle,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecallCountStepper(
              count: config.autoRecallCount,
              max: CallConfig.maxRecallCount,
              onChanged: (n) => _update((c) => c.copyWith(autoRecallCount: n)),
            ),
            if (config.autoRecallCount > 0) ...[
              const SizedBox(height: 20),
              OptionGroup(
                title: _l10n.recallIntervalLabel,
                child: SecondsOptionSelector(
                  options: _recallIntervalOptions,
                  selected: config.autoRecallInterval,
                  onChanged: (s) =>
                      _update((c) => c.copyWith(autoRecallInterval: s)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
