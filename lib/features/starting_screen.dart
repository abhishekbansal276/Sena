import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/providers/auth_provider.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.currentWorker?.fullName ??
        auth.currentContractor?.fullName ??
        auth.currentCompany?.companyName ??
        'there';

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthProvider>().logout();
              context.go('/home');
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Hello, $name 👋',
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
