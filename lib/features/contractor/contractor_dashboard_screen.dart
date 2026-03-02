import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/models/mock_data.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/request_provider.dart';
import '../../core/providers/worker_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class ContractorDashboardScreen extends StatelessWidget {
  const ContractorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final reqProv = context.watch<RequestProvider>();
    final workerProv = context.watch<WorkerProvider>();
    final contractor = auth.currentContractor;
    if (contractor == null)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final myWorkers = workerProv.workersUnderContractor(contractor.id);
    final availWorkers = myWorkers
        .where((w) => w.availability == AvailabilityStatus.available)
        .length;
    final myRequests = reqProv.requestsForContractor(contractor.id);
    final pendingReqs =
        myRequests.where((r) => r.status == RequestStatus.pending).length;
    final unread = MockData.notifications.where((n) => !n.isRead).length;
    final avail = contractor.availability == AvailabilityStatus.available;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GradientHeader(
              greeting: 'Welcome back,',
              name: contractor.businessName ?? contractor.fullName,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: avail
                        ? AppTheme.success.withOpacity(0.1)
                        : AppTheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: avail
                            ? AppTheme.success.withOpacity(0.3)
                            : AppTheme.error.withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    Icon(
                        avail
                            ? Icons.check_circle_outlined
                            : Icons.cancel_outlined,
                        color: avail ? AppTheme.success : AppTheme.error),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        avail
                            ? 'You are currently Available'
                            : 'You are currently Unavailable',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: avail ? AppTheme.success : AppTheme.error),
                      ),
                    ),
                    Switch(
                      value: avail,
                      onChanged: (_) => auth.toggleContractorAvailability(),
                      activeThumbColor: AppTheme.success,
                    ),
                  ]),
                ),
                const SizedBox(height: 20),
                // Stats
                Row(children: [
                  Expanded(
                      child: StatCard(
                          label: 'Total Workers',
                          value: '${myWorkers.length}',
                          icon: Icons.group_outlined,
                          color: const Color(0xFF8B5CF6))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: StatCard(
                          label: 'Available',
                          value: '$availWorkers',
                          icon: Icons.check_circle_outline,
                          color: AppTheme.success)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: StatCard(
                          label: 'Pending Req.',
                          value: '$pendingReqs',
                          icon: Icons.hourglass_top_rounded,
                          color: AppTheme.warning)),
                ]),
                const SizedBox(height: 28),
                // Quick actions
                const SectionHeader(title: 'Quick Actions'),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                      child: _ActionCard(
                          icon: Icons.group_outlined,
                          label: 'My Workers',
                          color: const Color(0xFF8B5CF6),
                          onTap: () => context.go('/contractor/workers'))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _ActionCard(
                          icon: Icons.inbox_rounded,
                          label: 'Requests',
                          color: AppTheme.warning,
                          onTap: () => context.go('/contractor/requests'))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _ActionCard(
                          icon: Icons.person_add_outlined,
                          label: 'Add Worker',
                          color: AppTheme.success,
                          onTap: () => context.go('/contractor/add-worker'))),
                ]),
                const SizedBox(height: 28),
                // Recent requests
                SectionHeader(
                    title: 'Incoming Requests',
                    action: 'See All',
                    onAction: () => context.go('/contractor/requests')),
                const SizedBox(height: 8),
                if (myRequests.isEmpty)
                  const EmptyState(
                      message: 'No hiring requests yet',
                      icon: Icons.inbox_outlined)
                else
                  ...myRequests.take(3).map((r) => _RequestMini(request: r)),
                const SizedBox(height: 24),
                AppButton(
                    label: 'Logout',
                    style: AppButtonStyle.secondary,
                    icon: Icons.logout,
                    onTap: () {
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

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ]),
      ),
    );
  }
}

class _RequestMini extends StatelessWidget {
  final HiringRequest request;
  const _RequestMini({required this.request});

  @override
  Widget build(BuildContext context) {
    Color c;
    String lbl;
    switch (request.status) {
      case RequestStatus.accepted:
        c = AppTheme.success;
        lbl = 'Accepted';
        break;
      case RequestStatus.rejected:
        c = AppTheme.error;
        lbl = 'Rejected';
        break;
      default:
        c = AppTheme.warning;
        lbl = 'Pending';
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
            backgroundColor: AppTheme.accent,
            child: Icon(Icons.business_rounded, color: Colors.white, size: 18)),
        title: Text(request.companyName,
            style: Theme.of(context).textTheme.headlineSmall),
        subtitle: Text(
            '${request.workersRequired} ${request.skillRequired}(s) • ₹${request.offeredWage.toInt()}/day'),
        trailing: StatusChip(label: lbl, color: c),
        onTap: () => context.push('/request-detail/${request.id}'),
      ),
    );
  }
}
