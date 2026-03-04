import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'models/app_models.dart';
import 'screens/landing/landing_screen.dart';
import 'screens/landing/auth_screen.dart';
import 'screens/individual/worker_dashboard.dart';
import 'screens/contractor/contractor_dashboard.dart';
import 'screens/company/company_dashboard.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const SenaApp(),
    ),
  );
}

class SenaApp extends StatefulWidget {
  const SenaApp({super.key});

  @override
  State<SenaApp> createState() => _SenaAppState();
}

class _SenaAppState extends State<SenaApp> {
  GoRouter? _router;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show a splash/loading screen while Firebase is checking for an existing session
        if (authProvider.isInitializing) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: AppTheme.glowShadow,
                      ),
                      child: const Icon(
                        Icons.hub_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                      strokeWidth: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        _router ??= GoRouter(
          initialLocation: '/',
          refreshListenable: authProvider,
          redirect: (context, state) {
            final auth = context.read<AuthProvider>();
            final bool loggingIn =
                state.matchedLocation == '/auth' ||
                state.matchedLocation == '/';

            debugPrint(
              'GoRouter Redirect: location=${state.matchedLocation}, user=${auth.currentUser?.email}, role=${auth.currentUser?.role}',
            );

            if (auth.currentUser == null) {
              debugPrint('GoRouter: No user, allowing landing/auth access');
              return loggingIn ? null : '/';
            }

            if (loggingIn) {
              final role = auth.currentUser!.role;
              debugPrint(
                'GoRouter: Logged in user at root/auth, redirecting to dashboard for role=$role',
              );
              if (role == UserRole.individual) return '/worker-dashboard';
              if (role == UserRole.contractor) return '/contractor-dashboard';
              return '/company-dashboard';
            }

            return null;
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const LandingScreen(),
            ),
            GoRoute(
              path: '/auth',
              builder: (context, state) {
                final roleString =
                    state.uri.queryParameters['role'] ?? 'individual';
                UserRole role;
                if (roleString == 'contractor') {
                  role = UserRole.contractor;
                } else if (roleString == 'company') {
                  role = UserRole.companyAdmin;
                } else {
                  role = UserRole.individual;
                }
                return AuthScreen(role: role);
              },
            ),
            GoRoute(
              path: '/worker-dashboard',
              builder: (context, state) => const WorkerDashboard(),
            ),
            GoRoute(
              path: '/contractor-dashboard',
              builder: (context, state) => const ContractorDashboard(),
            ),
            GoRoute(
              path: '/company-dashboard',
              builder: (context, state) => const CompanyDashboard(),
            ),
          ],
        );

        return MaterialApp.router(
          title: 'SENA',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: _router!,
        );
      },
    );
  }
}
