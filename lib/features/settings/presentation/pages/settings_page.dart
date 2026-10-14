import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../onboarding/presentation/bloc/coach_marks_bloc.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../bloc/app_info_bloc.dart';
import '../bloc/language_bloc.dart';
import '../bloc/theme_mode_bloc.dart';
import '../widgets/choice_sheet.dart';
import '../widgets/made_by_footer.dart';
import '../widgets/settings_group.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppInfoBloc>()..add(const AppInfoRequested()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  static const _themeColor = Color(0xFF6366F1);
  static const _languageColor = Color(0xFF0EA5E9);
  static const _privacyColor = Color(0xFF16A34A);
  static const _kindColor = Color(0xFFEC4899);
  static const _licenseColor = Color(0xFFF59E0B);
  static const _tourColor = Color(0xFF14B8A6);

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
    return Scaffold(
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
          const SettingsHeader(),
          const SizedBox(height: 32),
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
            ],
          ),
          const SizedBox(height: 24),
          SettingsGroup(
            title: l10n.settingsAbout,
            children: [
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
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: l10n.appTitle,
                  applicationIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/img/launcher/launcher_icon.png',
                        width: 64,
                        height: 64,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const MadeByFooter(),
        ],
      ),
    );
  }
}
