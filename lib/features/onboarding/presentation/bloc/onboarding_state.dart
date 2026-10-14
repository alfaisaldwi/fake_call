part of 'onboarding_bloc.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

final class OnboardingChecking extends OnboardingState {
  const OnboardingChecking();
}

final class OnboardingRequired extends OnboardingState {
  const OnboardingRequired();
}

final class OnboardingDone extends OnboardingState {
  const OnboardingDone();
}

final class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object> get props => [message];
}
