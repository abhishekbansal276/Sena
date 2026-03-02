import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/models/mock_data.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/request_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class WorkerDashboardScreen extends StatelessWidget {
  const WorkerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final reqProv = context.watch<RequestProvider>();
    final worker = auth.currentWorker;
    if (worker == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final myRequests = reqProv.requestsForWorker(worker.id);
    final pending = myRequests.where((r) => r.status == RequestStatus.pending).length;
    final unread = MockData.notifications.where((n) => !n.isRead).length;
    final avail = worker.availability == AvailabilityStatus.available;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GradientHeader(
              greeting: 'Hello there,',
              name: worker.fullName,
              unreadCount: unread,
              onNotificationTap: () => context.push('/notifications'),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Availability toggle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: avail ? AppTheme.success.withOpacity(0.1) : AppTheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: avail ? AppTheme.success.withOpacity(0.3) : AppTheme.error.withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    Icon(avail ? Icons.work_rounded : Icons.work_off_rounded, color: avail ? AppTheme.success : AppTheme.error),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        avail ? 'I am Available for Work' : 'Currently Unavailable',
                        style: TextStyle(fontWeight: FontWeight.w600, color: avail ? AppTheme.success : AppTheme.error),
                      ),
                    ),
                    Switch.adaptive(value: avail, onChanged: (_) => auth.toggleWorkerAvailability(), activeColor: AppTheme.success),
                  ]),
                ),
                const SizedBox(height: 20),
                // Quick stats
                Row(children: [
                  Expanded(child: StatCard(label: 'Total Requests', value: '${myRequests.length}', icon: Icons.inbox_outlined, color: const Color(0xFF10B981))),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(label: 'Pending', value: '$pending', icon: Icons.hourglass_top_rounded, color: AppTheme.warning)),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(label: 'Skills', value: '${worker.skills.length}', icon: Icons.construction_outlined, color: AppTheme.primary)),
                ]),
                const SizedBox(height: 20),
                // Profile card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      UserAvatar(name: worker.fullName, radius: 30),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(worker.fullName, style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 4),
                          Text('${worker.city}, ${worker.state}', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Wrap(spacing: 4, children: worker.skills.take(3).map((s) =>
                            Chip(label: Text(s), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.zero, labelStyle: const TextStyle(fontSize: 11))).toList()),
                        ]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                        onPressed: () => context.push('/worker/profile'),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 20),
                // Requests
                SectionHeader(title: 'Hiring Requests', action: 'See All', onAction: () => context.push('/worker/requests')),
                const SizedBox(height: 8),
                if (myRequests.isEmpty)
                  const EmptyState(message: 'No hiring requests yet.\nMake sure your profile is complete and availability is ON.', icon: Icons.inbox_outlined)
                else
                  ...myRequests.take(3).map((r) {
                    Color c;
                    String lbl;
                    switch (r.status) {
                      case RequestStatus.accepted: c = AppTheme.success; lbl = 'Accepted'; break;
                      case RequestStatus.rejected: c = AppTheme.error; lbl = 'Rejected'; break;
                      default: c = AppTheme.warning; lbl = 'Pending';
                    }
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const CircleAvatar(backgroundColor: AppTheme.accent, child: Icon(Icons.business_rounded, color: Colors.white, size: 18)),
                        title: Text(r.companyName, style: Theme.of(context).textTheme.headlineSmall),
                        subtitle: Text('${r.skillRequired} • ₹${r.offeredWage.toInt()}/day'),
                        trailing: StatusChip(label: lbl, color: c),
                        onTap: () => context.push('/request-detail/${r.id}'),
                      ),
                    );
                  }),
                const SizedBox(height: 24),
                AppButton(label: 'Logout', style: AppButtonStyle.secondary, icon: Icons.logout, onTap: () {
                  context.read<AuthProvider>().logout();
                  context.go('/role-select');
                }),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
