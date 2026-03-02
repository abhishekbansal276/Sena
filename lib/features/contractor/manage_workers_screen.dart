import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/worker_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class ManageWorkersScreen extends StatelessWidget {
  const ManageWorkersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contractor = context.watch<AuthProvider>().currentContractor;
    if (contractor == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final workers = context.watch<WorkerProvider>().workersUnderContractor(contractor.id);

    return Scaffold(
      appBar: AppBar(title: const Text('My Workers')),
      body: workers.isEmpty
          ? const EmptyState(message: 'No workers yet.\nTap + to add your first worker.', icon: Icons.group_off_outlined)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: workers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final w = workers[i];
                final avail = w.availability == AvailabilityStatus.available;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      UserAvatar(name: w.fullName, radius: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(w.fullName, style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 4),
                          Text(w.skills.take(2).join(', '), style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Text('${w.city}, ${w.state}', style: Theme.of(context).textTheme.labelMedium),
                        ]),
                      ),
                      Column(children: [
                        StatusChip(label: avail ? 'Available' : 'Busy', color: avail ? AppTheme.success : AppTheme.error),
                        const SizedBox(height: 8),
                        Switch.adaptive(
                          value: avail,
                          onChanged: (v) {
                            context.read<WorkerProvider>().updateWorkerAvailability(
                              w.id,
                              v ? AvailabilityStatus.available : AvailabilityStatus.unavailable,
                            );
                          },
                          activeColor: AppTheme.success,
                        ),
                      ]),
                    ]),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/contractor/add-worker'),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Add Worker'),
      ),
    );
  }
}
