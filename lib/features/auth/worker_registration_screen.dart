import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/providers/auth_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class WorkerRegistrationScreen extends StatefulWidget {
  const WorkerRegistrationScreen({super.key});

  @override
  State<WorkerRegistrationScreen> createState() => _WorkerRegistrationScreenState();
}

class _WorkerRegistrationScreenState extends State<WorkerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _aadhaarCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final List<String> _selectedSkills = [];
  final List<String> _selectedLanguages = [];
  bool _loading = false;

  static const _allSkills = [
    'Mason', 'Plastering', 'Tiling', 'Electrician', 'Wiring',
    'Panel Fitting', 'Painter', 'Plumber', 'Pipe Fitting', 'Carpenter',
    'Helper', 'Loading/Unloading', 'Housekeeping', 'Welder', 'Gardener',
  ];

  static const _allLanguages = ['Hindi', 'English', 'Marathi', 'Gujarati', 'Tamil', 'Telugu', 'Bengali'];

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one skill')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    auth.demoLogin(UserRole.worker);
    context.go('/worker/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Registration'),
        leading: BackButton(onPressed: () => context.go('/role-select')),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _section('Personal Details'),
              AppTextField(
                label: 'Full Name',
                controller: _nameCtrl,
                prefixIcon: const Icon(Icons.person_outline),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Age',
                controller: _ageCtrl,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.cake_outlined),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Aadhaar Card Number',
                controller: _aadhaarCtrl,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.credit_card_outlined),
                validator: (v) => v == null || v.length < 12 ? 'Enter valid Aadhaar' : null,
              ),
              const SizedBox(height: 20),
              _section('Contact Information'),
              AppTextField(
                label: 'Phone Number',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
                validator: (v) => v == null || v.length < 10 ? 'Enter valid phone' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Email Address',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'City',
                      controller: _cityCtrl,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      label: 'State',
                      controller: _stateCtrl,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _section('Skills & Experience'),
              AppTextField(
                label: 'Years of Experience (optional)',
                controller: _expCtrl,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.work_history_outlined),
              ),
              const SizedBox(height: 12),
              Text('Select Skills', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allSkills.map((skill) {
                  final selected = _selectedSkills.contains(skill);
                  return FilterChip(
                    label: Text(skill),
                    selected: selected,
                    onSelected: (v) => setState(() {
                      v ? _selectedSkills.add(skill) : _selectedSkills.remove(skill);
                    }),
                    selectedColor: AppTheme.primary.withOpacity(0.15),
                    checkmarkColor: AppTheme.primary,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              _section('Languages Known'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allLanguages.map((lang) {
                  final selected = _selectedLanguages.contains(lang);
                  return FilterChip(
                    label: Text(lang),
                    selected: selected,
                    onSelected: (v) => setState(() {
                      v ? _selectedLanguages.add(lang) : _selectedLanguages.remove(lang);
                    }),
                    selectedColor: AppTheme.accent.withOpacity(0.3),
                    checkmarkColor: AppTheme.accentDark,
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              AppButton(label: 'Create Profile', onTap: _submit, isLoading: _loading, icon: Icons.check_circle_outline),
              const SizedBox(height: 16),
              Center(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('Already registered? '),
                  TextButton(
                    onPressed: () => context.go('/login/worker'),
                    child: const Text('Sign In'),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.primary)),
  );
}
