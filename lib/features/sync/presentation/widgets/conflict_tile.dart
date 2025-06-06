import 'package:flutter/material.dart';
import '../../../../app/theme/dimensions.dart';
import '../../../../shared/widgets/common/custom_button.dart';
import '../../domain/entities/conflict.dart';

class ConflictTile extends StatelessWidget {
  final SyncConflict conflict;
  final Function(ConflictResolution) onResolve;

  const ConflictTile({
    super.key,
    required this.conflict,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: AppDimensions.paddingSmall),
                Expanded(
                  child: Text(
                    _getConflictTitle(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              _getConflictDescription(),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            _buildDataComparison(context),
            const SizedBox(height: AppDimensions.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Use Local',
                    onPressed: () => onResolve(ConflictResolution.useLocal),
                    variant: ButtonVariant.outline,
                    size: ButtonSize.small,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingSmall),
                Expanded(
                  child: CustomButton(
                    text: 'Use Remote',
                    onPressed: () => onResolve(ConflictResolution.useRemote),
                    variant: ButtonVariant.outline,
                    size: ButtonSize.small,
                  ),
                ),
              ],
            ),
            if (conflict.conflictType == ConflictType.dataConflict) ...[
              const SizedBox(height: AppDimensions.paddingSmall),
              CustomButton(
                text: 'Merge Changes',
                onPressed: () => onResolve(ConflictResolution.merge),
                variant: ButtonVariant.primary,
                size: ButtonSize.small,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getConflictTitle() {
    switch (conflict.conflictType) {
      case ConflictType.dataConflict:
        return 'Data Conflict';
      case ConflictType.deleteConflict:
        return 'Delete Conflict';
      case ConflictType.versionConflict:
        return 'Version Conflict';
    }
  }

  String _getConflictDescription() {
    switch (conflict.conflictType) {
      case ConflictType.dataConflict:
        return 'This ${conflict.entityType} was modified on both devices at the same time.';
      case ConflictType.deleteConflict:
        return 'This ${conflict.entityType} was deleted on one device but modified on another.';
      case ConflictType.versionConflict:
        return 'Different versions of this ${conflict.entityType} exist on different devices.';
    }
  }

  Widget _buildDataComparison(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Local Version:',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _formatData(conflict.localData),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            'Remote Version:',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _formatData(conflict.remoteData),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _formatData(Map<String, dynamic> data) {
    if (data.containsKey('name')) {
      return data['name']?.toString() ?? 'Unknown';
    }
    if (data.containsKey('serviceName')) {
      return '${data['serviceName']} (${data['accountName']})';
    }
    return 'Modified data';
  }
}