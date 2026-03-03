import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({super.key});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ContractorExplorer(),
    const WorkerInbox(),
    const Center(child: Text('Profile Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    if (provider.currentUser == null || provider.currentUser is! Worker) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outline),
            selectedIcon: Icon(Icons.mail),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ContractorExplorer extends StatelessWidget {
  const ContractorExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    if (provider.currentUser == null || provider.currentUser is! Worker) {
      return const SizedBox.shrink();
    }
    final worker = provider.currentUser as Worker;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('Discover Contractors'),
          actions: [
            IconButton(icon: const Icon(Icons.logout), onPressed: () => provider.logout()),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final contractor = provider.contractors[index];
                final bool match = contractor.servicesProvided.any((s) => worker.skills.contains(s));

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(contractor.profileImageUrl ?? ''),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(contractor.companyName, style: Theme.of(context).textTheme.titleLarge),
                                  Text(contractor.name, style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),
                            if (match)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('MATCH', style: TextStyle(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(contractor.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: contractor.servicesProvided
                              .map((s) => Chip(
                                    label: Text(s, style: const TextStyle(fontSize: 12)),
                                    backgroundColor: AppTheme.surfaceColor,
                                    side: BorderSide.none,
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            provider.sendRequest(worker.id, contractor.id, 'I am interested in working with you.');
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request sent!')));
                          },
                          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                          child: const Text('Send Connection Request'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: provider.contractors.length,
            ),
          ),
        ),
      ],
    );
  }
}

class WorkerInbox extends StatelessWidget {
  const WorkerInbox({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    if (provider.currentUser == null || provider.currentUser is! Worker) {
      return const SizedBox.shrink();
    }
    final worker = provider.currentUser as Worker;
    final requests = provider.requests.where((r) => r.receiverId == worker.id).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Connection Requests')),
      body: requests.isEmpty
          ? const Center(child: Text('No requests yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                final sender = provider.contractors.firstWhere((c) => c.id == req.senderId);

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(sender.profileImageUrl ?? '')),
                    title: Text(sender.companyName),
                    subtitle: Text(req.message ?? 'Wants to connect'),
                    trailing: req.status == RequestStatus.pending
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: () => provider.updateRequestStatus(req.id, RequestStatus.accepted),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () => provider.updateRequestStatus(req.id, RequestStatus.rejected),
                              ),
                            ],
                          )
                        : Text(req.status.toString().split('.').last.toUpperCase()),
                  ),
                );
              },
            ),
    );
  }
}
