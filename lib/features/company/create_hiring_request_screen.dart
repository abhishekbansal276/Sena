import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/models/mock_data.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/request_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class CreateHiringRequestScreen extends StatefulWidget {
  const CreateHiringRequestScreen({super.key});

  @override
  State<CreateHiringRequestScreen> createState() =>
      _CreateHiringRequestScreenState();
}

class _CreateHiringRequestScreenState extends State<CreateHiringRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _skillCtrl = TextEditingController();
  final _stdWageCtrl = TextEditingController();
  final _offWageCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _workersCtrl = TextEditingController(text: '1');
  WorkDuration _duration = WorkDuration.daily;
  DateTime _startDate = DateTime.now().add(const Duration(days: 3));
  String? _targetContractorId;
  String? _targetWorkerId;
  bool _loading = false;

  static const _skills = [
    'Mason',
    'Electrician',
    'Plumber',
    'Painter',
    'Carpenter',
    'Helper',
    'Welder',
    'Housekeeping',
    'Loading/Unloading',
    'Gardener',
  ];

  void _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _startDate = d);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final company = context.read<AuthProvider>().currentCompany!;
    final req = HiringRequest(
      id: 'hr${DateTime.now().millisecondsSinceEpoch}',
      companyId: company.id,
      companyName: company.companyName,
      contractorId: _targetContractorId,
      workerId: _targetWorkerId,
      workersRequired: int.tryParse(_workersCtrl.text) ?? 1,
      skillRequired: _skillCtrl.text,
      standardWage: double.tryParse(_stdWageCtrl.text) ?? 500,
      offeredWage: double.tryParse(_offWageCtrl.text) ?? 520,
      duration: _duration,
      workLocation: _locationCtrl.text,
      startDate: _startDate,
      additionalRequirements:
          _notesCtrl.text.isNotEmpty ? _notesCtrl.text : null,
      createdAt: DateTime.now(),
    );

    context.read<RequestProvider>().addHiringRequest(req);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Hiring request sent successfully!'),
          backgroundColor: AppTheme.success,
        ),
      );
      context.go('/company/sent-requests');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Hiring Request')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const _Section('Hire From'),
            DropdownButtonFormField<String>(
              hint: const Text('Select Contractor (optional)'),
              initialValue: _targetContractorId,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.supervisor_account_outlined)),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('Individual Worker')),
                ...MockData.contractors.map((c) => DropdownMenuItem(
                    value: c.id, child: Text(c.businessName ?? c.fullName))),
              ],
              onChanged: (v) => setState(() {
                _targetContractorId = v;
                _targetWorkerId = null;
              }),
            ),
            if (_targetContractorId == null) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                hint: const Text('Select Worker (optional)'),
                initialValue: _targetWorkerId,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.engineering_outlined)),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('Any available worker')),
                  ...MockData.workers.where((w) => w.contractorId == null).map(
                      (w) => DropdownMenuItem(
                          value: w.id, child: Text(w.fullName))),
                ],
                onChanged: (v) => setState(() => _targetWorkerId = v),
              ),
            ],
            const SizedBox(height: 20),
            const _Section('Job Details'),
            DropdownButtonFormField<String>(
              hint: const Text('Select Skill Required'),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.construction_outlined)),
              items: _skills
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) {
                if (v != null) _skillCtrl.text = v;
              },
              validator: (_) =>
                  _skillCtrl.text.isEmpty ? 'Select a skill' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Number of Workers Required',
              controller: _workersCtrl,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.group_outlined),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Work Location',
              controller: _locationCtrl,
              prefixIcon: const Icon(Icons.location_on_outlined),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            const _Section('Wages & Duration'),
            Row(children: [
              Expanded(
                  child: AppTextField(
                      label: 'Standard Wage (₹/day)',
                      controller: _stdWageCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null)),
              const SizedBox(width: 12),
              Expanded(
                  child: AppTextField(
                      label: 'Offered Wage (₹/day)',
                      controller: _offWageCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null)),
            ]),
            const SizedBox(height: 12),
            Text('Duration', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
                children: WorkDuration.values.map((d) {
              final selected = _duration == d;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: OutlinedButton(
                    onPressed: () => setState(() => _duration = d),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: selected ? AppTheme.primary : null,
                      foregroundColor:
                          selected ? Colors.white : AppTheme.primary,
                    ),
                    child: Text(d.name.capitalize()),
                  ),
                ),
              );
            }).toList()),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(DateFormat('d MMM y').format(_startDate)),
              ),
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Additional Requirements (optional)',
              controller: _notesCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: 28),
            AppButton(
                label: 'Send Hiring Request',
                icon: Icons.send_rounded,
                onTap: _submit,
                isLoading: _loading),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section(this.title);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary)),
      );
}

extension StringExt on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
