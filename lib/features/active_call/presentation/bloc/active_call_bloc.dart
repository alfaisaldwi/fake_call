import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/failure_messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../fake_call/domain/entities/call_config.dart';
import '../../../fake_call/domain/usecases/get_call_preferences.dart';
import '../../domain/entities/call_media.dart';
import '../../domain/usecases/set_camera_enabled.dart';
import '../../domain/usecases/set_playback_paused.dart';
import '../../domain/usecases/set_proximity_lock.dart';
import '../../domain/usecases/start_call_media.dart';
import '../../domain/usecases/stop_call_media.dart';
import '../../domain/usecases/switch_camera.dart';

part 'active_call_event.dart';
part 'active_call_state.dart';

class ActiveCallBloc extends Bloc<ActiveCallEvent, ActiveCallState> {
  final StartCallMedia startCallMedia;
  final StopCallMedia stopCallMedia;
  final SetCameraEnabled setCameraEnabled;
  final SwitchCamera switchCamera;
  final SetPlaybackPaused setPlaybackPaused;
  final SetProximityLock setProximityLock;
  final GetCallPreferences getCallPreferences;
  final FailureMessages failureMessages;

  StreamSubscription<int>? _ticker;
  bool _mediaStarted = false;
  String? _videoPath;
  bool _isForeground = false;
  bool _mediaPending = false;
  bool _proximityLocked = false;

  ActiveCallBloc({
    required this.startCallMedia,
    required this.stopCallMedia,
    required this.setCameraEnabled,
    required this.switchCamera,
    required this.setPlaybackPaused,
    required this.setProximityLock,
    required this.getCallPreferences,
    required this.failureMessages,
  }) : super(const ActiveCallInitial()) {
    on<ActiveCallStarted>(_onStarted);
    on<ActiveCallForegroundChanged>(_onForegroundChanged);
    on<ActiveCallVideoRequested>(_onVideoRequested);
    on<ActiveCallCameraToggled>(_onCameraToggled);
    on<ActiveCallCameraSwitched>(_onCameraSwitched);
    on<ActiveCallMuteToggled>(_onMuteToggled);
    on<ActiveCallSpeakerToggled>(_onSpeakerToggled);
    on<ActiveCallStopped>(_onStopped);
    on<_ElapsedTicked>(_onElapsedTicked);
  }

  Future<void> _onStarted(
    ActiveCallStarted event,
    Emitter<ActiveCallState> emit,
  ) async {
    final isVideo = event.callType == CallType.video;
    _videoPath = event.videoPath;
    final preferences = await getCallPreferences(const NoParams());
    if (state is ActiveCallStoppedState) return;
    final initialElapsed = preferences.fold(
      (_) => Duration.zero,
      (preferences) => preferences.initialDuration,
    );
    emit(
      ActiveCallInProgress(
        isVideoMode: isVideo,
        isSpeakerOn: isVideo,
        elapsed: initialElapsed,
      ),
    );
    _startTicker(initialElapsed);
    if (isVideo) await _loadMediaWhenForeground(emit);
  }

  Future<void> _onForegroundChanged(
    ActiveCallForegroundChanged event,
    Emitter<ActiveCallState> emit,
  ) async {
    if (_isForeground == event.isForeground) return;
    _isForeground = event.isForeground;
    _syncProximityLock(state);
    if (_isForeground && _mediaPending) {
      await _loadMediaWhenForeground(emit);
    } else if (_mediaStarted) {
      await setPlaybackPaused(!_isForeground);
    }
  }

  Future<void> _onVideoRequested(
    ActiveCallVideoRequested event,
    Emitter<ActiveCallState> emit,
  ) async {
    final current = state;
    if (current is! ActiveCallInProgress || current.isVideoMode) return;
    emit(current.copyWith(isVideoMode: true, isSpeakerOn: true));
    await _loadMediaWhenForeground(emit);
    final after = state;
    if (after is ActiveCallInProgress &&
        after.media == null &&
        !after.isMediaLoading) {
      emit(after.copyWith(isVideoMode: false, isSpeakerOn: false));
    }
  }

  Future<void> _onCameraToggled(
    ActiveCallCameraToggled event,
    Emitter<ActiveCallState> emit,
  ) async {
    final current = state;
    if (current is! ActiveCallInProgress || !current.canControlCamera) return;
    final enabled = !current.isCameraOn;
    final result = await setCameraEnabled(enabled);
    result.fold(
      (failure) => _emitError(emit, failure, current),
      (_) => emit(_latest(current).copyWith(isCameraOn: enabled)),
    );
  }

