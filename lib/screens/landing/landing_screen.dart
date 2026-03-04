import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Subtle hero gradient header band
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.42,
              decoration: const BoxDecoration(
                gradient: AppTheme.heroGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Hero section ─────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                    child: Column(
                      children: [
                        // Logo
                        FadeInDown(
                          duration: const Duration(milliseconds: 600),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.hub_rounded,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Title
                        FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          child: Text(
                            'SENA',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  letterSpacing: 6,
                                  fontSize: 48,
                                ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Subtitle
                        FadeInUp(
                          delay: const Duration(milliseconds: 100),
                          child: Text(
                            'The Bridge Between Talent,\nContractors & Companies',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 15,
                                  height: 1.6,
                                ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Stats row
                        FadeIn(
                          delay: const Duration(milliseconds: 300),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _StatChip(label: '10k+ Workers'),
                              const SizedBox(width: 10),
                              _StatChip(label: '500+ Companies'),
                              const SizedBox(width: 10),
                              _StatChip(label: '200+ Contractors'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),

                  // ── Role cards ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInLeft(
                          delay: const Duration(milliseconds: 200),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 14),
                            child: Text(
                              'CHOOSE YOUR ROLE',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.secondaryTextColor,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),

                        _RoleCard(
                          delay: 300,
                          title: 'Individual Worker',
                          subtitle:
                              'Find jobs, connect with contractors, and grow your career.',
                          icon: Icons.person_search_rounded,
                          gradient: AppTheme.workerGradient,
                          glowColor: AppTheme.workerColor,
                          tag: 'Worker',
                          tagColor: AppTheme.workerColor,
                          onTap: () => context.push('/auth?role=individual'),
                        ),
                        const SizedBox(height: 14),

                        _RoleCard(
                          delay: 420,
                          title: 'Contractor',
                          subtitle:
                              'Manage your team, accept projects, and scale your business.',
                          icon: Icons.engineering_rounded,
                          gradient: AppTheme.contractorGradient,
                          glowColor: AppTheme.contractorColor,
                          tag: 'Contractor',
                          tagColor: AppTheme.contractorColor,
                          onTap: () => context.push('/auth?role=contractor'),
                        ),
                        const SizedBox(height: 14),

                        _RoleCard(
                          delay: 540,
                          title: 'Company',
                          subtitle:
                              'Post jobs, hire top talent, and partner with contractors.',
                          icon: Icons.business_rounded,
                          gradient: AppTheme.companyGradient,
                          glowColor: AppTheme.companyColor,
                          tag: 'Company',
                          tagColor: AppTheme.companyColor,
                          onTap: () => context.push('/auth?role=company'),
                        ),
                        const SizedBox(height: 32),

                        // Footer
                        Center(
                          child: Text(
                            'Powered by Sena Network · v1.0',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat Chip ─────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label;
  const _StatChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── Role Card ─────────────────────────────────────────────────────────────────
class _RoleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final Color glowColor;
  final String tag;
  final Color tagColor;
  final VoidCallback onTap;
  final int delay;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.glowColor,
    required this.tag,
    required this.tagColor,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.975,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      delay: Duration(milliseconds: widget.delay),
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _pressed = true);
          _ctrl.forward();
        },
        onTapUp: (_) {
          setState(() => _pressed = false);
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          setState(() => _pressed = false);
          _ctrl.reverse();
        },
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) =>
              Transform.scale(scale: _scale.value, child: child),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _pressed
                    ? widget.glowColor.withValues(alpha: 0.4)
                    : AppTheme.borderColor,
              ),
              boxShadow: _pressed
                  ? AppTheme.glowFor(widget.glowColor)
                  : AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                // Gradient icon box
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: widget.tagColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.tag,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: widget.tagColor,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppTheme.mutedTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
