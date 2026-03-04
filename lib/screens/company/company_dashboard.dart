import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/app_models.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class CompanyDashboard extends StatefulWidget {
  const CompanyDashboard({super.key});
  @override
  State<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final company = user is Company ? user : null;

    final pages = [
      _HomeTab(company: company, auth: auth),
      _ContractorsTab(auth: auth),
      _WorkersTab(auth: auth),
      _RequestsTab(auth: auth, company: company),
      _ProfileTab(company: company, auth: auth),
    ];

    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: IndexedStack(index: _selectedTab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (i) => setState(() => _selectedTab = i),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.handshake_outlined),
            selectedIcon: Icon(Icons.handshake_rounded),
            label: 'Contractors',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group_rounded),
            label: 'Workers',
          ),
          NavigationDestination(
            icon: Icon(Icons.post_add_outlined),
            selectedIcon: Icon(Icons.post_add_rounded),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// HOME TAB
// ══════════════════════════════════════════════════════════
class _HomeTab extends StatelessWidget {
  final Company? company;
  final AuthProvider auth;
  const _HomeTab({required this.company, required this.auth});

  @override
  Widget build(BuildContext context) {
    final totalWorkers = auth.workers.length;
    final availableWorkers = auth.workers.where((w) => w.isAvailable).length;
    final totalContractors = auth.contractors.length;
    final sentRequests = auth.workforceRequests.length;
    final activeRequests = auth.workforceRequests
        .where((r) => r.status == RequestStatus.accepted)
        .length;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          backgroundColor: AppTheme.companyColor,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.companyGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white24,
                        child: Text(
                          (company?.companyName ?? 'C')
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Company Portal',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              company?.companyName ?? 'My Company',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              company?.industry ?? 'General',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              onPressed: () => context.read<AuthProvider>().logout(),
            ),
          ],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        'Contractors',
                        '$totalContractors',
                        AppTheme.companyColor,
                        Icons.handshake_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        'Total\nWorkers',
                        '$totalWorkers',
                        AppTheme.workerColor,
                        Icons.group_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        'Available',
                        '$availableWorkers',
                        AppTheme.successColor,
                        Icons.check_circle_outline_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        'Requests\nSent',
                        '$sentRequests',
                        AppTheme.contractorColor,
                        Icons.send_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        'Active\nContracts',
                        '$activeRequests',
                        const Color(0xFF7C3AED),
                        Icons.verified_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        'Pending',
                        '${auth.workforceRequests.where((r) => r.status == RequestStatus.pending).length}',
                        AppTheme.warningColor,
                        Icons.pending_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick contractor overview
                _SectionHeader(title: 'Top Contractors'),
                const SizedBox(height: 12),
                ...auth.contractors.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ContractorTile(
                      contractor: c,
                      workerCount: auth.workers
                          .where((w) => c.linkedWorkerIds.contains(w.id))
                          .length,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Recent requests
                _SectionHeader(
                  title: 'Recent Requests',
                  actionLabel: 'See All',
                ),
                const SizedBox(height: 12),
                ...auth.workforceRequests
                    .take(2)
                    .map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _RequestSummaryTile(request: r),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
// CONTRACTORS TAB
// ══════════════════════════════════════════════════════════
class _ContractorsTab extends StatelessWidget {
  final AuthProvider auth;
  const _ContractorsTab({required this.auth});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'Contractor Portfolios',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textColor,
            ),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          pinned: true,
          elevation: 0,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((_, i) {
              final c = auth.contractors[i];
              final workerCount = auth.workers
                  .where((w) => c.linkedWorkerIds.contains(w.id))
                  .length;
              final availableCount = auth.workers
                  .where(
                    (w) => c.linkedWorkerIds.contains(w.id) && w.isAvailable,
                  )
                  .length;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ContractorDetailCard(
                  contractor: c,
                  workerCount: workerCount,
                  availableCount: availableCount,
                ),
              );
            }, childCount: auth.contractors.length),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
// WORKERS TAB
// ══════════════════════════════════════════════════════════
class _WorkersTab extends StatelessWidget {
  final AuthProvider auth;
  const _WorkersTab({required this.auth});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'All Workers',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textColor,
            ),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          pinned: true,
          elevation: 0,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group by contractor
                ...auth.contractors.map((contractor) {
                  final cWorkers = auth.workers
                      .where((w) => contractor.linkedWorkerIds.contains(w.id))
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppTheme.contractorGradient,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                contractor.companyName,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${cWorkers.length} workers',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.mutedTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...cWorkers.map(
                        (w) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _CompanyWorkerCard(worker: w),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
// REQUESTS TAB
// ══════════════════════════════════════════════════════════
class _RequestsTab extends StatefulWidget {
  final AuthProvider auth;
  final Company? company;
  const _RequestsTab({required this.auth, required this.company});
  @override
  State<_RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<_RequestsTab> {
  bool _showForm = false;
  final _skillsController = TextEditingController();
  final _budgetController = TextEditingController();
  final _durationController = TextEditingController();
  final _locationController = TextEditingController();
  int _workerCount = 2;

  void _submitRequest() {
    if (_skillsController.text.isEmpty || _budgetController.text.isEmpty) {
      return;
    }
    final skills = _skillsController.text
        .split(',')
        .map((s) => s.trim())
        .toList();
    widget.auth.addWorkforceRequest(
      WorkforceRequest(
        id: 'wr${DateTime.now().millisecondsSinceEpoch}',
        companyId: widget.company?.id ?? 'comp',
        companyName: widget.company?.companyName ?? 'My Company',
        requiredSkills: skills,
        workerCount: _workerCount,
        duration: _durationController.text.isEmpty
            ? '1 month'
            : _durationController.text,
        budget: _budgetController.text,
        location: _locationController.text.isEmpty
            ? 'Not specified'
            : _locationController.text,
      ),
    );
    setState(() {
      _showForm = false;
    });
    _skillsController.clear();
    _budgetController.clear();
    _durationController.clear();
    _locationController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Workforce request submitted!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final requests = widget.auth.workforceRequests;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'Job Requests',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textColor,
            ),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          pinned: true,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton.icon(
                onPressed: () => setState(() => _showForm = !_showForm),
                icon: Icon(
                  _showForm ? Icons.close_rounded : Icons.add_rounded,
                  size: 16,
                ),
                label: Text(_showForm ? 'Cancel' : 'New Request'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.companyColor,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Create request form
                if (_showForm) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppTheme.glassCardWithAccent(
                      AppTheme.companyColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Workforce Request',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _skillsController,
                          decoration: const InputDecoration(
                            labelText: 'Required Skills (comma separated)',
                            prefixIcon: Icon(Icons.build_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _durationController,
                                decoration: const InputDecoration(
                                  labelText: 'Duration',
                                  prefixIcon: Icon(Icons.schedule_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _budgetController,
                                decoration: const InputDecoration(
                                  labelText: 'Budget',
                                  prefixIcon: Icon(Icons.payments_outlined),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'Location',
                            prefixIcon: Icon(Icons.location_on_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Number of Workers: $_workerCount',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textColor,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline_rounded,
                                  ),
                                  color: AppTheme.companyColor,
                                  onPressed: () => setState(() {
                                    if (_workerCount > 1) _workerCount--;
                                  }),
                                ),
                                Text(
                                  '$_workerCount',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline_rounded,
                                  ),
                                  color: AppTheme.companyColor,
                                  onPressed: () =>
                                      setState(() => _workerCount++),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitRequest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.companyColor,
                            ),
                            child: Text(
                              'Submit Request',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Requests list
                _SectionHeader(title: 'All Requests (${requests.length})'),
                const SizedBox(height: 12),
                if (requests.isEmpty)
                  _EmptyState(
                    icon: Icons.post_add_outlined,
                    message:
                        'No requests yet. Tap "+ New Request" to create one.',
                  )
                else
                  ...requests.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _RequestDetailCard(request: r, auth: widget.auth),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
// PROFILE TAB
// ══════════════════════════════════════════════════════════
class _ProfileTab extends StatelessWidget {
  final Company? company;
  final AuthProvider auth;
  const _ProfileTab({required this.company, required this.auth});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'Company Profile',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textColor,
            ),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          pinned: true,
          elevation: 0,
          actions: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_rounded, size: 16),
              label: const Text('Edit'),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppTheme.companyGradient,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          (company?.companyName ?? 'C')
                              .substring(0, 1)
                              .toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        company?.companyName ?? 'My Company',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.companyGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          company?.industry ?? 'General',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.glassCard,
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Admin',
                        value: company?.name ?? '',
                      ),
                      const Divider(height: 20),
                      _InfoRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: company?.email ?? '',
                      ),
                      const Divider(height: 20),
                      _InfoRow(
                        icon: Icons.business_outlined,
                        label: 'Industry',
                        value: company?.industry ?? 'General',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.glassCard,
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.handshake_outlined,
                        label: 'Contractors',
                        value: '${auth.contractors.length} registered',
                      ),
                      const Divider(height: 20),
                      _InfoRow(
                        icon: Icons.group_outlined,
                        label: 'Total Workers',
                        value: '${auth.workers.length} in network',
                      ),
                      const Divider(height: 20),
                      _InfoRow(
                        icon: Icons.post_add_outlined,
                        label: 'Requests',
                        value: '${auth.workforceRequests.length} sent',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => auth.logout(),
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFEF4444),
                    ),
                    label: Text(
                      'Sign Out',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFEF4444),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFEF4444)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
// SHARED WIDGETS
// ══════════════════════════════════════════════════════════

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  const _StatCard(this.label, this.value, this.color, this.icon);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppTheme.borderColor),
      boxShadow: AppTheme.cardShadow,
    ),
    child: Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppTheme.mutedTextColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class _ContractorTile extends StatelessWidget {
  final Contractor contractor;
  final int workerCount;
  const _ContractorTile({required this.contractor, required this.workerCount});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: AppTheme.glassCard,
    child: Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFE0F7FA),
          backgroundImage: contractor.profileImageUrl != null
              ? NetworkImage(contractor.profileImageUrl!)
              : null,
          child: contractor.profileImageUrl == null
              ? Text(
                  contractor.name.substring(0, 1),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppTheme.contractorColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contractor.companyName,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.textColor,
                ),
              ),
              Text(
                '$workerCount workers · ${contractor.rating} ★',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: AppTheme.mutedTextColor),
      ],
    ),
  );
}

class _ContractorDetailCard extends StatelessWidget {
  final Contractor contractor;
  final int workerCount, availableCount;
  const _ContractorDetailCard({
    required this.contractor,
    required this.workerCount,
    required this.availableCount,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: AppTheme.glassCard,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFE0F7FA),
              backgroundImage: contractor.profileImageUrl != null
                  ? NetworkImage(contractor.profileImageUrl!)
                  : null,
              child: contractor.profileImageUrl == null
                  ? Text(
                      contractor.name.substring(0, 1),
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        color: AppTheme.contractorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contractor.companyName,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppTheme.textColor,
                    ),
                  ),
                  Text(
                    contractor.name,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${contractor.rating}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textColor,
                        ),
                      ),
                      Text(
                        '  ·  $workerCount workers',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.mutedTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          contractor.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppTheme.secondaryTextColor,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$availableCount Available',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.successColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${workerCount - availableCount} Engaged',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.warningColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: contractor.servicesProvided
              .map(
                (s) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.contractorColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    s,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.contractorColor,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}

class _CompanyWorkerCard extends StatelessWidget {
  final Worker worker;
  const _CompanyWorkerCard({required this.worker});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: AppTheme.glassCard,
    child: Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppTheme.primarySubtle,
          backgroundImage: worker.profileImageUrl != null
              ? NetworkImage(worker.profileImageUrl!)
              : null,
          child: worker.profileImageUrl == null
              ? Text(
                  worker.name.substring(0, 1),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppTheme.workerColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                worker.name,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.textColor,
                ),
              ),
              Text(
                worker.skills.take(2).join(', '),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
              Text(
                worker.location,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.mutedTextColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: worker.isAvailable
                ? AppTheme.successColor.withValues(alpha: 0.1)
                : AppTheme.warningColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            worker.isAvailable ? 'Free' : 'Busy',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: worker.isAvailable
                  ? AppTheme.successColor
                  : AppTheme.warningColor,
            ),
          ),
        ),
      ],
    ),
  );
}

