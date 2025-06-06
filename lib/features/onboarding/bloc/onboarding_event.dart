import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class NextPage extends OnboardingEvent {
  const NextPage();
}

class PreviousPage extends OnboardingEvent {
  const PreviousPage();
}

class CompleteOnboarding extends OnboardingEvent {
  const CompleteOnboarding();
}

class SkipOnboarding extends OnboardingEvent {
  const SkipOnboarding();
}