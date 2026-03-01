import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/providers/auth_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class CompanyRegistrationScreen extends StatefulWidget {
  const CompanyRegistrationScreen({super.key});

  @override
  State<CompanyRegistrationScreen> createState() => _CompanyRegistrationScreenState();
}

class _CompanyRegistrationScreenState extends State<CompanyRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameCtrl = TextEditingController();
  final _gstCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _personCtrl = TextEditingController();
  final _designationCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _industryType;
  bool _loading = false;

  static const _industries = [
    'Construction', 'Facility Management', 'Manufacturing',
    'Logistics', 'Agriculture', 'Hospitality', 'Other',
  ];

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    context.read<AuthProvider>().demoLogin(UserRole.company);
    context.go('/company/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Registration'),
        leading: BackButton(onPressed: () => context.go('/role-select')),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _section('Company Details'),
            AppTextField(
              label: 'Company Name',
              controller: _companyNameCtrl,
              prefixIcon: const Icon(Icons.business_outlined),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'GST Number',
              controller: _gstCtrl,
              prefixIcon: const Icon(Icons.receipt_long_outlined),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Company Address',
              controller: _addressCtrl,
              maxLines: 2,
              prefixIcon: const Icon(Icons.location_on_outlined),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Company Description (optional)',
              controller: _descCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _industryType,
              decoration: const InputDecoration(labelText: 'Industry Type'),
              items: _industries.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
              onChanged: (v) => setState(() => _industryType = v),
            ),
            const SizedBox(height: 20),
            _section('Authorized Person'),
            AppTextField(
              label: 'Authorized Person Name',
              controller: _personCtrl,
              prefixIcon: const Icon(Icons.person_outline),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Designation',
              controller: _designationCtrl,
              prefixIcon: const Icon(Icons.badge_outlined),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            _section('Contact Information'),
            AppTextField(
              label: 'Official Email',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Phone Number',
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_outlined),
              validator: (v) => v == null || v.length < 10 ? 'Enter valid phone' : null,
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Register Company',
              onTap: _submit,
              isLoading: _loading,
              icon: Icons.check_circle_outline,
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('Already registered? '),
                TextButton(
                  onPressed: () => context.go('/login/company'),
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
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.primary)),
  );
}
