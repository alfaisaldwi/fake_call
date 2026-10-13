part of 'caller_suggestions_bloc.dart';

sealed class CallerSuggestionsState extends Equatable {
  final CallerNameHistory history;

  const CallerSuggestionsState(this.history);

  @override
  List<Object> get props => [history];
}

final class CallerSuggestionsLoaded extends CallerSuggestionsState {
  const CallerSuggestionsLoaded(super.history);
}

final class CallerSuggestionsError extends CallerSuggestionsState {
  final String message;

  const CallerSuggestionsError(super.history, {required this.message});

  @override
  List<Object> get props => [history, message];
}
