part of 'fake_call_bloc.dart';

sealed class FakeCallEvent extends Equatable {
  const FakeCallEvent();

  @override
  List<Object?> get props => [];
}

final class FakeCallStarted extends FakeCallEvent {
  const FakeCallStarted();
}

final class FakeCallConfigChanged extends FakeCallEvent {
  final CallConfig config;

  const FakeCallConfigChanged(this.config);

  @override
  List<Object?> get props => [config];
}

final class FakeCallAvatarPickRequested extends FakeCallEvent {
  const FakeCallAvatarPickRequested();
}

final class FakeCallAvatarRemoved extends FakeCallEvent {
  const FakeCallAvatarRemoved();
}

final class FakeCallVideoPickRequested extends FakeCallEvent {
  const FakeCallVideoPickRequested();
}

final class FakeCallVideoRemoved extends FakeCallEvent {
  const FakeCallVideoRemoved();
}

final class FakeCallScheduleRequested extends FakeCallEvent {
  const FakeCallScheduleRequested();
}

final class FakeCallEndRequested extends FakeCallEvent {
  const FakeCallEndRequested();
}

final class FakeCallAppResumed extends FakeCallEvent {
  const FakeCallAppResumed();
}

final class FakeCallReset extends FakeCallEvent {
  const FakeCallReset();
}

final class _CountdownTicked extends FakeCallEvent {
  final int remainingSeconds;

  const _CountdownTicked(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}
