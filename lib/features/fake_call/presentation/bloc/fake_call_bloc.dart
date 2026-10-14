import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/failure_messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/call_config.dart';
import '../../domain/entities/call_config_issue.dart';
import '../../domain/entities/call_event.dart';
import '../../domain/usecases/end_fake_call.dart';
import '../../domain/usecases/listen_to_call_events.dart';
import '../../domain/usecases/pick_caller_avatar.dart';
import '../../domain/usecases/pick_caller_video.dart';
import '../../domain/usecases/remember_caller_name.dart';
import '../../domain/usecases/get_last_call_config.dart';
import '../../domain/usecases/listen_to_quick_triggers.dart';
import '../../domain/usecases/save_last_call_config.dart';
import '../../domain/usecases/schedule_fake_call.dart';
import '../../domain/usecases/sync_active_call.dart';

part 'fake_call_event.dart';
part 'fake_call_state.dart';

class FakeCallBloc extends Bloc<FakeCallEvent, FakeCallState> {
  static const defaultConfig = CallConfig(delayInSeconds: 10, callerName: '');

  final ScheduleFakeCall scheduleFakeCall;
  final ListenToCallEvents listenToCallEvents;
  final EndFakeCall endFakeCall;
  final PickCallerAvatar pickCallerAvatar;
  final PickCallerVideo pickCallerVideo;
  final RememberCallerName rememberCallerName;
  final SyncActiveCall syncActiveCall;
  final GetLastCallConfig getLastCallConfig;
  final SaveLastCallConfig saveLastCallConfig;
  final ListenToQuickTriggers listenToQuickTriggers;
  final FailureMessages failureMessages;

  StreamSubscription<int>? _ticker;

  FakeCallBloc({
    required this.scheduleFakeCall,
    required this.listenToCallEvents,
    required this.endFakeCall,
    required this.pickCallerAvatar,
    required this.pickCallerVideo,
    required this.rememberCallerName,
    required this.syncActiveCall,
    required this.getLastCallConfig,
    required this.saveLastCallConfig,
    required this.listenToQuickTriggers,
    required this.failureMessages,
    CallConfig initialConfig = defaultConfig,
  }) : super(FakeCallIdle(initialConfig)) {
    on<FakeCallStarted>(_onStarted);
    on<FakeCallConfigChanged>(_onConfigChanged);
    on<FakeCallAvatarPickRequested>(_onAvatarPickRequested);
    on<FakeCallAvatarRemoved>(_onAvatarRemoved);
    on<FakeCallVideoPickRequested>(_onVideoPickRequested);
    on<FakeCallVideoRemoved>(_onVideoRemoved);
    on<FakeCallScheduleRequested>(_onScheduleRequested);
    on<FakeCallEndRequested>(_onEndRequested);
    on<FakeCallAppResumed>(_onAppResumed);
    on<FakeCallRestoreRequested>(_onRestoreRequested);
    on<FakeCallQuickTriggersStarted>(_onQuickTriggersStarted);
    on<_QuickTriggered>(_onQuickTriggered);
    on<FakeCallReset>(_onReset);
    on<_CountdownTicked>(_onCountdownTicked);
  }

  Future<void> _onStarted(
    FakeCallStarted event,
    Emitter<FakeCallState> emit,
  ) async {
    final result = await listenToCallEvents(const NoParams());
    await result.fold(
      (failure) async => emit(
        FakeCallError(state.config, message: failureMessages.of(failure)),
      ),
      (stream) => emit.forEach<CallEvent>(
        stream,
        onData: _mapCallEventToState,
        onError: (error, _) {
          _stopTicker();
          return FakeCallError(
            state.config,
            message: failureMessages.of(
              error is Failure
                  ? error
                  : const CallKitFailure(FailureReason.unknown),
            ),
          );
        },
      ),
    );
  }

  void _onConfigChanged(
    FakeCallConfigChanged event,
    Emitter<FakeCallState> emit,
  ) {
    if (state.isEditable) emit(FakeCallIdle(event.config));
  }

  Future<void> _onAvatarPickRequested(
    FakeCallAvatarPickRequested event,
    Emitter<FakeCallState> emit,
  ) async {
    if (!state.isEditable) return;
    final result = await pickCallerAvatar(const NoParams());
    result.fold(
      (failure) => emit(
        FakeCallError(state.config, message: failureMessages.of(failure)),
      ),
      (path) {
        if (path != null && state.isEditable) {
          emit(FakeCallIdle(state.config.copyWith(callerAvatarPath: path)));
        }
      },
    );
  }

  void _onAvatarRemoved(
    FakeCallAvatarRemoved event,
    Emitter<FakeCallState> emit,
  ) {
    if (state.isEditable) {
      emit(FakeCallIdle(state.config.copyWith(clearAvatar: true)));
    }
  }

  Future<void> _onVideoPickRequested(
    FakeCallVideoPickRequested event,
    Emitter<FakeCallState> emit,
  ) async {
    if (!state.isEditable) return;
    final result = await pickCallerVideo(const NoParams());
    result.fold(
      (failure) => emit(
        FakeCallError(state.config, message: failureMessages.of(failure)),
      ),
      (path) {
        if (path != null && state.isEditable) {
          emit(FakeCallIdle(state.config.copyWith(callerVideoPath: path)));
        }
      },
    );
  }

