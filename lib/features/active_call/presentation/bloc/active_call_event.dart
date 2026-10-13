part of 'active_call_bloc.dart';

sealed class ActiveCallEvent extends Equatable {
  const ActiveCallEvent();

  @override
  List<Object> get props => [];
}

final class ActiveCallStarted extends ActiveCallEvent {
  final CallType callType;
  final String? videoPath;

  const ActiveCallStarted(this.callType, {this.videoPath});

  @override
  List<Object> get props => [callType, videoPath ?? ''];
}

final class ActiveCallForegroundChanged extends ActiveCallEvent {
  final bool isForeground;

  const ActiveCallForegroundChanged(this.isForeground);

  @override
  List<Object> get props => [isForeground];
}

final class ActiveCallVideoRequested extends ActiveCallEvent {
  const ActiveCallVideoRequested();
}

final class ActiveCallCameraToggled extends ActiveCallEvent {
  const ActiveCallCameraToggled();
}

final class ActiveCallCameraSwitched extends ActiveCallEvent {
  const ActiveCallCameraSwitched();
}

final class ActiveCallMuteToggled extends ActiveCallEvent {
  const ActiveCallMuteToggled();
}

final class ActiveCallSpeakerToggled extends ActiveCallEvent {
  const ActiveCallSpeakerToggled();
}

final class ActiveCallStopped extends ActiveCallEvent {
  const ActiveCallStopped();
}

final class _ElapsedTicked extends ActiveCallEvent {
  final Duration elapsed;

  const _ElapsedTicked(this.elapsed);

  @override
  List<Object> get props => [elapsed];
}
