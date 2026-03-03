import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';

class CompanyDashboard extends StatefulWidget {
  const CompanyDashboard({super.key});

  @override
  State<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    if (provider.currentUser == null || provider.currentUser is! Company) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    final company = provider.currentUser as Company;

    // RBAC: Admin sees everything, HR sees requests and contracts, Security sees limited.
    List<Widget> pages = [];
    List<NavigationDestination> destinations = [];

    if (company.role == UserRole.companyAdmin) {
      pages = [
        const DualExplorer(),
        const CompanyRequests(),
        const OngoingContracts(),
        const Center(child: Text('Admin Settings')),
      ];
      destinations = const [
        NavigationDestination(icon: Icon(Icons.search), label: 'Explore'),
        NavigationDestination(icon: Icon(Icons.assignment_outlined), label: 'Requests'),
        NavigationDestination(icon: Icon(Icons.history_edu), label: 'Contracts'),
        NavigationDestination(icon: Icon(Icons.admin_panel_settings_outlined), label: 'Admin'),
      ];
    } else if (company.role == UserRole.companyHR) {
      pages = [
        const CompanyRequests(),
        const OngoingContracts(),
      ];
      destinations = const [
        NavigationDestination(icon: Icon(Icons.assignment_outlined), label: 'Requests'),
        NavigationDestination(icon: Icon(Icons.history_edu), label: 'Contracts'),
      ];
    } else {
      pages = [
        const OngoingContracts(),
      ];
      destinations = const [
        NavigationDestination(icon: Icon(Icons.history_edu), label: 'Active Projects'),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(company.companyName),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => provider.logout()),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: destinations,
      ),
    );
  }
}

class DualExplorer extends StatelessWidget {
  const DualExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Contractors'),
              Tab(text: 'Workers'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildContractorList(provider),
                _buildWorkerList(provider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractorList(AuthProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.contractors.length,
      itemBuilder: (context, index) {
        final contractor = provider.contractors[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(contractor.profileImageUrl ?? '')),
            title: Text(contractor.companyName),
            subtitle: Text(contractor.servicesProvided.join(', ')),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }

  Widget _buildWorkerList(AuthProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.workers.length,
      itemBuilder: (context, index) {
        final worker = provider.workers[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(worker.profileImageUrl ?? '')),
            title: Text(worker.name),
            subtitle: Text(worker.skills.join(', ')),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}

class CompanyRequests extends StatelessWidget {
  const CompanyRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Company Requests View'));
  }
}

class OngoingContracts extends StatelessWidget {
  const OngoingContracts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Active Projects & Contracts'));
  }
}
