import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text('Welcome to',
                  style:
                      TextStyle(fontSize: 18, color: AppTheme.textSecondary)),
              const Text('SENA',
                  style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primary,
                      letterSpacing: 4)),
              const SizedBox(height: 8),
              const Text('Choose how you want to continue',
                  style:
                      TextStyle(color: AppTheme.textSecondary, fontSize: 15)),
              const SizedBox(height: 40),
              _RoleCard(
                icon: Icons.engineering_rounded,
                title: 'Worker',
                subtitle: 'Find work opportunities that match your skills',
                color: const Color(0xFF10B981),
                onTap: () => context.go('/login/worker'),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.supervisor_account_rounded,
                title: 'Contractor',
                subtitle: 'Manage your workers and respond to company requests',
                color: const Color(0xFF8B5CF6),
                onTap: () => context.go('/login/contractor'),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.business_rounded,
                title: 'Company',
                subtitle: 'Browse and hire skilled workers for your projects',
                color: AppTheme.primary,
                onTap: () => context.go('/login/company'),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'Sena © 2026  •  Empowering Labour',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 6))
          ],
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: color)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
