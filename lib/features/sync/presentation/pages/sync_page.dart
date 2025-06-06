import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/routes.dart';
import '../../../../app/theme/dimensions.dart';
import '../../../../shared/widgets/common/custom_app_bar.dart';
import '../../../../shared/widgets/common/custom_button.dart';
import '../../../../shared/widgets/common/error_widget.dart';
import '../../bloc/sync_bloc.dart';
import '../../bloc/sync_event.dart';
import '../../bloc/sync_state.dart';
import '../widgets/sync_status.dart';
import '../widgets/device_list_tile.dart';
import '../widgets/conflict_tile.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SyncBloc()
        ..add(const CheckSyncStatus())
        ..add(const LoadDevices())
        ..add(const LoadConflicts()),
      child: const SyncView(),
    );
  }
}

class SyncView extends StatelessWidget {
  const SyncView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sync',
        actions: [
          IconButton(
            icon: const Icon(Icons.devices),
            onPressed: () => context.go(Routes.devices),
          ),
        ],
      ),
      body: BlocConsumer<SyncBloc, SyncState>(
        listener: (context, state) {
          if (state is ConflictResolved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Conflict resolved successfully')),
            );
          } else if (state is SyncError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is SyncLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SyncError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<SyncBloc>().add(const CheckSyncStatus());
              },
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SyncStatusWidget(
                  state: state,
                  onToggleSync: () {
                    if (state is SyncConnected) {
                      context.read<SyncBloc>().add(const StopSync());
                    } else {
                      context.read<SyncBloc>().add(const StartSync());
                    }
                  },
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                
                if (state is ConflictResolutionRequired) ...[
                  _buildSection(
                    context,
                    'Conflicts Need Attention',
                    state.conflicts.map((conflict) => ConflictTile(
                      conflict: conflict,
                      onResolve: (resolution) {
                        context.read<SyncBloc>().add(
                          ResolveConflict(
                            conflictId: conflict.id,
                            resolution: resolution,
                          ),
                        );
                      },
                    )).toList(),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                ],

                if (state is SyncConnected || state is SyncDisconnected) ...[
                  _buildSection(
                    context,
                    'Connected Devices',
                    (state is SyncConnected 
                        ? (state as SyncConnected).devices 
                        : (state as SyncDisconnected).devices)
                      .map((device) => DeviceListTile(
                        device: device,
                        onRemove: device.isCurrentDevice ? null : () {
                          context.read<SyncBloc>().add(RemoveDevice(device.id));
                        },
                      )).toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        ...children,
      ],
    );
  }
}