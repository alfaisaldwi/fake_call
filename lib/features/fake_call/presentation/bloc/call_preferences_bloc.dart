import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/failure_messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/call_preferences.dart';
import '../../domain/usecases/get_call_preferences.dart';
import '../../domain/usecases/save_call_preferences.dart';

part 'call_preferences_event.dart';
part 'call_preferences_state.dart';

class CallPreferencesBloc
    extends Bloc<CallPreferencesEvent, CallPreferencesState> {
  final GetCallPreferences getCallPreferences;
  final SaveCallPreferences saveCallPreferences;
  final FailureMessages failureMessages;

  CallPreferencesBloc({
    required this.getCallPreferences,
    required this.saveCallPreferences,
    required this.failureMessages,
  }) : super(const CallPreferencesReady(CallPreferences())) {
    on<CallPreferencesStarted>(_onStarted);
    on<RingtoneSelected>(_onRingtoneSelected);
    on<RingVibrationChanged>(_onVibrationChanged);
    on<InitialDurationSelected>(_onInitialDurationSelected);
  }

  Future<void> _onStarted(
    CallPreferencesStarted event,
    Emitter<CallPreferencesState> emit,
  ) async {
    final result = await getCallPreferences(const NoParams());
    result.fold(
      (failure) => emit(
        CallPreferencesError(
          state.preferences,
          message: failureMessages.of(failure),
        ),
      ),
      (preferences) => emit(CallPreferencesReady(preferences)),
    );
  }

  Future<void> _onRingtoneSelected(
    RingtoneSelected event,
    Emitter<CallPreferencesState> emit,
  ) {
    return _save(state.preferences.copyWith(ringtone: event.ringtone), emit);
  }

  Future<void> _onVibrationChanged(
    RingVibrationChanged event,
    Emitter<CallPreferencesState> emit,
  ) {
    return _save(state.preferences.copyWith(vibrate: event.vibrate), emit);
  }

  Future<void> _onInitialDurationSelected(
    InitialDurationSelected event,
    Emitter<CallPreferencesState> emit,
  ) {
    return _save(
      state.preferences.copyWith(initialDurationSeconds: event.seconds),
      emit,
    );
  }

  Future<void> _save(
    CallPreferences preferences,
    Emitter<CallPreferencesState> emit,
  ) async {
    final previous = state.preferences;
    emit(CallPreferencesReady(preferences));
    final result = await saveCallPreferences(preferences);
    result.fold(
      (failure) => emit(
        CallPreferencesError(previous, message: failureMessages.of(failure)),
      ),
      (_) {},
    );
  }
}
