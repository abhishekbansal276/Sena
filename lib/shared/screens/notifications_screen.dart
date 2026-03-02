import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/mock_data.dart';
import '../../shared/widgets/app_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Mark all as read when screen opens
    for (final n in MockData.notifications) {
      n.isRead = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = MockData.notifications;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notifications.isEmpty
          ? const EmptyState(
              message: 'No notifications yet',
              icon: Icons.notifications_off_outlined)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final n = notifications[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.divider),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.primary.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_outlined,
                          color: AppTheme.primary, size: 20),
                    ),
                    title: Text(n.title,
                        style: Theme.of(context).textTheme.headlineSmall),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(n.message,
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text(DateFormat('d MMM y, h:mm a').format(n.time),
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
