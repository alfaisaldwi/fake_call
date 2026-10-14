part of 'theme_mode_bloc.dart';

sealed class ThemeModeEvent extends Equatable {
  const ThemeModeEvent();

  @override
  List<Object> get props => [];
}

final class ThemeModeStarted extends ThemeModeEvent {
  const ThemeModeStarted();
}

final class ThemeModeSelected extends ThemeModeEvent {
  final AppThemeMode mode;

  const ThemeModeSelected(this.mode);

  @override
  List<Object> get props => [mode];
}
