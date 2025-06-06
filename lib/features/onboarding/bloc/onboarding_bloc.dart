import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../core/storage/preferences.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final AppPreferences _preferences = GetIt.instance<AppPreferences>();

  OnboardingBloc() : super(OnboardingInitial()) {
    on<NextPage>(_onNextPage);
    on<PreviousPage>(_onPreviousPage);
    on<CompleteOnboarding>(_onCompleteOnboarding);
    on<SkipOnboarding>(_onSkipOnboarding);
  }

  Future<void> _onNextPage(
    NextPage event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingPageState) {
      final currentState = state as OnboardingPageState;
      final nextPage = currentState.currentPage + 1;
      
      if (nextPage < 3) {
        emit(OnboardingPageState(nextPage));
      } else {
        emit(OnboardingCompleted());
      }
    }
  }

  Future<void> _onPreviousPage(
    PreviousPage event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingPageState) {
      final currentState = state as OnboardingPageState;
      final previousPage = currentState.currentPage - 1;
      
      if (previousPage >= 0) {
        emit(OnboardingPageState(previousPage));
      }
    }
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    await _preferences.setIsOnboarded(true);
    emit(OnboardingCompleted());
  }

  Future<void> _onSkipOnboarding(
    SkipOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    await _preferences.setIsOnboarded(true);
    emit(OnboardingCompleted());
  }
}