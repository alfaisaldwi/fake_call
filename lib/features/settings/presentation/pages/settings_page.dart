import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/top_toast.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../fake_call/domain/entities/call_preferences.dart';
import '../../../fake_call/presentation/bloc/call_preferences_bloc.dart';
import '../../../fake_call/presentation/widgets/seconds_option_selector.dart';
import '../../../onboarding/presentation/bloc/coach_marks_bloc.dart';
import '../../../permissions/presentation/widgets/permission_sheet.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/entities/app_update.dart';
import '../bloc/app_info_bloc.dart';
import '../bloc/app_update_bloc.dart';
import '../bloc/language_bloc.dart';
import '../bloc/theme_mode_bloc.dart';
import '../widgets/choice_sheet.dart';
import '../widgets/made_by_footer.dart';
import '../widgets/settings_group.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AppInfoBloc>()..add(const AppInfoRequested()),
        ),
        BlocProvider(
          create: (_) =>
              sl<CallPreferencesBloc>()..add(const CallPreferencesStarted()),
        ),
      ],
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  static const _themeColor = Color(0xFF6366F1);
  static const _languageColor = Color(0xFF0EA5E9);
  static const _ringtoneColor = Color(0xFFF97316);
  static const _vibrateColor = Color(0xFF3B82F6);
  static const _timerColor = Color(0xFFF43F5E);
  static const _initialDurationOptions = [0, 60, 300, 900];
  static const _privacyColor = Color(0xFF16A34A);
  static const _kindColor = Color(0xFFEC4899);
  static const _licenseColor = Color(0xFFF59E0B);
  static const _tourColor = Color(0xFF14B8A6);
  static const _updateColor = Color(0xFF2563EB);
  static const _permissionColor = Color(0xFF8B5CF6);

  const _SettingsView();

  static IconData _themeIcon(AppThemeMode mode) => switch (mode) {
    AppThemeMode.system => Icons.brightness_auto,
    AppThemeMode.light => Icons.light_mode,
    AppThemeMode.dark => Icons.dark_mode,
  };

  static String _themeLabel(AppLocalizations l10n, AppThemeMode mode) =>
      switch (mode) {
        AppThemeMode.system => l10n.themeSystem,
        AppThemeMode.light => l10n.themeLight,
        AppThemeMode.dark => l10n.themeDark,
      };

  static String _ringtoneLabel(AppLocalizations l10n, CallRingtone ringtone) =>
      switch (ringtone) {
        CallRingtone.app => l10n.ringtoneApp,
        CallRingtone.system => l10n.ringtoneSystem,
        CallRingtone.silent => l10n.ringtoneSilent,
      };

  static IconData _ringtoneIcon(CallRingtone ringtone) => switch (ringtone) {
    CallRingtone.app => Icons.music_note,
    CallRingtone.system => Icons.phone_android,
    CallRingtone.silent => Icons.volume_off,
  };

  static String? _updateLabel(AppLocalizations l10n, AppUpdateState state) {
    if (state.isAvailable) return l10n.updateAvailable;
    if (state.availability == AppUpdateAvailability.upToDate) {
      return l10n.updateLatest;
    }
    return null;
  }

  static (String, String) _language(AppLocalizations l10n, AppLanguage lang) =>
      switch (lang) {
        AppLanguage.system => ('🌐', l10n.languageSystem),
        AppLanguage.indonesian => ('🇮🇩', l10n.languageIndonesian),
        AppLanguage.english => ('🇬🇧', l10n.languageEnglish),
      };

  Future<void> _pickTheme(BuildContext context, AppThemeMode current) async {
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<ThemeModeBloc>();
    final picked = await showChoiceSheet(
      context: context,
      title: l10n.settingsTheme,
      selected: current,
      options: [
        for (final mode in AppThemeMode.values)
          ChoiceOption(
            value: mode,
            label: _themeLabel(l10n, mode),
            leading: Icon(
              _themeIcon(mode),
              size: 20,
              color: context.palette.textSecondary,
            ),
          ),
      ],
    );
    if (picked != null) bloc.add(ThemeModeSelected(picked));
  }

  Future<void> _pickRingtone(BuildContext context, CallRingtone current) async {
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<CallPreferencesBloc>();
    final picked = await showChoiceSheet(
      context: context,
      title: l10n.ringtoneLabel,
      selected: current,
      options: [
        for (final ringtone in CallRingtone.values)
          ChoiceOption(
            value: ringtone,
            label: _ringtoneLabel(l10n, ringtone),
            leading: Icon(
              _ringtoneIcon(ringtone),
              size: 20,
              color: context.palette.textSecondary,
            ),
          ),
      ],
    );
    if (picked != null) bloc.add(RingtoneSelected(picked));
  }

  Future<void> _pickInitialDuration(BuildContext context, int current) async {
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<CallPreferencesBloc>();
    final picked = await showChoiceSheet(
      context: context,
      title: l10n.initialDurationLabel,
      selected: current,
      options: [
        for (final seconds in _initialDurationOptions)
          ChoiceOption(
            value: seconds,
            label: _initialDurationText(l10n, seconds),
            leading: Icon(
              Icons.timer_outlined,
              size: 20,
              color: context.palette.textSecondary,
            ),
          ),
      ],
    );
    if (picked != null) bloc.add(InitialDurationSelected(picked));
  }

  static String _initialDurationText(AppLocalizations l10n, int seconds) =>
      SecondsOptionSelector.label(
        l10n,
        seconds,
        zeroLabel: l10n.initialDurationZero,
      );

  Future<void> _pickLanguage(BuildContext context, AppLanguage current) async {
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<LanguageBloc>();
    final picked = await showChoiceSheet(
      context: context,
      title: l10n.settingsLanguage,
      selected: current,
      options: [
        for (final lang in AppLanguage.values)
          ChoiceOption(
            value: lang,
            label: _language(l10n, lang).$2,
            leading: Text(
              _language(l10n, lang).$1,
              style: const TextStyle(fontSize: 18),
            ),
          ),
      ],
    );
    if (picked != null) bloc.add(LanguageSelected(picked));
  }

  void _showInfo(BuildContext context, String title, String body) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(sheetContext).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: sheetContext.palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final theme = context.watch<ThemeModeBloc>().state.mode;
    final language = context.watch<LanguageBloc>().state.language;
    final ring = context.watch<CallPreferencesBloc>().state.preferences;
    final update = context.watch<AppUpdateBloc>().state;
    return MultiBlocListener(
      listeners: [
        BlocListener<CallPreferencesBloc, CallPreferencesState>(
          listenWhen: (_, current) => current is CallPreferencesError,
          listener: (context, state) {
            if (state is CallPreferencesError) {
              TopToast.show(context, state.message, type: ToastType.error);
            }
          },
        ),
        BlocListener<AppUpdateBloc, AppUpdateState>(
          listenWhen: (previous, current) =>
              current.message != null || current.isUpToDateNotice,
          listener: (context, state) {
            final message = state.message;
            if (message != null) {
              TopToast.show(context, message, type: ToastType.error);
            } else {
              TopToast.show(
                context,
                l10n.updateUpToDate,
                type: ToastType.success,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: palette.background,
        appBar: AppTopBar(
          title: l10n.settingsTitle,
          leading: TopBarButton(
            icon: Icons.arrow_back,
            tooltip: l10n.back,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            const SizedBox(height: 8),
            SettingsGroup(
              title: l10n.settingsPreferences,
              children: [
                SettingsTile(
                  icon: _themeIcon(theme),
                  color: _themeColor,
                  title: l10n.settingsTheme,
                  value: _themeLabel(l10n, theme),
                  onTap: () => _pickTheme(context, theme),
                ),
                SettingsTile(
                  icon: Icons.translate,
                  color: _languageColor,
                  title: l10n.settingsLanguage,
                  value: _language(l10n, language).$2,
                  onTap: () => _pickLanguage(context, language),
                ),
                SettingsTile(
                  icon: Icons.verified_user_outlined,
                  color: _permissionColor,
                  title: l10n.settingsPermissions,
                  onTap: () => showPermissionSheet(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SettingsGroup(
              title: l10n.settingsCalls,
              children: [
                SettingsTile(
                  icon: _ringtoneIcon(ring.ringtone),
                  color: _ringtoneColor,
                  title: l10n.ringtoneLabel,
                  value: _ringtoneLabel(l10n, ring.ringtone),
                  onTap: () => _pickRingtone(context, ring.ringtone),
                ),
                SettingsTile(
                  icon: Icons.vibration,
                  color: _vibrateColor,
                  title: l10n.vibrateLabel,
                  trailing: Switch(
                    value: ring.vibrate,
                    onChanged: (vibrate) => context
                        .read<CallPreferencesBloc>()
                        .add(RingVibrationChanged(vibrate)),
                  ),
                  onTap: () => context.read<CallPreferencesBloc>().add(
                    RingVibrationChanged(!ring.vibrate),
                  ),
                ),
                SettingsTile(
                  icon: Icons.timer_outlined,
                  color: _timerColor,
                  title: l10n.initialDurationLabel,
                  value: _initialDurationText(
                    l10n,
                    ring.initialDurationSeconds,
                  ),
                  onTap: () => _pickInitialDuration(
                    context,
                    ring.initialDurationSeconds,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SettingsGroup(
              title: l10n.settingsAbout,
              children: [
                if (update.isSupported)
                  SettingsTile(
                    icon: Icons.system_update_outlined,
                    color: _updateColor,
                    title: l10n.updateCheck,
                    value: _updateLabel(l10n, update),
                    trailing: update.isBusy
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                    onTap: update.isBusy
                        ? null
                        : () => context.read<AppUpdateBloc>().add(
                            update.isAvailable
                                ? const AppUpdateStartRequested()
                                : const AppUpdateCheckRequested(),
                          ),
                  ),
                SettingsTile(
                  icon: Icons.tips_and_updates_outlined,
                  color: _tourColor,
                  title: l10n.settingsReplayTour,
                  onTap: () {
                    final coach = context.read<CoachMarksBloc>();
                    Navigator.of(context).maybePop();
                    coach.add(const CoachMarksReplayRequested());
                  },
                ),
                SettingsTile(
                  icon: Icons.shield_outlined,
                  color: _privacyColor,
                  title: l10n.aboutPrivacyTitle,
                  onTap: () => _showInfo(
                    context,
                    l10n.aboutPrivacyTitle,
                    l10n.aboutPrivacyBody,
                  ),
                ),
                SettingsTile(
                  icon: Icons.favorite_outline,
                  color: _kindColor,
                  title: l10n.aboutUseTitle,
                  onTap: () =>
                      _showInfo(context, l10n.aboutUseTitle, l10n.aboutUseBody),
                ),
                SettingsTile(
                  icon: Icons.description_outlined,
                  color: _licenseColor,
                  title: l10n.aboutLicenses,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => Theme(
                        data: AppTopBar.themed(context),
                        child: LicensePage(applicationName: l10n.appTitle),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const MadeByFooter(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
