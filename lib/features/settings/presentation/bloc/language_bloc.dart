import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/failure_messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/usecases/get_app_language.dart';
import '../../domain/usecases/save_app_language.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final GetAppLanguage getAppLanguage;
  final SaveAppLanguage saveAppLanguage;
  final FailureMessages failureMessages;

  LanguageBloc({
    required this.getAppLanguage,
    required this.saveAppLanguage,
    required this.failureMessages,
  }) : super(const LanguageReady(AppLanguage.system)) {
    on<LanguageStarted>(_onStarted);
    on<LanguageSelected>(_onSelected);
  }

  Future<void> _onStarted(
    LanguageStarted event,
    Emitter<LanguageState> emit,
  ) async {
    final result = await getAppLanguage(const NoParams());
    result.fold(
      (failure) => emit(
        LanguageError(state.language, message: failureMessages.of(failure)),
      ),
      (language) => emit(LanguageReady(language)),
    );
  }

  Future<void> _onSelected(
    LanguageSelected event,
    Emitter<LanguageState> emit,
  ) async {
    final previous = state.language;
    emit(LanguageReady(event.language));
    final result = await saveAppLanguage(event.language);
    result.fold(
      (failure) =>
          emit(LanguageError(previous, message: failureMessages.of(failure))),
      (_) {},
    );
  }
}
