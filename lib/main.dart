import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/request_provider.dart';
import 'core/providers/worker_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => WorkerProvider()),
      ],
      child: const SenaApp(),
    ),
  );
}

class SenaApp extends StatelessWidget {
  const SenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return MaterialApp.router(
      title: 'Sena – Labour Hiring',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router(authProvider),
    );
  }
}
