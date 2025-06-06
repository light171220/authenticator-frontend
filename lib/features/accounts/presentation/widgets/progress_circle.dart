import 'package:flutter/material.dart';
import '../../../../app/theme/dimensions.dart';

class ProgressCircle extends StatelessWidget {
  final double progress;
  final bool isExpiring;

  const ProgressCircle({
    super.key,
    required this.progress,
    required this.isExpiring,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: AppDimensions.otpProgressSize,
      height: AppDimensions.otpProgressSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: AppDimensions.otpProgressStroke,
            backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              isExpiring ? theme.colorScheme.error : theme.colorScheme.primary,
            ),
          ),
          Text(
            '${((1 - progress) * 30).ceil()}',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isExpiring ? theme.colorScheme.error : theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}