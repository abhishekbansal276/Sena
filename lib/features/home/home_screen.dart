import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/models/mock_data.dart';
import '../../core/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeroHeader(height: size.height * 0.38),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                  Text(
                    'Choose your role',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Jump straight in using a demo account',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  const _RoleCard(
                    role: UserRole.company,
                    title: 'Company',
                    subtitle: 'Post requests & hire labour',
                    icon: Icons.business_rounded,
                    color: Color(0xFF8B3D00),
                  ),
                  const SizedBox(height: 14),
                  const _RoleCard(
                    role: UserRole.contractor,
                    title: 'Contractor',
                    subtitle: 'Manage workers & accept jobs',
                    icon: Icons.supervisor_account_rounded,
                    color: Color(0xFF8B5CF6),
                  ),
                  const SizedBox(height: 14),
                  const _RoleCard(
                    role: UserRole.worker,
                    title: 'Worker',
                    subtitle: 'Browse & accept work orders',
                    icon: Icons.engineering_rounded,
                    color: Color(0xFF2D8A6E),
                  ),
                  const SizedBox(height: 28),
                  const _DemoCredentialsCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Header ───────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  final double height;
  const _HeroHeader({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5C1800), Color(0xFF8B3D00), Color(0xFFA84E0F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 30,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accent.withOpacity(0.18),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt_rounded,
                            color: AppTheme.accent, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'SENA',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppTheme.accent,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Connect. \nHire. \nGrow.',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          height: 1.15,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'India\'s unskilled labour hiring platform —\nfast, fair, and transparent.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Role Card ─────────────────────────────────────────────────────────────────

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  String get _rolePath {
    switch (role) {
      case UserRole.worker:
        return 'worker';
      case UserRole.contractor:
        return 'contractor';
      case UserRole.company:
        return 'company';
    }
  }

  void _loginDemo(BuildContext context) {
    context.read<AuthProvider>().demoLogin(role);
    switch (role) {
      case UserRole.company:
        context.go('/company/dashboard');
        break;
      case UserRole.contractor:
        context.go('/contractor/dashboard');
        break;
      case UserRole.worker:
        context.go('/worker/dashboard');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sign in
              OutlinedButton(
                onPressed: () => context.go('/login/$_rolePath'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: color,
                  side: BorderSide(color: color.withOpacity(0.5)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
                child: const Text('Sign In'),
              ),
              const SizedBox(width: 8),
              // Demo
              ElevatedButton(
                onPressed: () => _loginDemo(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
                child: const Text('Demo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Demo Credentials Card ─────────────────────────────────────────────────────

class _DemoCredentialsCard extends StatefulWidget {
  const _DemoCredentialsCard();

  @override
  State<_DemoCredentialsCard> createState() => _DemoCredentialsCardState();
}

class _DemoCredentialsCardState extends State<_DemoCredentialsCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.accent.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.accent.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.key_rounded,
                      color: AppTheme.accentDark, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Demo Credentials',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppTheme.accentDark,
                              ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.accentDark,
                  ),
                ],
              ),
            ),
          ),
          // Body
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  for (final entry in MockData.demoCreds.entries) ...[
                    _CredRow(
                      roleLabel: entry.key,
                      email: entry.value['email']!,
                      password: entry.value['password']!,
                    ),
                    if (entry.key != MockData.demoCreds.keys.last)
                      const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _CredRow extends StatelessWidget {
  final String roleLabel;
  final String email;
  final String password;

  const _CredRow({
    required this.roleLabel,
    required this.email,
    required this.password,
  });

  void _copy(BuildContext context, String val) {
    Clipboard.setData(ClipboardData(text: val));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $val'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(roleLabel,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: AppTheme.primary)),
          const SizedBox(height: 8),
          _Field(
              label: 'Email',
              value: email,
              onCopy: () => _copy(context, email)),
          const SizedBox(height: 6),
          _Field(
              label: 'Password',
              value: password,
              onCopy: () => _copy(context, password)),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onCopy;

  const _Field(
      {required this.label, required this.value, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.textSecondary)),
        ),
        GestureDetector(
          onTap: onCopy,
          child: const Icon(Icons.copy_rounded,
              size: 16, color: AppTheme.textLight),
        ),
      ],
    );
  }
}
