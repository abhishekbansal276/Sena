import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/app_models.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({super.key});
  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  int _selectedTab = 0;

  final _tabs = ['Home', 'Jobs', 'Applications', 'Notifications', 'Profile'];
  final _icons = [
    Icons.home_rounded,
    Icons.work_outline_rounded,
    Icons.assignment_outlined,
    Icons.notifications_outlined,
    Icons.person_outline_rounded,
  ];
  final _activeIcons = [
    Icons.home_rounded,
    Icons.work_rounded,
    Icons.assignment_rounded,
    Icons.notifications_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final worker = user is Worker ? user : null;

    final pages = [
      _HomeTab(worker: worker, auth: auth),
      _JobsTab(auth: auth, worker: worker),
      _ApplicationsTab(auth: auth),
      const _NotificationsTab(),
      _ProfileTab(worker: worker, auth: auth),
    ];

    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: IndexedStack(index: _selectedTab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (i) => setState(() => _selectedTab = i),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppTheme.borderColor,
        elevation: 2,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: List.generate(
          _tabs.length,
          (i) => NavigationDestination(
            icon: Icon(_icons[i], color: AppTheme.mutedTextColor),
            selectedIcon: Icon(_activeIcons[i], color: AppTheme.workerColor),
            label: _tabs[i],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// HOME TAB
// ══════════════════════════════════════════════════════════
class _HomeTab extends StatelessWidget {
  final Worker? worker;
  final AuthProvider auth;
  const _HomeTab({required this.worker, required this.auth});

  @override
  Widget build(BuildContext context) {
    final applied = auth.applications.length;
    final offers = auth.applications
        .where((a) => a.status == ApplicationStatus.accepted)
        .length;
    final pending = auth.applications
        .where((a) => a.status == ApplicationStatus.applied)
        .length;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          backgroundColor: AppTheme.workerColor,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.workerGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white24,
                        backgroundImage: worker?.profileImageUrl != null
                            ? NetworkImage(worker!.profileImageUrl!)
                            : null,
                        child: worker?.profileImageUrl == null
                            ? Text(
                                (worker?.name ?? 'U')
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 28,
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
                              'Welcome back,',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              worker?.name ?? 'Worker',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Individual Worker',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
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
                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Applied',
                        value: '$applied',
                        color: AppTheme.workerColor,
                        icon: Icons.send_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Offers',
                        value: '$offers',
                        color: AppTheme.successColor,
                        icon: Icons.check_circle_outline_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Pending',
                        value: '$pending',
                        color: AppTheme.warningColor,
                        icon: Icons.hourglass_empty_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Profile completion
                _SectionHeader(title: 'Profile Completion'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.glassCard,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Complete your profile',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '75%',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.workerColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.75,
                          minHeight: 8,
                          backgroundColor: AppTheme.borderColor,
                          color: AppTheme.workerColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: AppTheme.mutedTextColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Add skills & experience to improve visibility',
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
                const SizedBox(height: 24),

                // Recent jobs
                _SectionHeader(
                  title: 'Recent Job Postings',
                  actionLabel: 'See All',
                ),
                const SizedBox(height: 12),
                ...auth.jobListings
                    .take(2)
                    .map(
                      (job) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _JobCard(
                          job: job,
                          auth: auth,
                          workerId: auth.currentUser?.id ?? '',
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
// JOBS TAB
// ══════════════════════════════════════════════════════════
class _JobsTab extends StatefulWidget {
  final AuthProvider auth;
  final Worker? worker;
  const _JobsTab({required this.auth, required this.worker});
  @override
  State<_JobsTab> createState() => _JobsTabState();
}

class _JobsTabState extends State<_JobsTab> {
  String _selectedCategory = 'All';
  final _categories = [
    'All',
    'Electrical',
    'Plumbing',
    'HVAC',
    'Construction',
    'General',
  ];

  List<JobListing> get _filtered => _selectedCategory == 'All'
      ? widget.auth.jobListings
      : widget.auth.jobListings
            .where(
              (j) => j.category.name.toLowerCase().contains(
                _selectedCategory.toLowerCase(),
              ),
            )
            .toList();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'Find Jobs',
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                children: _categories
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedCategory = c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedCategory == c
                                  ? AppTheme.workerColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _selectedCategory == c
                                    ? AppTheme.workerColor
                                    : AppTheme.borderColor,
                              ),
                            ),
                            child: Text(
                              c,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _selectedCategory == c
                                    ? Colors.white
                                    : AppTheme.secondaryTextColor,
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
          sliver: _filtered.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Column(
                        children: [
                          Icon(
                            Icons.work_off_outlined,
                            size: 60,
                            color: AppTheme.borderColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No jobs in this category',
                            style: GoogleFonts.inter(
                              color: AppTheme.mutedTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _JobCard(
                        job: _filtered[i],
                        auth: widget.auth,
                        workerId: widget.auth.currentUser?.id ?? '',
                      ),
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
// APPLICATIONS TAB
// ══════════════════════════════════════════════════════════
class _ApplicationsTab extends StatelessWidget {
  final AuthProvider auth;
  const _ApplicationsTab({required this.auth});

  Color _statusColor(ApplicationStatus s) {
    switch (s) {
      case ApplicationStatus.accepted:
        return AppTheme.successColor;
      case ApplicationStatus.rejected:
        return const Color(0xFFEF4444);
      case ApplicationStatus.shortlisted:
        return AppTheme.warningColor;
      default:
        return AppTheme.mutedTextColor;
    }
  }

  String _statusLabel(ApplicationStatus s) {
    switch (s) {
      case ApplicationStatus.accepted:
        return 'Accepted ✓';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      default:
        return 'Under Review';
    }
  }

  @override
  Widget build(BuildContext context) {
    final apps = auth.applications;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'My Applications',
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
        if (apps.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 72,
                    color: AppTheme.borderColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No applications yet',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      color: AppTheme.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Go to Jobs and apply to get started',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.mutedTextColor,
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
              delegate: SliverChildBuilderDelegate((_, i) {
                final app = apps[i];
                final job = auth.getJobById(app.jobId);
                final c = _statusColor(app.status);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppTheme.glassCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                job?.title ?? 'Job',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppTheme.textColor,
                                ),
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
                                _statusLabel(app.status),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: c,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          job?.postedByName ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppTheme.mutedTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              job?.location ?? '',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.mutedTextColor,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Icon(
                              Icons.payments_outlined,
                              size: 14,
                              color: AppTheme.mutedTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              job?.wage ?? '',
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
                );
              }, childCount: apps.length),
            ),
          ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
// NOTIFICATIONS TAB
// ══════════════════════════════════════════════════════════
class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();

  static const _notifications = [
    (
      icon: Icons.work_rounded,
      color: Color(0xFF2563EB),
      title: 'New Job Match',
      body: 'Senior Electrician role matches your skills!',
      time: '2 hrs ago',
    ),
    (
      icon: Icons.check_circle_rounded,
      color: Color(0xFF059669),
      title: 'Application Update',
      body: 'Wilson Contracting reviewed your application.',
      time: '5 hrs ago',
    ),
    (
      icon: Icons.message_rounded,
      color: Color(0xFF7C3AED),
      title: 'Message Received',
      body: 'Mike Wilson: "Are you available next Monday?"',
      time: 'Yesterday',
    ),
    (
      icon: Icons.notifications_active_rounded,
      color: Color(0xFFF59E0B),
      title: 'Profile View',
      body: 'Connor Infrastructure viewed your profile.',
      time: '2 days ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'Notifications',
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
              final n = _notifications[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.glassCard,
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: n.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(n.icon, color: n.color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.title,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppTheme.textColor,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              n.body,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.secondaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              n.time,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppTheme.mutedTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: _notifications.length),
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
  final Worker? worker;
  final AuthProvider auth;
  const _ProfileTab({required this.worker, required this.auth});

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
                // Avatar + name
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.primarySubtle,
                        backgroundImage: worker?.profileImageUrl != null
                            ? NetworkImage(worker!.profileImageUrl!)
                            : null,
                        child: worker?.profileImageUrl == null
                            ? Text(
                                (worker?.name ?? 'U')
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: 36,
                                  color: AppTheme.workerColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        worker?.name ?? 'Worker',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        worker?.email ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: worker?.isAvailable == true
                              ? AppTheme.successColor.withValues(alpha: 0.1)
                              : AppTheme.mutedTextColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          worker?.isAvailable == true
                              ? '● Available'
                              : '● Engaged',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: worker?.isAvailable == true
                                ? AppTheme.successColor
                                : AppTheme.mutedTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Info cards
                _ProfileInfoCard(
                  items: [
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: worker?.location ?? 'Not specified',
                    ),
                    _InfoRow(
                      icon: Icons.work_history_outlined,
                      label: 'Experience',
                      value: worker?.experience ?? '0 years',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _SectionHeader(title: 'Bio'),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.glassCard,
                  child: Text(
                    worker?.bio.isNotEmpty == true
                        ? worker!.bio
                        : 'No bio added yet.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.secondaryTextColor,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _SectionHeader(title: 'Skills'),
                const SizedBox(height: 10),
                worker?.skills.isNotEmpty == true
                    ? Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: worker!.skills
                            .map((s) => _SkillChip(label: s))
                            .toList(),
                      )
                    : Text(
                        'No skills added yet.',
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

class _JobCard extends StatelessWidget {
  final JobListing job;
  final AuthProvider auth;
  final String workerId;
  const _JobCard({
    required this.job,
    required this.auth,
    required this.workerId,
  });

  @override
  Widget build(BuildContext context) {
    final applied = auth.hasApplied(job.id);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppTheme.workerGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.work_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppTheme.textColor,
                      ),
                    ),
                    Text(
                      job.postedByName,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primarySubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  job.postedByType,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.workerColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            job.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.secondaryTextColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: job.requiredSkills
                .map((s) => _SkillChip(label: s))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MetaChip(icon: Icons.location_on_outlined, label: job.location),
              const SizedBox(width: 8),
              _MetaChip(icon: Icons.schedule_rounded, label: job.duration),
              const SizedBox(width: 8),
              _MetaChip(icon: Icons.payments_outlined, label: job.wage),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: applied
                    ? Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Applied ✓',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.successColor,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          auth.applyToJob(job.id, workerId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Applied to "${job.title}"!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          backgroundColor: AppTheme.workerColor,
                        ),
                        child: Text(
                          'Apply Now',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppTheme.borderColor),
      boxShadow: AppTheme.cardShadow,
    ),
    child: Column(
      children: [
        Icon(icon, color: color, size: 22),
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
            fontSize: 11,
            color: AppTheme.mutedTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
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

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: AppTheme.primarySubtle,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppTheme.workerColor.withValues(alpha: 0.2)),
    ),
    child: Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppTheme.workerColor,
      ),
    ),
  );
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: AppTheme.mutedTextColor),
      const SizedBox(width: 4),
      Text(
        label,
        style: GoogleFonts.inter(fontSize: 11, color: AppTheme.mutedTextColor),
      ),
    ],
  );
}

class _ProfileInfoCard extends StatelessWidget {
  final List<_InfoRow> items;
  const _ProfileInfoCard({required this.items});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: AppTheme.glassCard,
    child: Column(
      children: items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(e.icon, size: 18, color: AppTheme.workerColor),
                  const SizedBox(width: 12),
                  Text(
                    e.label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.mutedTextColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    e.value,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textColor,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    ),
  );
}

class _InfoRow {
  final IconData icon;
  final String label, value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
}
