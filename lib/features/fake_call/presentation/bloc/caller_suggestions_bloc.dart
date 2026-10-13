import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/failure_messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/caller_name_history.dart';
import '../../domain/usecases/forget_caller_name.dart';
import '../../domain/usecases/get_caller_name_history.dart';

part 'caller_suggestions_event.dart';
part 'caller_suggestions_state.dart';

class CallerSuggestionsBloc
    extends Bloc<CallerSuggestionsEvent, CallerSuggestionsState> {
  final GetCallerNameHistory getCallerNameHistory;
  final ForgetCallerName forgetCallerName;
  final FailureMessages failureMessages;

  CallerSuggestionsBloc({
    required this.getCallerNameHistory,
    required this.forgetCallerName,
    required this.failureMessages,
  }) : super(const CallerSuggestionsLoaded(CallerNameHistory.empty())) {
    on<CallerSuggestionsRequested>(_onRequested);
    on<CallerSuggestionRemoved>(_onRemoved);
  }

  Future<void> _onRequested(
    CallerSuggestionsRequested event,
    Emitter<CallerSuggestionsState> emit,
  ) async {
    final result = await getCallerNameHistory(const NoParams());
    result.fold(
      (failure) => emit(
        CallerSuggestionsError(
          state.history,
          message: failureMessages.of(failure),
        ),
      ),
      (history) => emit(CallerSuggestionsLoaded(history)),
    );
  }

  Future<void> _onRemoved(
    CallerSuggestionRemoved event,
    Emitter<CallerSuggestionsState> emit,
  ) async {
    final previous = state.history;
    emit(CallerSuggestionsLoaded(previous.forget(event.name)));
    final result = await forgetCallerName(event.name);
    result.fold(
      (failure) => emit(
        CallerSuggestionsError(previous, message: failureMessages.of(failure)),
      ),
      (history) => emit(CallerSuggestionsLoaded(history)),
    );
  }
}
