import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/models/mock_data.dart';
import '../../core/providers/request_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class RequestDetailScreen extends StatelessWidget {
  final String requestId;
  const RequestDetailScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final request = MockData.hiringRequests.firstWhere((r) => r.id == requestId);
    final reqProv = context.read<RequestProvider>();
    final isPending = request.status == RequestStatus.pending;

    Color statusColor;
    String statusLabel;
    switch (request.status) {
      case RequestStatus.accepted: statusColor = AppTheme.success; statusLabel = 'Accepted'; break;
      case RequestStatus.rejected: statusColor = AppTheme.error; statusLabel = 'Rejected'; break;
      default: statusColor = AppTheme.warning; statusLabel = 'Pending';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Request Details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Status banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Row(children: [
              Icon(isPending ? Icons.hourglass_top_rounded : request.status == RequestStatus.accepted ? Icons.check_circle_rounded : Icons.cancel_rounded, color: statusColor),
              const SizedBox(width: 10),
              Text('Status: $statusLabel', style: TextStyle(fontWeight: FontWeight.w700, color: statusColor, fontSize: 15)),
            ]),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('From Company', style: Theme.of(context).textTheme.labelMedium),
                Text(request.companyName, style: Theme.of(context).textTheme.displaySmall),
                const Divider(height: 24),
                _DetailRow('Skill Required', request.skillRequired),
                _DetailRow('Workers Required', '${request.workersRequired}'),
                _DetailRow('Standard Wage', '₹${request.standardWage.toInt()}/day'),
                _DetailRow('Offered Wage', '₹${request.offeredWage.toInt()}/day'),
                _DetailRow('Duration', request.duration.name.toUpperCase()),
                _DetailRow('Work Location', request.workLocation),
                _DetailRow('Start Date', DateFormat('d MMMM y').format(request.startDate)),
                if (request.additionalRequirements != null)
                  _DetailRow('Requirements', request.additionalRequirements!),
                _DetailRow('Requested On', DateFormat('d MMM y, h:mm a').format(request.createdAt)),
              ]),
            ),
          ),
          if (isPending) ...[
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: AppButton(
                  label: 'Accept Request',
                  icon: Icons.check_rounded,
                  style: AppButtonStyle.accent,
                  onTap: () {
                    reqProv.updateRequestStatus(requestId, RequestStatus.accepted);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Accepted! Email sent to company.'), backgroundColor: AppTheme.success));
                    context.pop();
                  },
                ),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: AppButton(
                  label: 'Reject Request',
                  icon: Icons.close_rounded,
                  style: AppButtonStyle.danger,
                  onTap: () {
                    reqProv.updateRequestStatus(requestId, RequestStatus.rejected);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request rejected.'), backgroundColor: AppTheme.error));
                    context.pop();
                  },
                ),
              ),
            ]),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          width: 130,
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600))),
      ]),
    );
  }
}
