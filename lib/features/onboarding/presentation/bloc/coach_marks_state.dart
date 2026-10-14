part of 'coach_marks_bloc.dart';

sealed class CoachMarksState extends Equatable {
  const CoachMarksState();

  @override
  List<Object> get props => [];
}

final class CoachMarksHidden extends CoachMarksState {
  const CoachMarksHidden();
}

final class CoachMarksVisible extends CoachMarksState {
  final int run;

  const CoachMarksVisible(this.run);

  @override
  List<Object> get props => [run];
}

final class CoachMarksError extends CoachMarksState {
  final String message;

  const CoachMarksError(this.message);

  @override
  List<Object> get props => [message];
}
