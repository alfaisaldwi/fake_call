part of 'call_preferences_bloc.dart';

sealed class CallPreferencesState extends Equatable {
  final CallPreferences preferences;

  const CallPreferencesState(this.preferences);

  @override
  List<Object> get props => [preferences];
}

final class CallPreferencesReady extends CallPreferencesState {
  const CallPreferencesReady(super.preferences);
}

final class CallPreferencesError extends CallPreferencesState {
  final String message;

  const CallPreferencesError(super.preferences, {required this.message});

  @override
  List<Object> get props => [preferences, message];
}
