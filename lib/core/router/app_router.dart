import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/auth/role_selection_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/worker_registration_screen.dart';
import '../../features/auth/contractor_registration_screen.dart';
import '../../features/auth/company_registration_screen.dart';
import '../../features/company/company_dashboard_screen.dart';
import '../../features/company/browse_screen.dart';
import '../../features/company/contractor_profile_screen.dart';
import '../../features/company/worker_profile_screen.dart';
import '../../features/company/create_hiring_request_screen.dart';
import '../../features/company/sent_requests_screen.dart';
import '../../features/contractor/contractor_dashboard_screen.dart';
import '../../features/contractor/manage_workers_screen.dart';
import '../../features/contractor/add_worker_screen.dart';
import '../../features/contractor/incoming_requests_screen.dart';
import '../../features/worker/worker_dashboard_screen.dart';
import '../../features/worker/worker_profile_screen.dart';
import '../../features/worker/worker_requests_screen.dart';
import '../../shared/screens/notifications_screen.dart';
import '../../shared/screens/request_detail_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/starting_screen.dart';

class AppRouter {
  static GoRouter router(AuthProvider auth) {
    return GoRouter(
      initialLocation: '/home',
      redirect: (context, state) {
        // No redirects needed — demo login handles routing
        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/start', builder: (_, __) => const StartingScreen()),
        GoRoute(
            path: '/role-select',
            builder: (_, __) => const RoleSelectionScreen()),
        GoRoute(
          path: '/login/:role',
          builder: (_, state) {
            final role = _parseRole(state.pathParameters['role'] ?? 'worker');
            return LoginScreen(role: role);
          },
        ),
        GoRoute(
            path: '/register/worker',
            builder: (_, __) => const WorkerRegistrationScreen()),
        GoRoute(
            path: '/register/contractor',
            builder: (_, __) => const ContractorRegistrationScreen()),
        GoRoute(
            path: '/register/company',
            builder: (_, __) => const CompanyRegistrationScreen()),

        // Company routes
        GoRoute(
            path: '/company/dashboard',
            builder: (_, __) => const CompanyDashboardScreen()),
        GoRoute(
            path: '/company/browse', builder: (_, __) => const BrowseScreen()),
        GoRoute(
          path: '/company/contractor/:id',
          builder: (_, state) => ContractorProfileScreen(
              contractorId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/company/worker/:id',
          builder: (_, state) =>
              WorkerProfileScreen(workerId: state.pathParameters['id']!),
        ),
        GoRoute(
            path: '/company/create-request',
            builder: (_, __) => const CreateHiringRequestScreen()),
        GoRoute(
            path: '/company/sent-requests',
            builder: (_, __) => const SentRequestsScreen()),

        // Contractor routes
        GoRoute(
            path: '/contractor/dashboard',
            builder: (_, __) => const ContractorDashboardScreen()),
        GoRoute(
            path: '/contractor/workers',
            builder: (_, __) => const ManageWorkersScreen()),
        GoRoute(
            path: '/contractor/add-worker',
            builder: (_, __) => const AddWorkerScreen()),
        GoRoute(
            path: '/contractor/requests',
            builder: (_, __) => const IncomingRequestsScreen()),

        // Worker routes
        GoRoute(
            path: '/worker/dashboard',
            builder: (_, __) => const WorkerDashboardScreen()),
        GoRoute(
            path: '/worker/profile',
            builder: (_, __) => const WorkerSelfProfileScreen()),
        GoRoute(
            path: '/worker/requests',
            builder: (_, __) => const WorkerRequestsScreen()),

        // Shared
        GoRoute(
            path: '/notifications',
            builder: (_, __) => const NotificationsScreen()),
        GoRoute(
          path: '/request-detail/:id',
          builder: (_, state) =>
              RequestDetailScreen(requestId: state.pathParameters['id']!),
        ),
      ],
    );
  }

  static UserRole _parseRole(String s) {
    switch (s) {
      case 'contractor':
        return UserRole.contractor;
      case 'company':
        return UserRole.company;
      default:
        return UserRole.worker;
    }
  }
}
