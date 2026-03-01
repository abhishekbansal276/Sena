import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/providers/auth_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class WorkerSelfProfileScreen extends StatelessWidget {
  const WorkerSelfProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final worker = context.watch<AuthProvider>().currentWorker;
    if (worker == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final avail = worker.availability == AvailabilityStatus.available;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              UserAvatar(name: worker.fullName, radius: 48),
              const SizedBox(height: 12),
              Text(worker.fullName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Age: ${worker.age}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                StatusChip(label: avail ? '✅ Available' : '🔴 Busy', color: avail ? Colors.white : Colors.redAccent),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Skills', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: worker.skills.map((s) =>
                  Chip(label: Text(s), backgroundColor: const Color(0xFF10B981).withOpacity(0.1))).toList()),
                if (worker.yearsOfExperience != null) ...[
                  const Divider(height: 20),
                  Row(children: [
                    const Icon(Icons.work_history_outlined, size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 6),
                    Text('${worker.yearsOfExperience} year(s) experience', style: Theme.of(context).textTheme.bodyMedium),
                  ]),
                ],
              ]),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                _Row(Icons.location_on_outlined, '${worker.city}, ${worker.state}'),
                _Row(Icons.phone_outlined, worker.phone),
                _Row(Icons.email_outlined, worker.email),
                _Row(Icons.credit_card_outlined, 'Aadhaar: ${worker.aadhaarNumber}'),
                if (worker.languages.isNotEmpty)
                  _Row(Icons.translate_rounded, worker.languages.join(', ')),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Row(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF10B981), size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
      ]),
    );
  }
}
