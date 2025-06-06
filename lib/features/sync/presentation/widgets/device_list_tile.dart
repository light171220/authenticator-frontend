import 'package:flutter/material.dart';
import '../../../../app/theme/dimensions.dart';
import '../../../../core/utils/extensions/datetime_extensions.dart';
import '../../../../shared/widgets/dialogs/confirmation_dialog.dart';
import '../../domain/entities/device.dart';

class DeviceListTile extends StatelessWidget {
  final Device device;
  final VoidCallback? onRemove;

  const DeviceListTile({
    super.key,
    required this.device,
    this.onRemove,
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
            color: device.isCurrentDevice
                ? theme.primaryColor.withOpacity(0.1)
                : theme.colorScheme.outline.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Icon(
            _getDeviceIcon(device.type),
            color: device.isCurrentDevice
                ? theme.primaryColor
                : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                device.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (device.isCurrentDevice)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'This Device',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${device.platform} • ${device.appVersion}'),
            Text('Last active: ${device.lastActiveAt.timeAgo}'),
            if (!device.isActive)
              Text(
                'Offline',
                style: TextStyle(color: theme.colorScheme.error),
              ),
          ],
        ),
        trailing: onRemove != null
            ? IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: theme.colorScheme.error,
                onPressed: () async {
                  final confirmed = await ConfirmationDialog.show(
                    context: context,
                    title: 'Remove Device',
                    message: 'Are you sure you want to remove "${device.name}" from sync? This will stop syncing data to this device.',
                    confirmText: 'Remove',
                    isDestructive: true,
                    icon: Icons.remove_circle,
                  );
                  if (confirmed == true) {
                    onRemove?.call();
                  }
                },
              )
            : null,
        isThreeLine: true,
      ),
    );
  }

  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'phone':
      case 'mobile':
        return Icons.phone_android;
      case 'tablet':
        return Icons.tablet;
      case 'desktop':
      case 'computer':
        return Icons.computer;
      case 'laptop':
        return Icons.laptop;
      case 'web':
        return Icons.web;
      default:
        return Icons.devices;
    }
  }
}