import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/failure_messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/call_config.dart';
import '../../domain/entities/caller_preset.dart';
import '../../domain/usecases/delete_caller_preset.dart';
import '../../domain/usecases/get_caller_presets.dart';
import '../../domain/usecases/save_caller_preset.dart';

part 'caller_presets_event.dart';
part 'caller_presets_state.dart';

class CallerPresetsBloc extends Bloc<CallerPresetsEvent, CallerPresetsState> {
  final GetCallerPresets getCallerPresets;
  final SaveCallerPreset saveCallerPreset;
  final DeleteCallerPreset deleteCallerPreset;
  final FailureMessages failureMessages;

  CallerPresetsBloc({
    required this.getCallerPresets,
    required this.saveCallerPreset,
    required this.deleteCallerPreset,
    required this.failureMessages,
  }) : super(const CallerPresetsLoaded([])) {
    on<CallerPresetsRequested>(_onRequested);
    on<CallerPresetSaveRequested>(_onSaveRequested);
    on<CallerPresetDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onRequested(
    CallerPresetsRequested event,
    Emitter<CallerPresetsState> emit,
  ) async {
    final result = await getCallerPresets(const NoParams());
    result.fold(
      (failure) => emit(
        CallerPresetsError(state.presets, message: failureMessages.of(failure)),
      ),
      (presets) => emit(CallerPresetsLoaded(presets)),
    );
  }

  Future<void> _onSaveRequested(
    CallerPresetSaveRequested event,
    Emitter<CallerPresetsState> emit,
  ) async {
    final result = await saveCallerPreset(event.config);
    result.fold(
      (failure) => emit(
        CallerPresetsError(state.presets, message: failureMessages.of(failure)),
      ),
      (presets) => emit(
        CallerPresetSaved(presets, name: event.config.callerName.trim()),
      ),
    );
  }

  Future<void> _onDeleteRequested(
    CallerPresetDeleteRequested event,
    Emitter<CallerPresetsState> emit,
  ) async {
    final result = await deleteCallerPreset(event.id);
    result.fold(
      (failure) => emit(
        CallerPresetsError(state.presets, message: failureMessages.of(failure)),
      ),
      (presets) => emit(CallerPresetsLoaded(presets)),
    );
  }
}
