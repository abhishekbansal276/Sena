import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/request_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class WorkerRequestsScreen extends StatelessWidget {
  const WorkerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final worker = context.watch<AuthProvider>().currentWorker;
    if (worker == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final requests = context.watch<RequestProvider>().requestsForWorker(worker.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Hiring Requests')),
      body: requests.isEmpty
          ? const EmptyState(message: 'No hiring requests received yet', icon: Icons.inbox_outlined)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _WorkerRequestCard(request: requests[i]),
            ),
    );
  }
}

class _WorkerRequestCard extends StatelessWidget {
  final HiringRequest request;
  const _WorkerRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final reqProv = context.read<RequestProvider>();
    final isPending = request.status == RequestStatus.pending;

    Color statusColor;
    String statusLabel;
    switch (request.status) {
      case RequestStatus.accepted: statusColor = AppTheme.success; statusLabel = 'Accepted'; break;
      case RequestStatus.rejected: statusColor = AppTheme.error; statusLabel = 'Rejected'; break;
      default: statusColor = AppTheme.warning; statusLabel = 'Pending';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(request.companyName, style: Theme.of(context).textTheme.headlineMedium),
                Text(request.skillRequired, style: Theme.of(context).textTheme.bodyMedium),
              ]),
            ),
            StatusChip(label: statusLabel, color: statusColor),
          ]),
          const Divider(height: 20),
          Wrap(spacing: 16, runSpacing: 8, children: [
            _Info(Icons.currency_rupee, '₹${request.offeredWage.toInt()}/day'),
            _Info(Icons.timer_outlined, request.duration.name.toUpperCase()),
            _Info(Icons.location_on_outlined, request.workLocation),
          ]),
          if (request.additionalRequirements != null) ...[
            const SizedBox(height: 8),
            Text('Note: ${request.additionalRequirements}', style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (isPending) ...[
            const SizedBox(height: 14),
            Row(children: [
              Expanded(
                child: AppButton(
                  label: 'Accept',
                  style: AppButtonStyle.accent,
                  icon: Icons.check_rounded,
                  onTap: () {
                    reqProv.updateRequestStatus(request.id, RequestStatus.accepted);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Accepted! Company has been notified.'), backgroundColor: AppTheme.success));
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Reject',
                  style: AppButtonStyle.danger,
                  icon: Icons.close_rounded,
                  onTap: () {
                    reqProv.updateRequestStatus(request.id, RequestStatus.rejected);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request rejected.'), backgroundColor: AppTheme.error));
                  },
                ),
              ),
            ]),
          ],
        ]),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Info(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: AppTheme.textSecondary),
      const SizedBox(width: 4),
      Text(text, style: Theme.of(context).textTheme.bodyMedium),
    ]);
  }
}
