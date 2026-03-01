import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/models/mock_data.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/request_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class CompanyDashboardScreen extends StatelessWidget {
  const CompanyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final reqProv = context.watch<RequestProvider>();
    final company = auth.currentCompany;
    if (company == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final myRequests = reqProv.requestsForCompany(company.id);
    final pending = myRequests.where((r) => r.status == RequestStatus.pending).length;
    final accepted = myRequests.where((r) => r.status == RequestStatus.accepted).length;
    final unread = MockData.notifications.where((n) => !n.isRead).length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GradientHeader(
              greeting: 'Welcome back,',
              name: company.companyName,
              unreadCount: unread,
              onNotificationTap: () => context.push('/notifications'),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats row
                Row(children: [
                  Expanded(child: StatCard(label: 'Sent Requests', value: '${myRequests.length}', icon: Icons.send_rounded, color: AppTheme.primary)),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(label: 'Pending', value: '$pending', icon: Icons.hourglass_top_rounded, color: AppTheme.warning)),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(label: 'Accepted', value: '$accepted', icon: Icons.check_circle_outline, color: AppTheme.success)),
                ]),
                const SizedBox(height: 28),
                // Quick actions
                SectionHeader(title: 'Quick Actions'),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _QuickActionCard(icon: Icons.search_rounded, label: 'Browse Workers', color: AppTheme.primary, onTap: () => context.go('/company/browse'))),
                  const SizedBox(width: 12),
                  Expanded(child: _QuickActionCard(icon: Icons.add_circle_outline_rounded, label: 'New Request', color: AppTheme.success, onTap: () => context.go('/company/create-request'))),
                  const SizedBox(width: 12),
                  Expanded(child: _QuickActionCard(icon: Icons.history_rounded, label: 'My Requests', color: AppTheme.warning, onTap: () => context.go('/company/sent-requests'))),
                ]),
                const SizedBox(height: 28),
                // Recent requests
                SectionHeader(title: 'Recent Requests', action: 'See All', onAction: () => context.go('/company/sent-requests')),
                const SizedBox(height: 8),
                if (myRequests.isEmpty)
                  const EmptyState(message: 'No hiring requests yet.\nTap "New Request" to get started.', icon: Icons.work_off_outlined)
                else
                  ...myRequests.take(3).map((r) => _RequestSummaryCard(request: r)),
                const SizedBox(height: 24),
                // Logout
                AppButton(
                  label: 'Logout',
                  style: AppButtonStyle.secondary,
                  icon: Icons.logout,
                  onTap: () {
                    context.read<AuthProvider>().logout();
                    context.go('/role-select');
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/company/browse'),
        icon: const Icon(Icons.search_rounded),
        label: const Text('Browse Workers'),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionCard({required this.icon, required this.label, required this.color, required this.onTap});

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
          Text(label, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ]),
      ),
    );
  }
}

class _RequestSummaryCard extends StatelessWidget {
  final HiringRequest request;
  const _RequestSummaryCard({required this.request});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;
    switch (request.status) {
      case RequestStatus.accepted: statusColor = AppTheme.success; statusLabel = 'Accepted'; break;
      case RequestStatus.rejected: statusColor = AppTheme.error; statusLabel = 'Rejected'; break;
      default: statusColor = AppTheme.warning; statusLabel = 'Pending';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.work_outline, color: AppTheme.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(request.skillRequired, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 2),
              Text('${request.workersRequired} worker(s) • ${DateFormat('d MMM y').format(request.startDate)}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ]),
          ),
          StatusChip(label: statusLabel, color: statusColor),
        ]),
      ),
    );
  }
}
