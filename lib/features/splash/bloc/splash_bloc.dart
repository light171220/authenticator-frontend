import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../core/storage/preferences.dart';
import '../../../core/storage/secure_storage.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AppPreferences _preferences = GetIt.instance<AppPreferences>();
  final SecureStorage _secureStorage = GetIt.instance<SecureStorage>();

  SplashBloc() : super(SplashInitial()) {
    on<CheckAppStatus>(_onCheckAppStatus);
  }

  Future<void> _onCheckAppStatus(
    CheckAppStatus event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());

    await Future.delayed(const Duration(seconds: 2));

    try {
      final isOnboarded = _preferences.getIsOnboarded();
      final hasAuthToken = await _secureStorage.getAuthToken() != null;

      if (!isOnboarded) {
        emit(const SplashNavigateToOnboarding());
      } else if (hasAuthToken) {
        emit(const SplashNavigateToHome());
      } else {
        emit(const SplashNavigateToAuth());
      }
    } catch (e) {
      emit(const SplashNavigateToOnboarding());
    }
  }
}