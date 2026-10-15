part of 'call_preferences_bloc.dart';

sealed class CallPreferencesEvent extends Equatable {
  const CallPreferencesEvent();

  @override
  List<Object> get props => [];
}

final class CallPreferencesStarted extends CallPreferencesEvent {
  const CallPreferencesStarted();
}

final class RingtoneSelected extends CallPreferencesEvent {
  final CallRingtone ringtone;

  const RingtoneSelected(this.ringtone);

  @override
  List<Object> get props => [ringtone];
}

final class InitialDurationSelected extends CallPreferencesEvent {
  final int seconds;

  const InitialDurationSelected(this.seconds);

  @override
  List<Object> get props => [seconds];
}

final class RingVibrationChanged extends CallPreferencesEvent {
  final bool vibrate;

  const RingVibrationChanged(this.vibrate);

  @override
  List<Object> get props => [vibrate];
}
