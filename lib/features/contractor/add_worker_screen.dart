import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/worker_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({super.key});

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _aadhaarCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final List<String> _selectedSkills = [];
  bool _loading = false;

  static const _allSkills = [
    'Mason', 'Plastering', 'Tiling', 'Electrician', 'Wiring',
    'Painter', 'Plumber', 'Pipe Fitting', 'Carpenter',
    'Helper', 'Loading/Unloading', 'Housekeeping', 'Welder', 'Gardener',
  ];

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one skill')));
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final contractor = context.read<AuthProvider>().currentContractor!;
    final worker = WorkerModel(
      id: 'w${DateTime.now().millisecondsSinceEpoch}',
      fullName: _nameCtrl.text,
      age: int.tryParse(_ageCtrl.text) ?? 25,
      aadhaarNumber: _aadhaarCtrl.text,
      skills: _selectedSkills,
      yearsOfExperience: int.tryParse(_expCtrl.text),
      city: _cityCtrl.text,
      state: _stateCtrl.text,
      phone: _phoneCtrl.text,
      email: _emailCtrl.text,
      contractorId: contractor.id,
    );
    context.read<WorkerProvider>().addWorker(worker);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Worker added successfully!'), backgroundColor: AppTheme.success));
    context.go('/contractor/workers');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Worker')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            AppTextField(label: 'Full Name', controller: _nameCtrl, prefixIcon: const Icon(Icons.person_outline), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: AppTextField(label: 'Age', controller: _ageCtrl, keyboardType: TextInputType.number, validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
              const SizedBox(width: 12),
              Expanded(child: AppTextField(label: 'Experience (yrs)', controller: _expCtrl, keyboardType: TextInputType.number)),
            ]),
            const SizedBox(height: 12),
            AppTextField(label: 'Aadhaar Number', controller: _aadhaarCtrl, keyboardType: TextInputType.number, prefixIcon: const Icon(Icons.credit_card_outlined), validator: (v) => v == null || v.length < 12 ? 'Enter valid Aadhaar' : null),
            const SizedBox(height: 12),
            AppTextField(label: 'Phone', controller: _phoneCtrl, keyboardType: TextInputType.phone, prefixIcon: const Icon(Icons.phone_outlined), validator: (v) => v == null || v.length < 10 ? 'Enter valid phone' : null),
            const SizedBox(height: 12),
            AppTextField(label: 'Email', controller: _emailCtrl, keyboardType: TextInputType.emailAddress, prefixIcon: const Icon(Icons.email_outlined), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: AppTextField(label: 'City', controller: _cityCtrl, validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
              const SizedBox(width: 12),
              Expanded(child: AppTextField(label: 'State', controller: _stateCtrl, validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
            ]),
            const SizedBox(height: 20),
            Text('Skills', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allSkills.map((skill) {
                final sel = _selectedSkills.contains(skill);
                return FilterChip(
                  label: Text(skill),
                  selected: sel,
                  onSelected: (v) => setState(() { v ? _selectedSkills.add(skill) : _selectedSkills.remove(skill); }),
                  selectedColor: AppTheme.primary.withOpacity(0.15),
                  checkmarkColor: AppTheme.primary,
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            AppButton(label: 'Add Worker', onTap: _submit, isLoading: _loading, icon: Icons.person_add_outlined),
          ],
        ),
      ),
    );
  }
}
