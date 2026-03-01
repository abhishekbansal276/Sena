import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/providers/auth_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class LoginScreen extends StatefulWidget {
  final UserRole role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  String get _roleLabel {
    switch (widget.role) {
      case UserRole.worker: return 'Worker';
      case UserRole.contractor: return 'Contractor';
      case UserRole.company: return 'Company';
    }
  }

  Color get _roleColor {
    switch (widget.role) {
      case UserRole.worker: return const Color(0xFF10B981);
      case UserRole.contractor: return const Color(0xFF8B5CF6);
      case UserRole.company: return AppTheme.primary;
    }
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    switch (widget.role) {
      case UserRole.worker:
        auth.demoLogin(UserRole.worker);
        context.go('/worker/dashboard');
        break;
      case UserRole.contractor:
        auth.demoLogin(UserRole.contractor);
        context.go('/contractor/dashboard');
        break;
      case UserRole.company:
        auth.demoLogin(UserRole.company);
        context.go('/company/dashboard');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.go('/role-select'),
                  child: const Icon(Icons.arrow_back_rounded, size: 28),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _roleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    widget.role == UserRole.worker
                        ? Icons.engineering_rounded
                        : widget.role == UserRole.contractor
                            ? Icons.supervisor_account_rounded
                            : Icons.business_rounded,
                    color: _roleColor,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Sign In as', style: Theme.of(context).textTheme.bodyMedium),
                Text(_roleLabel, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: _roleColor)),
                const SizedBox(height: 32),
                AppTextField(
                  label: 'Email Address',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (v) => v == null || v.isEmpty ? 'Enter your email' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  controller: _passCtrl,
                  obscureText: _obscure,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  validator: (v) => v == null || v.length < 6 ? 'Minimum 6 characters' : null,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(label: 'Sign In', onTap: _login, isLoading: _loading),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        switch (widget.role) {
                          case UserRole.worker: context.go('/register/worker');
                          case UserRole.contractor: context.go('/register/contractor');
                          case UserRole.company: context.go('/register/company');
                        }
                      },
                      child: Text('Register',
                          style: TextStyle(
                              color: _roleColor, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                // Demo button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _roleColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _roleColor.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Demo Login', style: TextStyle(fontWeight: FontWeight.w700, color: _roleColor)),
                      const SizedBox(height: 4),
                      Text('Skip login and explore the app as $_roleLabel',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'Continue as $_roleLabel (Demo)',
                        style: AppButtonStyle.secondary,
                        onTap: () {
                          final auth = context.read<AuthProvider>();
                          auth.demoLogin(widget.role);
                          switch (widget.role) {
                            case UserRole.worker: context.go('/worker/dashboard');
                            case UserRole.contractor: context.go('/contractor/dashboard');
                            case UserRole.company: context.go('/company/dashboard');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
