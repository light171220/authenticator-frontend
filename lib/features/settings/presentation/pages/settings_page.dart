import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/routes.dart';
import '../../../../app/theme/dimensions.dart';
import '../../../../shared/widgets/common/custom_app_bar.dart';
import '../../bloc/settings_bloc.dart';
import '../../bloc/settings_event.dart';
import '../../bloc/settings_state.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc()..add(const LoadSettings()),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsError) {
            return Center(child: Text(state.message));
          }

          if (state is SettingsLoaded) {
            return ListView(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              children: [
                _buildSection(
                  context,
                  'Security',
                  [
                    SettingsTile(
                      icon: Icons.fingerprint,
                      title: 'Biometric Authentication',
                      subtitle: 'Use fingerprint or face recognition',
                      trailing: Switch(
                        value: state.settings.biometricEnabled,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(ToggleBiometric(value));
                        },
                      ),
                    ),
                    SettingsTile(
                      icon: Icons.security,
                      title: 'Security Settings',
                      subtitle: 'Advanced security options',
                      onTap: () => context.go(Routes.security),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Sync & Backup',
                  [
                    SettingsTile(
                      icon: Icons.sync,
                      title: 'Auto Sync',
                      subtitle: 'Sync accounts across devices',
                      trailing: Switch(
                        value: state.settings.syncEnabled,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(ToggleSync(value));
                        },
                      ),
                    ),
                    SettingsTile(
                      icon: Icons.backup,
                      title: 'Auto Backup',
                      subtitle: 'Automatically backup your accounts',
                      trailing: Switch(
                        value: state.settings.autoBackupEnabled,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(ToggleAutoBackup(value));
                        },
                      ),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Appearance',
                  [
                    SettingsTile(
                      icon: Icons.palette,
                      title: 'Theme',
                      subtitle: 'Choose your preferred theme',
                      trailing: Text(state.settings.themeMode),
                      onTap: () => context.go(Routes.appearance),
                    ),
                    SettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: 'Choose your language',
                      trailing: Text(state.settings.languageCode.toUpperCase()),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'General',
                  [
                    SettingsTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Manage notification preferences',
                      trailing: Switch(
                        value: state.settings.notificationsEnabled,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(ToggleNotifications(value));
                        },
                      ),
                    ),
                    SettingsTile(
                      icon: Icons.timer,
                      title: 'Show OTP Timer',
                      subtitle: 'Display countdown timer for codes',
                      trailing: Switch(
                        value: state.settings.showOTPTimer,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(ToggleOTPTimer(value));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
            vertical: AppDimensions.paddingSmall,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        ...children,
        const SizedBox(height: AppDimensions.paddingLarge),
      ],
    );
  }
}