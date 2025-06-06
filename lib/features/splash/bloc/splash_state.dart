import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashNavigateToOnboarding extends SplashState {
  const SplashNavigateToOnboarding();
}

class SplashNavigateToAuth extends SplashState {
  const SplashNavigateToAuth();
}

class SplashNavigateToHome extends SplashState {
  const SplashNavigateToHome();
}