import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────
// AppButton — primary / secondary / accent
// ─────────────────────────────────────────────
enum AppButtonStyle { primary, secondary, accent, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final AppButtonStyle style;
  final bool isLoading;
  final IconData? icon;
  final bool expand;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.style = AppButtonStyle.primary,
    this.isLoading = false,
    this.icon,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (style) {
      case AppButtonStyle.secondary:
        bg = Colors.transparent;
        fg = AppTheme.primary;
        break;
      case AppButtonStyle.accent:
        bg = AppTheme.accent;
        fg = AppTheme.textPrimary;
        break;
      case AppButtonStyle.danger:
        bg = AppTheme.error;
        fg = Colors.white;
        break;
      default:
        bg = AppTheme.primary;
        fg = Colors.white;
    }

    Widget child = isLoading
        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: fg, strokeWidth: 2))
        : Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 18, color: fg), const SizedBox(width: 8)],
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: fg, fontSize: 15)),
            ],
          );

    if (style == AppButtonStyle.secondary) {
      return SizedBox(
        width: expand ? double.infinity : null,
        child: OutlinedButton(
          onPressed: isLoading ? null : onTap,
          child: child,
        ),
      );
    }

    return SizedBox(
      width: expand ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(backgroundColor: bg, foregroundColor: fg),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// AppTextField
// ─────────────────────────────────────────────
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(action!, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Avatar with initials fallback
// ─────────────────────────────────────────────
class UserAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double radius;

  const UserAvatar({super.key, required this.name, this.imageUrl, this.radius = 28});

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return CircleAvatar(radius: radius, backgroundImage: NetworkImage(imageUrl!));
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppTheme.primary,
      child: Text(_initials,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: radius * 0.7)),
    );
  }
}

// ─────────────────────────────────────────────
// Status Badge Chip
// ─────────────────────────────────────────────
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

// ─────────────────────────────────────────────
// Stat Card
// ─────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Gradient Header
// ─────────────────────────────────────────────
class GradientHeader extends StatelessWidget {
  final String greeting;
  final String name;
  final int unreadCount;
  final VoidCallback onNotificationTap;

  const GradientHeader({
    super.key,
    required this.greeting,
    required this.name,
    required this.unreadCount,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting,
                    style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(name,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                onPressed: onNotificationTap,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle),
                    child: Center(
                        child: Text('$unreadCount',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black))),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyState({super.key, required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: AppTheme.textLight),
          const SizedBox(height: 16),
          Text(message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
