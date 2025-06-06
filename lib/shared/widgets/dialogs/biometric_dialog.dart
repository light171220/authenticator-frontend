import 'package:flutter/material.dart';
import '../../../app/theme/dimensions.dart';
import '../common/custom_button.dart';

class BiometricDialog extends StatelessWidget {
  final String title;
  final String message;
  final String biometricType;
  final VoidCallback? onAuthenticate;
  final VoidCallback? onCancel;

  const BiometricDialog({
    super.key,
    required this.title,
    required this.message,
    required this.biometricType,
    this.onAuthenticate,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _getBiometricIcon(),
            color: theme.primaryColor,
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getBiometricIcon(),
              size: 40,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            message,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        CustomButton(
          text: 'Cancel',
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          variant: ButtonVariant.text,
          size: ButtonSize.medium,
          isFullWidth: false,
        ),
        const SizedBox(width: AppDimensions.paddingSmall),
        CustomButton(
          text: 'Authenticate',
          onPressed: onAuthenticate ?? () => Navigator.of(context).pop(true),
          variant: ButtonVariant.primary,
          size: ButtonSize.medium,
          isFullWidth: false,
        ),
      ],
    );
  }

  IconData _getBiometricIcon() {
    switch (biometricType.toLowerCase()) {
      case 'face id':
      case 'face':
        return Icons.face;
      case 'fingerprint':
        return Icons.fingerprint;
      case 'iris':
        return Icons.visibility;
      default:
        return Icons.security;
    }
  }

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String biometricType,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => BiometricDialog(
        title: title,
        message: message,
        biometricType: biometricType,
      ),
    );
  }
}