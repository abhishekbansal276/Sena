import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/app_models.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  final UserRole role;
  const AuthScreen({super.key, required this.role});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // ── Role config ────────────────────────────────────────────────────────────
  LinearGradient get _gradient {
    switch (widget.role) {
      case UserRole.individual:
        return AppTheme.workerGradient;
      case UserRole.contractor:
        return AppTheme.contractorGradient;
      default:
        return AppTheme.companyGradient;
    }
  }

  Color get _roleColor {
    switch (widget.role) {
      case UserRole.individual:
        return AppTheme.workerColor;
      case UserRole.contractor:
        return AppTheme.contractorColor;
      default:
        return AppTheme.companyColor;
    }
  }

  IconData get _roleIcon {
    switch (widget.role) {
      case UserRole.individual:
        return Icons.person_search_rounded;
      case UserRole.contractor:
        return Icons.engineering_rounded;
      default:
        return Icons.business_rounded;
    }
  }

  String get _roleLabel {
    switch (widget.role) {
      case UserRole.individual:
        return 'Worker';
      case UserRole.contractor:
        return 'Contractor';
      default:
        return 'Company';
    }
  }

  // ── Handlers ───────────────────────────────────────────────────────────────
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFFC8181),
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAuth() async {
    setState(() => _isLoading = true);
    final provider = context.read<AuthProvider>();
    provider.setTempRole(widget.role);
    try {
      if (_isSignUp) {
        await provider.signUpWithEmail(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        await provider.loginWithEmail(
          _emailController.text,
          _passwordController.text,
        );
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final provider = context.read<AuthProvider>();
    provider.setTempRole(widget.role);
    try {
      await provider.loginWithGoogle();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // ── Compact header band ─────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: _gradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // Role icon
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              _roleIcon,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isSignUp ? 'Create Account' : 'Welcome Back',
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Signing in as $_roleLabel',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Form ──────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),

                    // Email field
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password field
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Primary CTA
                    if (_isLoading)
                      Center(
                        child: CircularProgressIndicator(color: _roleColor),
                      )
                    else ...[
                      _GradientButton(
                        label: _isSignUp ? 'Create Account' : 'Sign In',
                        gradient: _gradient,
                        glowColor: _roleColor,
                        onTap: _handleAuth,
                      ),
                      const SizedBox(height: 20),

                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'or continue with',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.mutedTextColor,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Google
                      OutlinedButton.icon(
                        onPressed: _handleGoogleSignIn,
                        icon: const FaIcon(FontAwesomeIcons.google, size: 16),
                        label: const Text('Continue with Google'),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // Toggle
                    Center(
                      child: GestureDetector(
                        onTap: () => setState(() => _isSignUp = !_isSignUp),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppTheme.secondaryTextColor,
                            ),
                            children: [
                              TextSpan(
                                text: _isSignUp
                                    ? 'Already have an account? '
                                    : "Don't have an account? ",
                              ),
                              TextSpan(
                                text: _isSignUp ? 'Sign In' : 'Sign Up',
                                style: TextStyle(
                                  color: _roleColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
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

// ── Gradient Button ───────────────────────────────────────────────────────────
class _GradientButton extends StatefulWidget {
  final String label;
  final LinearGradient gradient;
  final Color glowColor;
  final VoidCallback onTap;
  const _GradientButton({
    required this.label,
    required this.gradient,
    required this.glowColor,
    required this.onTap,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
