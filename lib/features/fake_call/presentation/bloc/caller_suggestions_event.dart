part of 'caller_suggestions_bloc.dart';

sealed class CallerSuggestionsEvent extends Equatable {
  const CallerSuggestionsEvent();

  @override
  List<Object> get props => [];
}

final class CallerSuggestionsRequested extends CallerSuggestionsEvent {
  const CallerSuggestionsRequested();
}

final class CallerSuggestionRemoved extends CallerSuggestionsEvent {
  final String name;

  const CallerSuggestionRemoved(this.name);

  @override
  List<Object> get props => [name];
}