  void _onVideoRemoved(
    FakeCallVideoRemoved event,
    Emitter<FakeCallState> emit,
  ) {
    if (state.isEditable) {
      emit(FakeCallIdle(state.config.copyWith(clearVideo: true)));
    }
  }

  Future<void> _onRestoreRequested(
    FakeCallRestoreRequested event,
    Emitter<FakeCallState> emit,
  ) async {
    final result = await getLastCallConfig(const NoParams());
    result.fold((_) {}, (config) {
      if (config != null && state is FakeCallIdle) emit(FakeCallIdle(config));
    });
  }

  Future<void> _onQuickTriggersStarted(
    FakeCallQuickTriggersStarted event,
    Emitter<FakeCallState> emit,
  ) async {
    final result = await listenToQuickTriggers(const NoParams());
    await result.fold(
      (_) async {},
      (stream) => emit.onEach<int>(
        stream,
        onData: (delay) => add(_QuickTriggered(delay)),
        onError: (_, _) {},
      ),
    );
  }

  Future<void> _onQuickTriggered(
    _QuickTriggered event,
    Emitter<FakeCallState> emit,
  ) async {
    if (!state.isEditable) return;
    final saved = await getLastCallConfig(const NoParams());
    final base = saved.fold((_) => null, (config) => config) ?? state.config;
    await _schedule(base.copyWith(delayInSeconds: event.delayInSeconds), emit);
  }

  Future<void> _onScheduleRequested(
    FakeCallScheduleRequested event,
    Emitter<FakeCallState> emit,
  ) async {
    if (!state.isEditable) return;
    await _schedule(state.config, emit);
  }

  Future<void> _schedule(CallConfig config, Emitter<FakeCallState> emit) async {
    final result = await scheduleFakeCall(config);
    result.fold(
      (failure) => emit(
        FakeCallError(
          config,
          message: failureMessages.of(failure),
          invalidField: failure is InvalidCallConfigFailure
              ? failure.field
              : null,
        ),
      ),
      (_) {
        emit(
          FakeCallCountingDown(config, remainingSeconds: config.delayInSeconds),
        );
        _startTicker(config.delayInSeconds);
      },
    );
    if (result.isLeft()) return;
    await rememberCallerName(config.callerName);
    await saveLastCallConfig(config);
  }

  Future<void> _onEndRequested(
    FakeCallEndRequested event,
    Emitter<FakeCallState> emit,
  ) async {
    _stopTicker();
    final result = await endFakeCall(const NoParams());
    result.fold(
      (failure) => emit(
        FakeCallError(state.config, message: failureMessages.of(failure)),
      ),
      (_) {},
    );
  }

  Future<void> _onAppResumed(
    FakeCallAppResumed event,
    Emitter<FakeCallState> emit,
  ) async {
    final result = await syncActiveCall(const NoParams());
    result.fold(
      (failure) => emit(
        FakeCallError(state.config, message: failureMessages.of(failure)),
      ),
      (_) {},
    );
  }

  void _onReset(FakeCallReset event, Emitter<FakeCallState> emit) {
    _stopTicker();
    emit(FakeCallIdle(state.config));
  }

  void _onCountdownTicked(_CountdownTicked event, Emitter<FakeCallState> emit) {
    final current = state;
    final remaining = event.remainingSeconds;
    switch (current) {
      case FakeCallCountingDown():
        emit(FakeCallCountingDown(current.config, remainingSeconds: remaining));
      case FakeCallWaitingRecall():
        emit(
          FakeCallWaitingRecall(
            current.config,
            nextAttempt: current.nextAttempt,
            remainingSeconds: remaining,
          ),
        );
      default:
        break;
    }
  }

  FakeCallState _mapCallEventToState(CallEvent event) {
    final config = state.config;
    switch (event.type) {
      case CallEventType.incoming:
        _stopTicker();
        return FakeCallRinging(config, attempt: event.attempt);
      case CallEventType.accepted:
        _stopTicker();
        return FakeCallAccepted(event.config ?? config, attempt: event.attempt);
      case CallEventType.recallScheduled:
        _startTicker(config.autoRecallInterval);
        return FakeCallWaitingRecall(
          config,
          nextAttempt: event.attempt,
          remainingSeconds: config.autoRecallInterval,
        );
      case CallEventType.declined:
      case CallEventType.timeout:
      case CallEventType.ended:
      case CallEventType.cancelled:
        _stopTicker();
        return FakeCallFinished(config, reason: event.type);
    }
  }

  void _startTicker(int seconds) {
    _stopTicker();
    _ticker = Stream<int>.periodic(
      const Duration(seconds: 1),
      (tick) => seconds - tick - 1,
    ).take(seconds).listen((remaining) => add(_CountdownTicked(remaining)));
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  Future<void> close() {
    _stopTicker();
    return super.close();
  }
}
