import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;
  UserRole? _tempSignUpRole;

  AuthProvider() {
    // Listen to auth state changes
    _authService.user.listen(_onAuthStateChanged);
  }

  void setTempRole(UserRole role) {
    _tempSignUpRole = role;
  }

  void _onAuthStateChanged(fb.User? user) {
    debugPrint('AuthProvider: Auth state changed. User: ${user?.email}');
    if (user == null) {
      _currentUser = null;
    } else {
      final role = _tempSignUpRole ?? _determineRoleFromEmail(user.email);
      final id = user.uid;
      final name = user.displayName ?? user.email?.split('@')[0] ?? 'User';
      final email = user.email ?? '';
      final photo = user.photoURL;

      if (role == UserRole.individual) {
        _currentUser = Worker(
          id: id,
          name: name,
          email: email,
          profileImageUrl: photo,
        );
      } else if (role == UserRole.contractor) {
        _currentUser = Contractor(
          id: id,
          name: name,
          email: email,
          companyName: 'New Contractor',
          profileImageUrl: photo,
        );
      } else {
        _currentUser = Company(
          id: id,
          name: name,
          email: email,
          companyName: 'New Company',
          industry: 'General',
          role: role,
          profileImageUrl: photo,
        );
      }
      debugPrint('AuthProvider: Current user set as ${_currentUser.runtimeType} with role: ${role}');
    }
    _tempSignUpRole = null; // Reset after use
    _isInitializing = false;
    notifyListeners();
  }

  UserRole _determineRoleFromEmail(String? email) {
    if (email == null) return UserRole.individual;
    if (email.contains('contractor')) return UserRole.contractor;
    if (email.contains('company')) return UserRole.companyAdmin;
    return UserRole.individual;
  }

  // Mock data lists
  final List<Worker> _workers = [
    Worker(
      id: 'w1',
      name: 'John Doe',
      email: 'john@example.com',
      skills: ['Electrician', 'Solar Panel Installation'],
      bio: 'Professional electrician with 5 years experience.',
      profileImageUrl: 'https://i.pravatar.cc/150?u=w1',
    ),
    Worker(
      id: 'w2',
      name: 'Jane Smith',
      email: 'jane@example.com',
      skills: ['Plumbing', 'Pipe Fitting'],
      bio: 'Certified plumber specializing in residential systems.',
      profileImageUrl: 'https://i.pravatar.cc/150?u=w2',
    ),
  ];

  final List<Contractor> _contractors = [
    Contractor(
      id: 'c1',
      name: 'Mike Wilson',
      companyName: 'Wilson Contracting Ltd.',
      email: 'mike@wilson.com',
      servicesProvided: ['Electrical', 'Solar Energy'],
      description: 'We provide full scale electrical solutions.',
      profileImageUrl: 'https://i.pravatar.cc/150?u=c1',
    ),
    Contractor(
      id: 'c2',
      name: 'Sarah Connor',
      companyName: 'Connor Infrastructure',
      email: 'sarah@connor.com',
      servicesProvided: ['Plumbing', 'HVAC'],
      description: 'Specializing in major plumbing and climate control systems.',
      profileImageUrl: 'https://i.pravatar.cc/150?u=c2',
    ),
  ];

  final List<JobRequest> _requests = [];
  final List<ProjectContract> _contracts = [];

  List<Worker> get workers => _workers;
  List<Contractor> get contractors => _contractors;
  List<JobRequest> get requests => _requests;
  List<ProjectContract> get contracts => _contracts;

  Future<void> loginWithEmail(String email, String password) async {
    await _authService.signInWithEmail(email, password);
  }

  Future<void> signUpWithEmail(String email, String password) async {
    await _authService.signUpWithEmail(email, password);
  }

  Future<void> loginWithGoogle() async {
    await _authService.signInWithGoogle();
  }

  Future<void> logout() async {
    await _authService.signOut();
  }

  void sendRequest(String senderId, String receiverId, String? message) {
    final newRequest = JobRequest(
      id: 'req${_requests.length + 1}',
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      createdAt: DateTime.now(),
    );
    _requests.add(newRequest);
    notifyListeners();
  }

  void updateRequestStatus(String requestId, RequestStatus status) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _requests[index] = JobRequest(
        id: _requests[index].id,
        senderId: _requests[index].senderId,
        receiverId: _requests[index].receiverId,
        message: _requests[index].message,
        createdAt: _requests[index].createdAt,
        status: status,
      );
      notifyListeners();
    }
  }
}
