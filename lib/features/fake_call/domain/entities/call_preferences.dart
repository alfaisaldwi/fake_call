import 'package:equatable/equatable.dart';

enum CallRingtone { app, system, silent }

class CallPreferences extends Equatable {
  final CallRingtone ringtone;
  final bool vibrate;
  final int initialDurationSeconds;

  const CallPreferences({
    this.ringtone = CallRingtone.app,
    this.vibrate = true,
    this.initialDurationSeconds = 0,
  });

  Duration get initialDuration => Duration(seconds: initialDurationSeconds);

  CallPreferences copyWith({
    CallRingtone? ringtone,
    bool? vibrate,
    int? initialDurationSeconds,
  }) {
    return CallPreferences(
      ringtone: ringtone ?? this.ringtone,
      vibrate: vibrate ?? this.vibrate,
      initialDurationSeconds:
          initialDurationSeconds ?? this.initialDurationSeconds,
    );
  }

  @override
  List<Object> get props => [ringtone, vibrate, initialDurationSeconds];
}
