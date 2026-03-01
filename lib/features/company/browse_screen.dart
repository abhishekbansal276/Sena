import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/models/mock_data.dart';
import '../../core/providers/worker_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _searchCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  AvailabilityStatus? _filterAvail;
  String _skillFilter = '';

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final workerProv = context.watch<WorkerProvider>();
    final filteredWorkers = workerProv.searchWorkers(
      skill: _skillFilter,
      city: _cityCtrl.text,
      availability: _filterAvail,
    );
    final contractors = MockData.contractors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse & Search'),
        leading: BackButton(onPressed: () => context.pop()),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: AppTheme.accent,
          tabs: const [
            Tab(text: 'Workers', icon: Icon(Icons.engineering_rounded)),
            Tab(text: 'Contractors', icon: Icon(Icons.supervisor_account_rounded)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search by skill (e.g., Mason, Plumber…)',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _skillFilter.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() { _skillFilter = ''; _searchCtrl.clear(); }))
                        : null,
                  ),
                  onChanged: (v) => setState(() => _skillFilter = v),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityCtrl,
                        decoration: const InputDecoration(
                          hintText: 'City filter…',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<AvailabilityStatus?>(
                      value: _filterAvail,
                      hint: const Text('Avail.'),
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('All')),
                        DropdownMenuItem(value: AvailabilityStatus.available, child: Text('✅ Available')),
                        DropdownMenuItem(value: AvailabilityStatus.unavailable, child: Text('🔴 Busy')),
                      ],
                      onChanged: (v) => setState(() => _filterAvail = v),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                // Workers tab
                filteredWorkers.isEmpty
                    ? const EmptyState(message: 'No workers match your search.\nTry different filters.', icon: Icons.search_off_rounded)
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredWorkers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => _WorkerListCard(worker: filteredWorkers[i]),
                      ),
                // Contractors tab
                ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: contractors.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _ContractorListCard(contractor: contractors[i]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkerListCard extends StatelessWidget {
  final WorkerModel worker;
  const _WorkerListCard({required this.worker});

  @override
  Widget build(BuildContext context) {
    final avail = worker.availability == AvailabilityStatus.available;
    return Card(
      child: InkWell(
        onTap: () => context.push('/company/worker/${worker.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              UserAvatar(name: worker.fullName, radius: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(worker.fullName, style: Theme.of(context).textTheme.headlineSmall)),
                    StatusChip(label: avail ? 'Available' : 'Busy', color: avail ? AppTheme.success : AppTheme.error),
                  ]),
                  const SizedBox(height: 4),
                  Text('${worker.city}, ${worker.state}', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    children: worker.skills.take(3).map((s) => Chip(label: Text(s), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, padding: EdgeInsets.zero, labelStyle: const TextStyle(fontSize: 11))).toList(),
                  ),
                ]),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textLight),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContractorListCard extends StatelessWidget {
  final ContractorModel contractor;
  const _ContractorListCard({required this.contractor});

  @override
  Widget build(BuildContext context) {
    final workers = MockData.workers.where((w) => w.contractorId == contractor.id).toList();
    final availWorkers = workers.where((w) => w.availability == AvailabilityStatus.available).length;
    final avail = contractor.availability == AvailabilityStatus.available;

    return Card(
      child: InkWell(
        onTap: () => context.push('/company/contractor/${contractor.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              UserAvatar(name: contractor.fullName, radius: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(contractor.businessName ?? contractor.fullName, style: Theme.of(context).textTheme.headlineSmall)),
                    StatusChip(label: avail ? 'Available' : 'Busy', color: avail ? AppTheme.success : AppTheme.error),
                  ]),
                  Text(contractor.fullName, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text('${contractor.city}, ${contractor.state} • $availWorkers/${workers.length} workers free',
                      style: Theme.of(context).textTheme.bodyMedium),
                ]),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textLight),
            ],
          ),
        ),
      ),
    );
  }
}
