import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/routes.dart';
import '../../../../app/theme/dimensions.dart';
import '../../../../shared/widgets/common/custom_app_bar.dart';
import '../../../../shared/widgets/common/custom_button.dart';
import '../../../../shared/widgets/common/empty_state.dart';
import '../../../../shared/widgets/common/error_widget.dart';
import '../../bloc/backup_bloc.dart';
import '../../bloc/backup_event.dart';
import '../../bloc/backup_state.dart';
import '../widgets/backup_list_tile.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BackupBloc()..add(const LoadBackups()),
      child: const BackupView(),
    );
  }
}

class BackupView extends StatelessWidget {
  const BackupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Backup & Restore'),
      body: BlocConsumer<BackupBloc, BackupState>(
        listener: (context, state) {
          if (state is BackupCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Backup created successfully')),
            );
          } else if (state is BackupRestored) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Backup restored successfully')),
            );
          } else if (state is BackupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is BackupLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BackupError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<BackupBloc>().add(const LoadBackups());
              },
            );
          }

          if (state is BackupsLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: CustomButton(
                    text: 'Create Backup',
                    onPressed: () => _showCreateBackupDialog(context),
                    icon: const Icon(Icons.backup),
                  ),
                ),
                Expanded(
                  child: state.backups.isEmpty
                      ? const EmptyState(
                          title: 'No Backups',
                          message: 'Create your first backup to secure your accounts',
                          icon: Icons.backup,
                          actionText: 'Create Backup',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingMedium,
                          ),
                          itemCount: state.backups.length,
                          itemBuilder: (context, index) {
                            final backup = state.backups[index];
                            return BackupListTile(
                              backup: backup,
                              onRestore: () {
                                context.read<BackupBloc>().add(
                                  RestoreBackup(backupId: backup.id),
                                );
                              },
                              onDelete: () {
                                context.read<BackupBloc>().add(
                                  DeleteBackup(backup.id),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showCreateBackupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create Backup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Backup Name',
                hintText: 'Enter backup name',
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Enter backup description',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Create',
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                context.read<BackupBloc>().add(
                  CreateBackup(
                    name: nameController.text.trim(),
                    description: descriptionController.text.trim().isEmpty
                        ? null
                        : descriptionController.text.trim(),
                  ),
                );
                Navigator.pop(dialogContext);
              }
            },
            isFullWidth: false,
            size: ButtonSize.small,
          ),
        ],
      ),
    );
  }
}