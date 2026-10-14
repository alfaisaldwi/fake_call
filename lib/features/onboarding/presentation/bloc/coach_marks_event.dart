part of 'coach_marks_bloc.dart';

sealed class CoachMarksEvent extends Equatable {
  const CoachMarksEvent();

  @override
  List<Object> get props => [];
}

final class CoachMarksRequested extends CoachMarksEvent {
  const CoachMarksRequested();
}

final class CoachMarksReplayRequested extends CoachMarksEvent {
  const CoachMarksReplayRequested();
}

final class CoachMarksCompleted extends CoachMarksEvent {
  const CoachMarksCompleted();
}