  Future<void> _onCameraSwitched(
    ActiveCallCameraSwitched event,
    Emitter<ActiveCallState> emit,
  ) async {
    final current = state;
    if (current is! ActiveCallInProgress || !current.canControlCamera) return;
    emit(current.copyWith(isMediaLoading: true));
    final result = await switchCamera(const NoParams());
    result.fold(
      (failure) => _emitError(
        emit,
        failure,
        _latest(current).copyWith(isMediaLoading: false),
      ),
      (media) => emit(
        _latest(current)
            .copyWith(media: media, isMediaLoading: false, isCameraOn: true),
      ),
    );
  }

  void _onMuteToggled(
    ActiveCallMuteToggled event,
    Emitter<ActiveCallState> emit,
  ) {
    final current = state;
    if (current is ActiveCallInProgress) {
      emit(current.copyWith(isMuted: !current.isMuted));
    }
  }

  void _onSpeakerToggled(
    ActiveCallSpeakerToggled event,
    Emitter<ActiveCallState> emit,
  ) {
    final current = state;
    if (current is ActiveCallInProgress) {
      emit(current.copyWith(isSpeakerOn: !current.isSpeakerOn));
    }
  }

  Future<void> _onStopped(
    ActiveCallStopped event,
    Emitter<ActiveCallState> emit,
  ) async {
    await _release();
    emit(const ActiveCallStoppedState());
  }

  void _onElapsedTicked(_ElapsedTicked event, Emitter<ActiveCallState> emit) {
    final current = state;
    if (current is ActiveCallInProgress) {
      emit(current.copyWith(elapsed: event.elapsed));
    }
  }

  Future<void> _loadMediaWhenForeground(Emitter<ActiveCallState> emit) async {
    if (!_isForeground) {
      _mediaPending = true;
      final current = state;
      if (current is ActiveCallInProgress) {
        emit(current.copyWith(isMediaLoading: true));
      }
      return;
    }
    _mediaPending = false;
    await _loadMedia(emit);
  }

  Future<void> _loadMedia(Emitter<ActiveCallState> emit) async {
    final loading = state;
    if (loading is! ActiveCallInProgress) return;
    emit(loading.copyWith(isMediaLoading: true));
    final result = await startCallMedia(_videoPath);
    final current = state;
    if (current is! ActiveCallInProgress) {
      if (result.isRight()) await stopCallMedia(const NoParams());
      return;
    }
    result.fold(
      (failure) => _emitError(
        emit,
        failure,
        current.copyWith(isMediaLoading: false, clearMedia: true),
      ),
      (media) {
        _mediaStarted = true;
        emit(
          current.copyWith(
            media: media,
            isMediaLoading: false,
            isCameraOn: media.isCameraOn,
          ),
        );
      },
    );
  }

  void _syncProximityLock(ActiveCallState state) {
    if (state is ActiveCallError) return;
    final locked =
        _isForeground &&
        state is ActiveCallInProgress &&
        !state.isVideoMode &&
        !state.isSpeakerOn;
    if (locked == _proximityLocked) return;
    _proximityLocked = locked;
    unawaited(setProximityLock(locked));
  }

  ActiveCallInProgress _latest(ActiveCallInProgress fallback) {
    final current = state;
    return current is ActiveCallInProgress ? current : fallback;
  }

  void _emitError(
    Emitter<ActiveCallState> emit,
    Failure failure,
    ActiveCallInProgress restore,
  ) {
    emit(ActiveCallError(failureMessages.of(failure)));
    emit(restore);
  }

  void _startTicker(Duration from) {
    _ticker?.cancel();
    _ticker =
        Stream<int>.periodic(
          const Duration(seconds: 1),
          (tick) => tick + 1,
        ).listen(
          (seconds) => add(_ElapsedTicked(from + Duration(seconds: seconds))),
        );
  }

  Future<void> _release() async {
    await _ticker?.cancel();
    _ticker = null;
    if (_proximityLocked) {
      _proximityLocked = false;
      await setProximityLock(false);
    }
    if (_mediaStarted) {
      _mediaStarted = false;
      await stopCallMedia(const NoParams());
    }
  }

  @override
  void onChange(Change<ActiveCallState> change) {
    super.onChange(change);
    _syncProximityLock(change.nextState);
  }

  @override
  Future<void> close() async {
    await _release();
    return super.close();
  }
}
