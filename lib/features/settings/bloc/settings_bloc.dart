import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../core/storage/preferences.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppPreferences _preferences = GetIt.instance<AppPreferences>();

  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateThemeMode>(_onUpdateThemeMode);
    on<UpdateLanguage>(_onUpdateLanguage);
    on<ToggleBiometric>(_onToggleBiometric);
    on<ToggleAutoBackup>(_onToggleAutoBackup);
    on<ToggleSync>(_onToggleSync);
    on<ToggleNotifications>(_onToggleNotifications);
    on<UpdateBackupFrequency>(_onUpdateBackupFrequency);
    on<ToggleOTPTimer>(_onToggleOTPTimer);
    on<UpdateSortOrder>(_onUpdateSortOrder);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());

    try {
      final settings = AppSettings(
        themeMode: _preferences.getThemeMode(),
        languageCode: _preferences.getLanguageCode(),
        biometricEnabled: _preferences.getBiometricEnabled(),
        autoBackupEnabled: _preferences.getAutoBackupEnabled(),
        syncEnabled: _preferences.getSyncEnabled(),
        notificationsEnabled: _preferences.getNotificationsEnabled(),
        backupFrequency: _preferences.getBackupFrequency(),
        showOTPTimer: _preferences.getShowOTPTimer(),
        sortAccountsBy: _preferences.getSortAccountsBy(),
      );

      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError('Failed to load settings'));
    }
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      await _preferences.setThemeMode(event.themeMode);
      
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(themeMode: event.themeMode),
      ));
    }
  }

  Future<void> _onUpdateLanguage(
    UpdateLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      await _preferences.setLanguageCode(event.languageCode);
      
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(languageCode: event.languageCode),
      ));
    }
  }

  Future<void> _onToggleBiometric(
    ToggleBiometric event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      await _preferences.setBiometricEnabled(event.enabled);
      
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(biometricEnabled: event.enabled),
      ));
    }
  }

  Future<void> _onToggleAutoBackup(
    ToggleAutoBackup event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      await _preferences.setAutoBackupEnabled(event.enabled);
      
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(autoBackupEnabled: event.enabled),
      ));
    }
  }

  Future<void> _onToggleSync(
    ToggleSync event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      await _preferences.setSyncEnabled(event.enabled);
      
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(syncEnabled: event.enabled),
      ));
    }
  }

  Future<void> _onToggleNotifications(
    ToggleNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      await _preferences.setNotificationsEnabled(event.enabled);
      
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(notificationsEnabled: event.enabled),
      ));
    }
  }

  Future<void> _onUpdateBackupFrequency(
    UpdateBackupFrequency event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      await _preferences.setBackupFrequency(event.frequency);
      
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(backupFrequency: event.frequency),
      ));
    }
  }

  Future<void> _onToggleOTPTimer(
    ToggleOTPTimer event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      await _preferences.setShowOTPTimer(event.enabled);
      
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(showOTPTimer: event.enabled),
      ));
    }
  }

  Future<void> _onUpdateSortOrder(
    UpdateSortOrder event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      await _preferences.setSortAccountsBy(event.sortBy);
      
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(sortAccountsBy: event.sortBy),
      ));
    }
  }
}

class AppSettings {
  final String themeMode;
  final String languageCode;
  final bool biometricEnabled;
  final bool autoBackupEnabled;
  final bool syncEnabled;
  final bool notificationsEnabled;
  final String backupFrequency;
  final bool showOTPTimer;
  final String sortAccountsBy;

  const AppSettings({
    required this.themeMode,
    required this.languageCode,
    required this.biometricEnabled,
    required this.autoBackupEnabled,
    required this.syncEnabled,
    required this.notificationsEnabled,
    required this.backupFrequency,
    required this.showOTPTimer,
    required this.sortAccountsBy,
  });

  AppSettings copyWith({
    String? themeMode,
    String? languageCode,
    bool? biometricEnabled,
    bool? autoBackupEnabled,
    bool? syncEnabled,
    bool? notificationsEnabled,
    String? backupFrequency,
    bool? showOTPTimer,
    String? sortAccountsBy,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      backupFrequency: backupFrequency ?? this.backupFrequency,
      showOTPTimer: showOTPTimer ?? this.showOTPTimer,
      sortAccountsBy: sortAccountsBy ?? this.sortAccountsBy,
    );
  }
}