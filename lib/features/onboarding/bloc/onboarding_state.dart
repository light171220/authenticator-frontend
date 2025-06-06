import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingPageState extends OnboardingState {
  final int currentPage;

  const OnboardingPageState(this.currentPage);

  @override
  List<Object> get props => [currentPage];
}

class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}