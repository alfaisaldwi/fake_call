part of 'theme_mode_bloc.dart';

sealed class ThemeModeState extends Equatable {
  final AppThemeMode mode;

  const ThemeModeState(this.mode);

  ThemeMode get themeMode => switch (mode) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };

  @override
  List<Object> get props => [mode];
}

final class ThemeModeReady extends ThemeModeState {
  const ThemeModeReady(super.mode);
}

final class ThemeModeError extends ThemeModeState {
  final String message;

  const ThemeModeError(super.mode, {required this.message});

  @override
  List<Object> get props => [mode, message];
}