class _RequestDetailCard extends StatelessWidget {
  final WorkforceRequest request;
  final AuthProvider auth;
  const _RequestDetailCard({required this.request, required this.auth});

  Color _statusColor(RequestStatus s) {
    switch (s) {
      case RequestStatus.accepted:
        return AppTheme.successColor;
      case RequestStatus.rejected:
        return const Color(0xFFEF4444);
      default:
        return AppTheme.warningColor;
    }
  }

  String _statusLabel(RequestStatus s) {
    switch (s) {
      case RequestStatus.accepted:
        return 'Accepted';
      case RequestStatus.rejected:
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _statusColor(request.status);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${request.workerCount} Workers Needed',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppTheme.textColor,
                      ),
                    ),
                    Text(
                      request.companyName,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel(request.status),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: c,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: request.requiredSkills
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.companyColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      s,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.companyColor,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MetaItem(icon: Icons.schedule_outlined, label: request.duration),
              const SizedBox(width: 14),
              _MetaItem(icon: Icons.payments_outlined, label: request.budget),
              const SizedBox(width: 14),
              _MetaItem(
                icon: Icons.location_on_outlined,
                label: request.location,
              ),
            ],
          ),
          if (request.status == RequestStatus.accepted) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  auth.updateWorkforceRequestStatus(
                    request.id,
                    RequestStatus.completed,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.companyColor,
                  minimumSize: const Size(0, 42),
                ),
                child: Text(
                  'Mark Complete',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RequestSummaryTile extends StatelessWidget {
  final WorkforceRequest request;
  const _RequestSummaryTile({required this.request});
  Color get _c {
    switch (request.status) {
      case RequestStatus.accepted:
        return AppTheme.successColor;
      case RequestStatus.rejected:
        return const Color(0xFFEF4444);
      default:
        return AppTheme.warningColor;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: AppTheme.glassCard,
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${request.workerCount} Workers · ${request.requiredSkills.first}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppTheme.textColor,
                ),
              ),
              Text(
                '${request.budget} · ${request.duration}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.mutedTextColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _c.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            request.status.name[0].toUpperCase() +
                request.status.name.substring(1),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _c,
            ),
          ),
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: AppTheme.companyColor),
      const SizedBox(width: 12),
      Text(
        label,
        style: GoogleFonts.inter(fontSize: 13, color: AppTheme.mutedTextColor),
      ),
      const Spacer(),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textColor,
          ),
        ),
      ),
    ],
  );
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaItem({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: AppTheme.mutedTextColor),
      const SizedBox(width: 4),
      Text(
        label,
        style: GoogleFonts.inter(fontSize: 12, color: AppTheme.mutedTextColor),
      ),
    ],
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  const _SectionHeader({required this.title, this.actionLabel});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppTheme.textColor,
        ),
      ),
      const Spacer(),
      if (actionLabel != null)
        TextButton(onPressed: () {}, child: Text(actionLabel!)),
    ],
  );
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: AppTheme.glassCard,
    child: Column(
      children: [
        Icon(icon, size: 48, color: AppTheme.borderColor),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppTheme.mutedTextColor,
          ),
        ),
      ],
    ),
  );
}
