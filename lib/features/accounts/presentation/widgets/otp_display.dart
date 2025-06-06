import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/typography.dart';
import '../../domain/entities/otp_code.dart';

class OTPDisplay extends StatelessWidget {
  final OTPCode otpCode;
  final VoidCallback? onCopy;

  const OTPDisplay({
    super.key,
    required this.otpCode,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        if (onCopy != null) {
          Clipboard.setData(ClipboardData(text: otpCode.code));
          onCopy!();
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: otpCode.isExpiring
              ? theme.colorScheme.errorContainer
              : theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: otpCode.isExpiring
                ? theme.colorScheme.error.withOpacity(0.3)
                : theme.colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              otpCode.formattedCode,
              style: AppTypography.otpCode.copyWith(
                color: otpCode.isExpiring
                    ? theme.colorScheme.onErrorContainer
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.copy,
              size: 16,
              color: otpCode.isExpiring
                  ? theme.colorScheme.onErrorContainer
                  : theme.colorScheme.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}