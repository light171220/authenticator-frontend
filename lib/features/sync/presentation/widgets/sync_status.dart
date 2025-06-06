import 'package:flutter/material.dart';
import '../../../../app/theme/dimensions.dart';
import '../../../../shared/widgets/common/custom_button.dart';
import '../../bloc/sync_state.dart';

class SyncStatusWidget extends StatelessWidget {
  final SyncState state;
  final VoidCallback? onToggleSync;

  const SyncStatusWidget({
    super.key,
    required this.state,
    this.onToggleSync,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Icon(
                    _getStatusIcon(),
                    color: _getStatusColor(),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusTitle(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStatusSubtitle(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (state is SyncInProgress) ...[
              const SizedBox(height: AppDimensions.paddingMedium),
              LinearProgressIndicator(
                value: (state as SyncInProgress).progress,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                (state as SyncInProgress).currentItem ?? 'Syncing...',
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppDimensions.paddingMedium),
            CustomButton(
              text: _getButtonText(),
              onPressed: onToggleSync,
              variant: state is SyncConnected ? ButtonVariant.outline : ButtonVariant.primary,
              icon: Icon(state is SyncConnected ? Icons.sync_disabled : Icons.sync),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    if (state is SyncConnected) return Icons.sync;
    if (state is SyncConnecting) return Icons.sync;
    if (state is SyncInProgress) return Icons.sync;
    if (state is SyncDisconnected) return Icons.sync_disabled;
    return Icons.sync_problem;
  }

  Color _getStatusColor() {
    if (state is SyncConnected) return Colors.green;
    if (state is SyncConnecting) return Colors.blue;
    if (state is SyncInProgress) return Colors.blue;
    if (state is SyncDisconnected) return Colors.grey;
    return Colors.red;
  }

  String _getStatusTitle() {
    if (state is SyncConnected) return 'Connected';
    if (state is SyncConnecting) return 'Connecting...';
    if (state is SyncInProgress) return 'Syncing...';
    if (state is SyncDisconnected) return 'Disconnected';
    if (state is ConflictResolutionRequired) return 'Conflicts Detected';
    return 'Sync Error';
  }

  String _getStatusSubtitle() {
    if (state is SyncConnected) {
      final connectedState = state as SyncConnected;
      return '${connectedState.devices.length} devices connected';
    }
    if (state is SyncConnecting) return 'Establishing connection...';
    if (state is SyncInProgress) {
      final progressState = state as SyncInProgress;
      return '${(progressState.progress * 100).toInt()}% complete';
    }
    if (state is SyncDisconnected) {
      final disconnectedState = state as SyncDisconnected;
      return '${disconnectedState.devices.length} devices available';
    }
    if (state is ConflictResolutionRequired) {
      final conflictState = state as ConflictResolutionRequired;
      return '${conflictState.conflicts.length} conflicts need attention';
    }
    if (state is SyncError) {
      return (state as SyncError).message;
    }
    return 'Ready to sync';
  }

  String _getButtonText() {
    if (state is SyncConnected) return 'Disconnect';
    if (state is SyncConnecting) return 'Cancel';
    if (state is SyncInProgress) return 'Cancel';
    return 'Start Sync';
  }
}