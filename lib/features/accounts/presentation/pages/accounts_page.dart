import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/routes.dart';
import '../../../../app/theme/dimensions.dart';
import '../../../../shared/widgets/common/custom_app_bar.dart';
import '../../../../shared/widgets/common/empty_state.dart';
import '../../../../shared/widgets/common/error_widget.dart';
import '../../bloc/accounts_bloc.dart';
import '../../bloc/accounts_event.dart';
import '../../bloc/accounts_state.dart';
import '../widgets/account_tile.dart';
import '../widgets/search_bar.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountsBloc()..add(const LoadAccounts()),
      child: const AccountsView(),
    );
  }
}

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Accounts',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go(Routes.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            child: AccountSearchBar(),
          ),
          Expanded(
            child: BlocBuilder<AccountsBloc, AccountsState>(
              builder: (context, state) {
                if (state is AccountsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AccountsError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<AccountsBloc>().add(const LoadAccounts());
                    },
                  );
                }

                if (state is AccountsLoaded) {
                  if (state.filteredAccounts.isEmpty) {
                    return EmptyState(
                      title: 'No Accounts Yet',
                      message: 'Add your first authenticator account to get started with quantum-safe 2FA',
                      icon: Icons.security,
                      actionText: 'Add Account',
                      onAction: () => context.go(Routes.addAccount),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<AccountsBloc>().add(const LoadAccounts());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium,
                      ),
                      itemCount: state.filteredAccounts.length,
                      itemBuilder: (context, index) {
                        final account = state.filteredAccounts[index];
                        final otpCode = state.otpCodes[account.id];
                        
                        return AccountTile(
                          account: account,
                          otpCode: otpCode,
                          onTap: () => context.go('${Routes.accountDetails}/${account.id}'),
                          onCopy: () {
                            if (otpCode != null) {
                              // Copy OTP to clipboard
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('OTP copied to clipboard')),
                              );
                            }
                          },
                          onRefresh: () {
                            context.read<AccountsBloc>().add(GenerateOTP(account.id));
                          },
                          onToggleFavorite: () {
                            context.read<AccountsBloc>().add(ToggleFavorite(account.id));
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAccountBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddAccountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scan QR Code'),
              subtitle: const Text('Scan a QR code from a service'),
              onTap: () {
                Navigator.pop(context);
                context.go(Routes.qrScanner);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Enter Manually'),
              subtitle: const Text('Add account details manually'),
              onTap: () {
                Navigator.pop(context);
                context.go(Routes.addAccount);
              },
            ),
          ],
        ),
      ),
    );
  }
}