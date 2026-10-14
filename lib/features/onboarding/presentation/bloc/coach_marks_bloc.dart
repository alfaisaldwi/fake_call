import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/failure_messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_coach_marks_seen.dart';
import '../../domain/usecases/set_coach_marks_seen.dart';

part 'coach_marks_event.dart';
part 'coach_marks_state.dart';

class CoachMarksBloc extends Bloc<CoachMarksEvent, CoachMarksState> {
  final CheckCoachMarksSeen checkCoachMarksSeen;
  final SetCoachMarksSeen setCoachMarksSeen;
  final FailureMessages failureMessages;

  int _run = 0;

  CoachMarksBloc({
    required this.checkCoachMarksSeen,
    required this.setCoachMarksSeen,
    required this.failureMessages,
  }) : super(const CoachMarksHidden()) {
    on<CoachMarksRequested>(_onRequested);
    on<CoachMarksReplayRequested>(_onReplayRequested);
    on<CoachMarksCompleted>(_onCompleted);
  }

  Future<void> _onRequested(
    CoachMarksRequested event,
    Emitter<CoachMarksState> emit,
  ) async {
    final result = await checkCoachMarksSeen(const NoParams());
    result.fold(
      (failure) => emit(CoachMarksError(failureMessages.of(failure))),
      (seen) {
        if (!seen) emit(CoachMarksVisible(++_run));
      },
    );
  }

  Future<void> _onReplayRequested(
    CoachMarksReplayRequested event,
    Emitter<CoachMarksState> emit,
  ) async {
    await setCoachMarksSeen(false);
    emit(CoachMarksVisible(++_run));
  }

  Future<void> _onCompleted(
    CoachMarksCompleted event,
    Emitter<CoachMarksState> emit,
  ) async {
    emit(const CoachMarksHidden());
    final result = await setCoachMarksSeen(true);
    result.fold(
      (failure) => emit(CoachMarksError(failureMessages.of(failure))),
      (_) {},
    );
  }
}
