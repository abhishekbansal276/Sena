import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/request_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class SentRequestsScreen extends StatelessWidget {
  const SentRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final company = context.watch<AuthProvider>().currentCompany;
    final reqProv = context.watch<RequestProvider>();
    if (company == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final requests = reqProv.requestsForCompany(company.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Sent Requests')),
      body: requests.isEmpty
          ? const EmptyState(message: 'No requests sent yet.', icon: Icons.send_outlined)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 0),
              itemBuilder: (_, i) => _SentRequestCard(request: requests[i]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/company/create-request'),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _SentRequestCard extends StatelessWidget {
  final HiringRequest request;
  const _SentRequestCard({required this.request});

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(request.skillRequired, style: Theme.of(context).textTheme.headlineMedium),
            ),
            StatusChip(label: statusLabel, color: statusColor),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 16, children: [
            _Info(Icons.group_outlined, '${request.workersRequired} workers'),
            _Info(Icons.calendar_today_outlined, DateFormat('d MMM y').format(request.startDate)),
            _Info(Icons.timer_outlined, request.duration.name.toUpperCase()),
          ]),
          const SizedBox(height: 8),
          _Info(Icons.location_on_outlined, request.workLocation),
          const SizedBox(height: 8),
          Row(children: [
            _Info(Icons.currency_rupee, 'Std: ₹${request.standardWage.toInt()}'),
            const SizedBox(width: 16),
            _Info(Icons.local_offer_outlined, 'Offered: ₹${request.offeredWage.toInt()}'),
          ]),
          if (request.additionalRequirements != null) ...[
            const SizedBox(height: 8),
            Text('Note: ${request.additionalRequirements}', style: Theme.of(context).textTheme.bodyMedium),
          ],
          const SizedBox(height: 8),
          Text('Sent on ${DateFormat('d MMM y, h:mm a').format(request.createdAt)}',
              style: Theme.of(context).textTheme.labelMedium),
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
