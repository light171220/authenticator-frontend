import 'package:flutter/material.dart';
import '../../../../app/theme/dimensions.dart';
import '../../../../core/utils/extensions/datetime_extensions.dart';
import '../../../../shared/widgets/dialogs/confirmation_dialog.dart';
import '../../domain/entities/backup.dart';

class BackupListTile extends StatelessWidget {
  final Backup backup;
  final VoidCallback? onRestore;
  final VoidCallback? onDelete;

  const BackupListTile({
    super.key,
    required this.backup,
    this.onRestore,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getStatusColor(backup.backupStatus).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Icon(
            _getStatusIcon(backup.backupStatus),
            color: _getStatusColor(backup.backupStatus),
          ),
        ),
        title: Text(
          backup.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${backup.accountCount} accounts'),
            Text(backup.createdAt.timeAgo),
            if (backup.description != null)
              Text(
                backup.description!,
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            switch (value) {
              case 'restore':
                final confirmed = await ConfirmationDialog.show(
                  context: context,
                  title: 'Restore Backup',
                  message: 'This will restore ${backup.accountCount} accounts from "${backup.name}". Continue?',
                  confirmText: 'Restore',
                  icon: Icons.restore,
                );
                if (confirmed == true) {
                  onRestore?.call();
                }
                break;
              case 'delete':
                final confirmed = await ConfirmationDialog.show(
                  context: context,
                  title: 'Delete Backup',
                  message: 'Are you sure you want to delete "${backup.name}"? This action cannot be undone.',
                  confirmText: 'Delete',
                  isDestructive: true,
                  icon: Icons.delete,
                );
                if (confirmed == true) {
                  onDelete?.call();
                }
                break;
            }
          },
          itemBuilder: (context) => [
            if (backup.backupStatus == BackupStatus.completed) ...[
              const PopupMenuItem(
                value: 'restore',
                child: Row(
                  children: [
                    Icon(Icons.restore),
                    SizedBox(width: 8),
                    Text('Restore'),
                  ],
                ),
              ),
            ],
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        isThreeLine: backup.description != null,
      ),
    );
  }

  IconData _getStatusIcon(BackupStatus status) {
    switch (status) {
      case BackupStatus.creating:
        return Icons.backup;
      case BackupStatus.completed:
        return Icons.check_circle;
      case BackupStatus.failed:
        return Icons.error;
      case BackupStatus.corrupted:
        return Icons.warning;
      case BackupStatus.expired:
        return Icons.schedule;
    }
  }

  Color _getStatusColor(BackupStatus status) {
    switch (status) {
      case BackupStatus.creating:
        return Colors.blue;
      case BackupStatus.completed:
        return Colors.green;
      case BackupStatus.failed:
        return Colors.red;
      case BackupStatus.corrupted:
        return Colors.orange;
      case BackupStatus.expired:
        return Colors.grey;
    }
  }
}