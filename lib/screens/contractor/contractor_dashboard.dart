import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';

class ContractorDashboard extends StatefulWidget {
  const ContractorDashboard({super.key});

  @override
  State<ContractorDashboard> createState() => _ContractorDashboardState();
}

class _ContractorDashboardState extends State<ContractorDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const WorkerExplorer(),
    const ContractorInbox(),
    const Center(child: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    if (provider.currentUser == null || provider.currentUser is! Contractor) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Workers',
          ),
          NavigationDestination(
            icon: Icon(Icons.mark_email_unread_outlined),
            selectedIcon: Icon(Icons.mark_email_unread),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class WorkerExplorer extends StatelessWidget {
  const WorkerExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    if (provider.currentUser == null || provider.currentUser is! Contractor) {
      return const SizedBox.shrink();
    }
    final contractor = provider.currentUser as Contractor;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Discover Workers'),
          floating: true,
          actions: [
            IconButton(icon: const Icon(Icons.logout), onPressed: () => provider.logout()),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final worker = provider.workers[index];
                final bool match = worker.skills.any((s) => contractor.servicesProvided.contains(s));

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
                              backgroundImage: NetworkImage(worker.profileImageUrl ?? ''),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(worker.name, style: Theme.of(context).textTheme.titleLarge),
                                  Text(worker.email, style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),
                            if (match)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('MATCH', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(worker.bio, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: worker.skills
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
                            provider.sendRequest(contractor.id, worker.id, 'I have a job for you!');
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
              childCount: provider.workers.length,
            ),
          ),
        ),
      ],
    );
  }
}

class ContractorInbox extends StatelessWidget {
  const ContractorInbox({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    if (provider.currentUser == null || provider.currentUser is! Contractor) {
      return const SizedBox.shrink();
    }
    final contractor = provider.currentUser as Contractor;
    final requests = provider.requests.where((r) => r.receiverId == contractor.id).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Service Requests')),
      body: requests.isEmpty
          ? const Center(child: Text('No requests yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                // For demo simplified logic
                return Card(
                  child: ListTile(
                    title: Text('Request from ${req.senderId}'),
                    subtitle: Text(req.message ?? 'No message'),
                    trailing: Text(req.status.toString().split('.').last.toUpperCase()),
                  ),
                );
              },
            ),
    );
  }
}
