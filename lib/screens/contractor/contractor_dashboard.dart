import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/app_models.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class ContractorDashboard extends StatefulWidget {
  const ContractorDashboard({super.key});
  @override
  State<ContractorDashboard> createState() => _ContractorDashboardState();
}

class _ContractorDashboardState extends State<ContractorDashboard> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final contractor = user is Contractor ? user : null;

    final pages = [
      _HomeTab(contractor: contractor, auth: auth),
      _WorkersTab(auth: auth),
      _RequestsTab(auth: auth),
      _AllocationsTab(auth: auth),
      _ProfileTab(contractor: contractor, auth: auth),
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
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group_rounded),
            label: 'Workers',
          ),
          NavigationDestination(
            icon: Icon(Icons.inbox_outlined),
            selectedIcon: Icon(Icons.inbox_rounded),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'Allocations',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
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
  final Contractor? contractor;
  final AuthProvider auth;
  const _HomeTab({required this.contractor, required this.auth});

  @override
  Widget build(BuildContext context) {
    final total = auth.workers.length;
    final active = auth.workers.where((w) => !w.isAvailable).length;
    final available = auth.workers.where((w) => w.isAvailable).length;
    final pending = auth.workforceRequests
        .where((r) => r.status == RequestStatus.pending)
        .length;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          backgroundColor: AppTheme.contractorColor,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.contractorGradient,
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
                        backgroundImage: contractor?.profileImageUrl != null
                            ? NetworkImage(contractor!.profileImageUrl!)
                            : null,
                        child: contractor?.profileImageUrl == null
                            ? Text(
                                (contractor?.name ?? 'C')
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Contractor Portal',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              contractor?.companyName ?? 'My Firm',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              contractor?.name ?? '',
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
                // Stat grid
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        'Total\nWorkers',
                        '$total',
                        AppTheme.contractorColor,
                        Icons.group_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        'Engaged',
                        '$active',
                        AppTheme.warningColor,
                        Icons.engineering_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        'Available',
                        '$available',
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
                        'Pending\nRequests',
                        '$pending',
                        const Color(0xFF7C3AED),
                        Icons.inbox_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        'Active\nContracts',
                        '${auth.workforceRequests.where((r) => r.status == RequestStatus.accepted).length}',
                        AppTheme.workerColor,
                        Icons.handshake_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        'Rejected',
                        '${auth.workforceRequests.where((r) => r.status == RequestStatus.rejected).length}',
                        const Color(0xFFEF4444),
                        Icons.cancel_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _SectionHeader(title: 'Your Worker Roster'),
                const SizedBox(height: 12),
                ...auth.workers
                    .take(3)
                    .map(
                      (w) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _WorkerTile(worker: w),
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
// WORKERS TAB
// ══════════════════════════════════════════════════════════
class _WorkersTab extends StatefulWidget {
  final AuthProvider auth;
  const _WorkersTab({required this.auth});
  @override
  State<_WorkersTab> createState() => _WorkersTabState();
}

class _WorkersTabState extends State<_WorkersTab> {
  String _filter = 'All';
  final _filters = ['All', 'Available', 'Engaged'];

  List<Worker> get _filtered {
    if (_filter == 'Available') {
      return widget.auth.workers.where((w) => w.isAvailable).toList();
    }
    if (_filter == 'Engaged') {
      return widget.auth.workers.where((w) => !w.isAvailable).toList();
    }
    return widget.auth.workers;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'Worker Roster',
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(52),
            child: Container(
              height: 52,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
              ),
              child: Row(
                children: _filters
                    .map(
                      (f) => Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _filter = f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _filter == f
                                      ? AppTheme.contractorColor
                                      : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              f,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _filter == f
                                    ? AppTheme.contractorColor
                                    : AppTheme.mutedTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _WorkerDetailCard(worker: _filtered[i]),
              ),
              childCount: _filtered.length,
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
class _RequestsTab extends StatelessWidget {
  final AuthProvider auth;
  const _RequestsTab({required this.auth});

  @override
  Widget build(BuildContext context) {
    final requests = auth.workforceRequests;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'Company Requests',
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
        if (requests.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 72,
                    color: AppTheme.borderColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No incoming requests',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      color: AppTheme.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _RequestCard(request: requests[i], auth: auth),
                ),
                childCount: requests.length,
              ),
            ),
          ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
// ALLOCATIONS TAB
// ══════════════════════════════════════════════════════════
class _AllocationsTab extends StatelessWidget {
  final AuthProvider auth;
  const _AllocationsTab({required this.auth});

  @override
  Widget build(BuildContext context) {
    final accepted = auth.workforceRequests
        .where((r) => r.status == RequestStatus.accepted)
        .toList();
    final available = auth.workers.where((w) => w.isAvailable).toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'Allocations',
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
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Available workers
                _SectionHeader(
                  title: 'Available Workers (${available.length})',
                ),
                const SizedBox(height: 12),
                if (available.isEmpty)
                  _EmptyState(
                    icon: Icons.group_off_outlined,
                    message: 'No workers currently available',
                  )
                else
                  ...available.map(
                    (w) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _WorkerTile(worker: w),
                    ),
                  ),
                const SizedBox(height: 24),

                // Accepted requests to fulfill
                _SectionHeader(title: 'Accepted Requests'),
                const SizedBox(height: 12),
                if (accepted.isEmpty)
                  _EmptyState(
                    icon: Icons.assignment_late_outlined,
                    message:
                        'No accepted requests yet. Accept requests from the Requests tab.',
                  )
                else
                  ...accepted.map(
                    (req) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AllocationCard(
                        request: req,
                        availableWorkers: available,
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
// PROFILE TAB
// ══════════════════════════════════════════════════════════
class _ProfileTab extends StatelessWidget {
  final Contractor? contractor;
  final AuthProvider auth;
  const _ProfileTab({required this.contractor, required this.auth});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'My Profile',
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
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFFE0F7FA),
                        backgroundImage: contractor?.profileImageUrl != null
                            ? NetworkImage(contractor!.profileImageUrl!)
                            : null,
                        child: contractor?.profileImageUrl == null
                            ? Text(
                                (contractor?.name ?? 'C')
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: 36,
                                  color: AppTheme.contractorColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        contractor?.companyName ?? 'My Firm',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textColor,
                        ),
                      ),
                      Text(
                        contractor?.name ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFF59E0B),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${contractor?.rating ?? 4.5}',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textColor,
                            ),
                          ),
                          Text(
                            ' Rating',
                            style: GoogleFonts.inter(
                              color: AppTheme.mutedTextColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _SectionHeader(title: 'About'),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.glassCard,
                  child: Text(
                    contractor?.description.isNotEmpty == true
                        ? contractor!.description
                        : 'No description added.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.secondaryTextColor,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _SectionHeader(title: 'Services Provided'),
                const SizedBox(height: 10),
                contractor?.servicesProvided.isNotEmpty == true
                    ? Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: contractor!.servicesProvided
                            .map((s) => _ServiceChip(label: s))
                            .toList(),
                      )
                    : Text(
                        'No services listed.',
                        style: GoogleFonts.inter(
                          color: AppTheme.mutedTextColor,
                          fontSize: 13,
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

class _WorkerTile extends StatelessWidget {
  final Worker worker;
  const _WorkerTile({required this.worker});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
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
                    fontWeight: FontWeight.bold,
                    color: AppTheme.workerColor,
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
            worker.isAvailable ? 'Available' : 'Engaged',
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

class _WorkerDetailCard extends StatelessWidget {
  final Worker worker;
  const _WorkerDetailCard({required this.worker});
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
              radius: 26,
              backgroundColor: AppTheme.primarySubtle,
              backgroundImage: worker.profileImageUrl != null
                  ? NetworkImage(worker.profileImageUrl!)
                  : null,
              child: worker.profileImageUrl == null
                  ? Text(
                      worker.name.substring(0, 1),
                      style: GoogleFonts.inter(
                        fontSize: 18,
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
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppTheme.textColor,
                    ),
                  ),
                  Text(
                    worker.experience,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.secondaryTextColor,
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
                worker.isAvailable ? 'Available' : 'Engaged',
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
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 13,
              color: AppTheme.mutedTextColor,
            ),
            const SizedBox(width: 4),
            Text(
              worker.location,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.mutedTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: worker.skills
              .map(
                (s) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primarySubtle,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    s,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.workerColor,
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

class _RequestCard extends StatelessWidget {
  final WorkforceRequest request;
  final AuthProvider auth;
  const _RequestCard({required this.request, required this.auth});

  Color _statusColor(RequestStatus s) {
    switch (s) {
      case RequestStatus.accepted:
        return AppTheme.successColor;
      case RequestStatus.rejected:
        return const Color(0xFFEF4444);
      case RequestStatus.completed:
        return AppTheme.contractorColor;
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
      case RequestStatus.completed:
        return 'Completed';
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
                      request.companyName,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppTheme.textColor,
                      ),
                    ),
                    Text(
                      '${request.workerCount} workers needed',
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
          const SizedBox(height: 12),
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
                      color: AppTheme.primarySubtle,
                      borderRadius: BorderRadius.circular(20),
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
          const SizedBox(height: 12),
          Row(
            children: [
              _MetaItem(icon: Icons.schedule_outlined, label: request.duration),
              const SizedBox(width: 16),
              _MetaItem(icon: Icons.payments_outlined, label: request.budget),
              const SizedBox(width: 16),
              _MetaItem(
                icon: Icons.location_on_outlined,
                label: request.location,
              ),
            ],
          ),
          if (request.status == RequestStatus.pending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => auth.updateWorkforceRequestStatus(
                      request.id,
                      RequestStatus.rejected,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      minimumSize: const Size(0, 40),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => auth.updateWorkforceRequestStatus(
                      request.id,
                      RequestStatus.accepted,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.contractorColor,
                      minimumSize: const Size(0, 40),
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AllocationCard extends StatefulWidget {
  final WorkforceRequest request;
  final List<Worker> availableWorkers;
  const _AllocationCard({
    required this.request,
    required this.availableWorkers,
  });
  @override
  State<_AllocationCard> createState() => _AllocationCardState();
}

class _AllocationCardState extends State<_AllocationCard> {
  final List<String> _assigned = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.request.companyName,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppTheme.textColor,
            ),
          ),
          Text(
            'Needs ${widget.request.workerCount} worker(s)',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'Assign Workers:',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          if (widget.availableWorkers.isEmpty)
            Text(
              'No available workers to assign.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.mutedTextColor,
              ),
            )
          else
            ...widget.availableWorkers.map((w) {
              final assigned = _assigned.contains(w.id);
              return CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: assigned,
                activeColor: AppTheme.contractorColor,
                title: Text(
                  w.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textColor,
                  ),
                ),
                subtitle: Text(
                  w.skills.take(2).join(', '),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.mutedTextColor,
                  ),
                ),
                onChanged: (v) => setState(
                  () =>
                      v == true ? _assigned.add(w.id) : _assigned.remove(w.id),
                ),
              );
            }),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _assigned.isEmpty
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${_assigned.length} worker(s) assigned to ${widget.request.companyName}',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.contractorColor,
                minimumSize: const Size(0, 44),
              ),
              child: Text(
                'Confirm Allocation (${_assigned.length})',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  final String label;
  const _ServiceChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFE0F7FA),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: AppTheme.contractorColor.withValues(alpha: 0.2),
      ),
    ),
    child: Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.contractorColor,
      ),
    ),
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
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) => Text(
    title,
    style: GoogleFonts.outfit(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppTheme.textColor,
    ),
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
