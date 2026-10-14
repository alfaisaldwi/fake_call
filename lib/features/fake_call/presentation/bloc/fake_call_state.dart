part of 'fake_call_bloc.dart';

sealed class FakeCallState extends Equatable {
  final CallConfig config;

  const FakeCallState(this.config);

  bool get isEditable =>
      this is FakeCallIdle || this is FakeCallFinished || this is FakeCallError;

  @override
  List<Object?> get props => [config];
}

final class FakeCallIdle extends FakeCallState {
  const FakeCallIdle(super.config);
}

final class FakeCallCountingDown extends FakeCallState {
  final int remainingSeconds;
  final int totalSeconds;

  const FakeCallCountingDown(
    super.config, {
    required this.remainingSeconds,
    required this.totalSeconds,
  });

  @override
  List<Object?> get props => [config, remainingSeconds, totalSeconds];
}

final class FakeCallWaitingRecall extends FakeCallState {
  final int nextAttempt;
  final int remainingSeconds;

  const FakeCallWaitingRecall(
    super.config, {
    required this.nextAttempt,
    required this.remainingSeconds,
  });

  @override
  List<Object?> get props => [config, nextAttempt, remainingSeconds];
}

final class FakeCallRinging extends FakeCallState {
  final int attempt;

  const FakeCallRinging(super.config, {required this.attempt});

  @override
  List<Object?> get props => [config, attempt];
}

final class FakeCallAccepted extends FakeCallState {
  final int attempt;

  const FakeCallAccepted(super.config, {required this.attempt});

  @override
  List<Object?> get props => [config, attempt];
}

final class FakeCallFinished extends FakeCallState {
  final CallEventType reason;

  const FakeCallFinished(super.config, {required this.reason});

  @override
  List<Object?> get props => [config, reason];
}

final class FakeCallError extends FakeCallState {
  final String message;
  final CallConfigField? invalidField;

  const FakeCallError(super.config, {required this.message, this.invalidField});

  @override
  List<Object?> get props => [config, message, invalidField];
}
