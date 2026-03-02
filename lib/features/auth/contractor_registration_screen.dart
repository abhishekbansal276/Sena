import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/models/models.dart';
import '../../core/providers/auth_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class ContractorRegistrationScreen extends StatefulWidget {
  const ContractorRegistrationScreen({super.key});

  @override
  State<ContractorRegistrationScreen> createState() =>
      _ContractorRegistrationScreenState();
}

class _ContractorRegistrationScreenState
    extends State<ContractorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _aadhaarCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _bizCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  bool _loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    context.read<AuthProvider>().demoLogin(UserRole.contractor);
    context.go('/contractor/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor Registration'),
        backgroundColor: const Color(0xFF8B5CF6),
        leading: BackButton(onPressed: () => context.go('/role-select')),
      ),
      body: Form(
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
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Aadhaar Card Number',
              controller: _aadhaarCtrl,
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || v.length < 12 ? 'Enter valid Aadhaar' : null,
            ),
            const SizedBox(height: 20),
            _section('Business Details'),
            AppTextField(
              label: 'Business Name (optional)',
              controller: _bizCtrl,
              prefixIcon: const Icon(Icons.store_outlined),
            ),
            const SizedBox(height: 20),
            _section('Contact & Location'),
            AppTextField(
              label: 'Phone Number',
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_outlined),
              validator: (v) =>
                  v == null || v.length < 10 ? 'Enter valid phone' : null,
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
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'State',
                    controller: _stateCtrl,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Create Contractor Profile',
              onTap: _submit,
              isLoading: _loading,
              icon: Icons.check_circle_outline,
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('Already registered? '),
                TextButton(
                  onPressed: () => context.go('/login/contractor'),
                  child: const Text('Sign In'),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8B5CF6))),
      );
}
