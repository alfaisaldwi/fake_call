import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/failure_messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_onboarding_completed.dart';
import '../../domain/usecases/complete_onboarding.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CheckOnboardingCompleted checkOnboardingCompleted;
  final CompleteOnboarding completeOnboarding;
  final FailureMessages failureMessages;

  OnboardingBloc({
    required this.checkOnboardingCompleted,
    required this.completeOnboarding,
    required this.failureMessages,
  }) : super(const OnboardingChecking()) {
    on<OnboardingStatusRequested>(_onStatusRequested);
    on<OnboardingFinished>(_onFinished);
  }

  Future<void> _onStatusRequested(
    OnboardingStatusRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    final result = await checkOnboardingCompleted(const NoParams());
    result.fold(
      (_) => emit(const OnboardingRequired()),
      (completed) =>
          emit(completed ? const OnboardingDone() : const OnboardingRequired()),
    );
  }

  Future<void> _onFinished(
    OnboardingFinished event,
    Emitter<OnboardingState> emit,
  ) async {
    final result = await completeOnboarding(const NoParams());
    emit(const OnboardingDone());
    result.fold(
      (failure) => emit(OnboardingError(failureMessages.of(failure))),
      (_) {},
    );
  }
}
