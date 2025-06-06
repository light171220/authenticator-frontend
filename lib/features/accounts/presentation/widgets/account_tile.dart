import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/dimensions.dart';
import '../../../../app/theme/typography.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/otp_code.dart';
import 'otp_display.dart';
import 'progress_circle.dart';

class AccountTile extends StatelessWidget {
  final Account account;
  final OTPCode? otpCode;
  final VoidCallback? onTap;
  final VoidCallback? onCopy;
  final VoidCallback? onRefresh;
  final VoidCallback? onToggleFavorite;

  const AccountTile({
    super.key,
    required this.account,
    this.otpCode,
    this.onTap,
    this.onCopy,
    this.onRefresh,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: account.iconUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        child: Image.network(
                          account.iconUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(theme),
                        ),
                      )
                    : _buildDefaultIcon(theme),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            account.serviceName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (account.isFavorite)
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      account.accountName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    if (otpCode != null)
                      OTPDisplay(
                        otpCode: otpCode!,
                        onCopy: onCopy,
                      ),
                  ],
                ),
              ),
              if (otpCode != null && account.isTimeBasedOTP)
                ProgressCircle(
                  progress: otpCode!.progress,
                  isExpiring: otpCode!.isExpiring,
                ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'copy':
                      onCopy?.call();
                      break;
                    case 'refresh':
                      onRefresh?.call();
                      break;
                    case 'favorite':
                      onToggleFavorite?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'copy',
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 8),
                        Text('Copy Code'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'refresh',
                    child: Row(
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 8),
                        Text('Refresh'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'favorite',
                    child: Row(
                      children: [
                        Icon(account.isFavorite ? Icons.star_border : Icons.star),
                        const SizedBox(width: 8),
                        Text(account.isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon(ThemeData theme) {
    return Icon(
      Icons.security,
      color: theme.primaryColor,
      size: 24,
    );
  }
}