part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

final class OnboardingStatusRequested extends OnboardingEvent {
  const OnboardingStatusRequested();
}

final class OnboardingFinished extends OnboardingEvent {
  const OnboardingFinished();
}
