import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/l10n/app_locale_holder.dart';
import 'core/l10n/locale_sync.dart';
import 'core/theme/app_appearance_holder.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_foreground_listener.dart';
import 'features/fake_call/presentation/bloc/caller_presets_bloc.dart';
import 'features/fake_call/presentation/bloc/caller_suggestions_bloc.dart';
import 'features/fake_call/presentation/bloc/fake_call_bloc.dart';
import 'features/fake_call/presentation/widgets/fake_call_listener.dart';
import 'features/onboarding/presentation/bloc/coach_marks_bloc.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/settings/presentation/bloc/app_update_bloc.dart';
import 'features/settings/presentation/bloc/language_bloc.dart';
import 'features/settings/presentation/bloc/theme_mode_bloc.dart';
import 'injection_container.dart';
import 'l10n/app_localizations.dart';

class FakeWaCallApp extends StatelessWidget {
  const FakeWaCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeModeBloc>(
          create: (_) => sl<ThemeModeBloc>()..add(const ThemeModeStarted()),
        ),
        BlocProvider<LanguageBloc>(
          create: (_) => sl<LanguageBloc>()..add(const LanguageStarted()),
        ),
        BlocProvider<OnboardingBloc>(
          create: (_) =>
              sl<OnboardingBloc>()..add(const OnboardingStatusRequested()),
        ),
        BlocProvider<CoachMarksBloc>(
          create: (_) => sl<CoachMarksBloc>()..add(const CoachMarksRequested()),
        ),
        BlocProvider<CallerPresetsBloc>(
          create: (_) =>
              sl<CallerPresetsBloc>()..add(const CallerPresetsRequested()),
        ),
        BlocProvider<CallerSuggestionsBloc>(
          create: (_) =>
              sl<CallerSuggestionsBloc>()
                ..add(const CallerSuggestionsRequested()),
        ),
        BlocProvider<AppUpdateBloc>(
          create: (_) =>
              sl<AppUpdateBloc>()
                ..add(const AppUpdateCheckRequested(silent: true)),
        ),
        BlocProvider<FakeCallBloc>(
          create: (_) => sl<FakeCallBloc>()
            ..add(const FakeCallStarted())
            ..add(const FakeCallRestoreRequested())
            ..add(const FakeCallQuickTriggersStarted()),
        ),
      ],
      child: BlocBuilder<ThemeModeBloc, ThemeModeState>(
        builder: (context, themeState) =>
            BlocBuilder<LanguageBloc, LanguageState>(
              buildWhen: (previous, current) =>
                  previous.locale != current.locale,
              builder: (context, languageState) => MaterialApp.router(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context).appTitle,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeState.themeMode,
                locale: languageState.locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, _) =>
                    AppLocaleHolder.resolve(locale),
                routerConfig: AppRouter.router,
                builder: (context, child) => AppearanceSync(
                  holder: sl<AppAppearanceHolder>(),
                  child: LocaleSync(
                    holder: sl<AppLocaleHolder>(),
                    child: AppForegroundListener(
                      onChanged: (context, isForeground) {
                        if (isForeground) {
                          context.read<FakeCallBloc>().add(
                            const FakeCallAppResumed(),
                          );
                        }
                      },
                      child: FakeCallListener(
                        child: child ?? const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
