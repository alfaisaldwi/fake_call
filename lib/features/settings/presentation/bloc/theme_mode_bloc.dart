import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/failure_messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/usecases/get_theme_mode.dart';
import '../../domain/usecases/save_theme_mode.dart';

part 'theme_mode_event.dart';
part 'theme_mode_state.dart';

class ThemeModeBloc extends Bloc<ThemeModeEvent, ThemeModeState> {
  final GetThemeMode getThemeMode;
  final SaveThemeMode saveThemeMode;
  final FailureMessages failureMessages;

  ThemeModeBloc({
    required this.getThemeMode,
    required this.saveThemeMode,
    required this.failureMessages,
  }) : super(const ThemeModeReady(AppThemeMode.light)) {
    on<ThemeModeStarted>(_onStarted);
    on<ThemeModeSelected>(_onSelected);
  }

  Future<void> _onStarted(
    ThemeModeStarted event,
    Emitter<ThemeModeState> emit,
  ) async {
    final result = await getThemeMode(const NoParams());
    result.fold(
      (failure) => emit(
        ThemeModeError(state.mode, message: failureMessages.of(failure)),
      ),
      (mode) => emit(ThemeModeReady(mode)),
    );
  }

  Future<void> _onSelected(
    ThemeModeSelected event,
    Emitter<ThemeModeState> emit,
  ) async {
    final previous = state.mode;
    emit(ThemeModeReady(event.mode));
    final result = await saveThemeMode(event.mode);
    result.fold(
      (failure) =>
          emit(ThemeModeError(previous, message: failureMessages.of(failure))),
      (_) {},
    );
  }
}
