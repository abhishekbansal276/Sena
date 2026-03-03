import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../theme/app_theme.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.backgroundColor, AppTheme.surfaceColor],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.hub_rounded, size: 64, color: AppTheme.primaryColor),
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    'SENA',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      letterSpacing: 4,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'The Bridge Between Talent, Contractors, and Companies',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.secondaryTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                _buildRoleCard(
                  context,
                  title: 'Individual Worker',
                  subtitle: 'Connect with contractors and build your career.',
                  icon: Icons.person_search_rounded,
                  color: AppTheme.primaryColor,
                  onTap: () => context.push('/auth?role=individual'),
                ),
                const SizedBox(height: 16),
                _buildRoleCard(
                  context,
                  title: 'Contractor',
                  subtitle: 'Manage workers and handle company requests.',
                  icon: Icons.engineering_rounded,
                  color: AppTheme.accentColor,
                  onTap: () => context.push('/auth?role=contractor'),
                ),
                const SizedBox(height: 16),
                _buildRoleCard(
                  context,
                  title: 'Company',
                  subtitle: 'Hire workers or partner with top contractors.',
                  icon: Icons.business_rounded,
                  color: Colors.orangeAccent,
                  onTap: () => context.push('/auth?role=company'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return FadeInRight(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppTheme.secondaryTextColor),
            ],
          ),
        ),
      ),
    );
  }
}
