import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/models/mock_data.dart';
import '../../shared/widgets/app_widgets.dart';

class ContractorProfileScreen extends StatelessWidget {
  final String contractorId;
  const ContractorProfileScreen({super.key, required this.contractorId});

  @override
  Widget build(BuildContext context) {
    final contractor =
        MockData.contractors.firstWhere((c) => c.id == contractorId);
    final workers =
        MockData.workers.where((w) => w.contractorId == contractorId).toList();
    final avail = contractor.availability == AvailabilityStatus.available;
    final availCount = workers
        .where((w) => w.availability == AvailabilityStatus.available)
        .length;

    return Scaffold(
      appBar:
          AppBar(title: Text(contractor.businessName ?? contractor.fullName)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryLight]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                UserAvatar(name: contractor.fullName, radius: 40),
                const SizedBox(height: 12),
                Text(contractor.businessName ?? contractor.fullName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                Text(contractor.fullName,
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  StatusChip(
                      label: avail ? 'Available' : 'Busy',
                      color: avail ? AppTheme.success : AppTheme.error),
                  const SizedBox(width: 8),
                  StatusChip(
                      label: '${workers.length} Workers',
                      color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  StatusChip(label: '$availCount Free', color: AppTheme.accent),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                _DetailRow(Icons.location_on_outlined,
                    '${contractor.city}, ${contractor.state}'),
                _DetailRow(Icons.phone_outlined, contractor.phone),
                _DetailRow(Icons.email_outlined, contractor.email),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          SectionHeader(
              title:
                  'Workers ($availCount Available / ${workers.length} Total)'),
          const SizedBox(height: 8),
          if (workers.isEmpty)
            const EmptyState(
                message: 'No workers listed under this contractor',
                icon: Icons.group_off),
          ...workers.map((w) {
            final wAvail = w.availability == AvailabilityStatus.available;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: UserAvatar(name: w.fullName, radius: 22),
                title: Text(w.fullName,
                    style: Theme.of(context).textTheme.headlineSmall),
                subtitle: Text(w.skills.join(', ')),
                trailing: StatusChip(
                    label: wAvail ? 'Available' : 'Busy',
                    color: wAvail ? AppTheme.success : AppTheme.error),
                onTap: () => context.push('/company/worker/${w.id}'),
              ),
            );
          }),
          const SizedBox(height: 20),
          AppButton(
            label: 'Send Hiring Request to Contractor',
            icon: Icons.send_rounded,
            onTap: () => context.push('/company/create-request'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DetailRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, color: AppTheme.primary, size: 18),
        const SizedBox(width: 10),
        Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ]),
    );
  }
}
