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
    _authService.user.listen(_onAuthStateChanged);
  }

  void setTempRole(UserRole role) => _tempSignUpRole = role;

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
          companyName: 'My Contracting Firm',
          profileImageUrl: photo,
        );
      } else {
        _currentUser = Company(
          id: id,
          name: name,
          email: email,
          companyName: 'My Company',
          industry: 'General',
          role: role,
          profileImageUrl: photo,
        );
      }
    }
    _tempSignUpRole = null;
    _isInitializing = false;
    notifyListeners();
  }

  UserRole _determineRoleFromEmail(String? email) {
    if (email == null) return UserRole.individual;
    if (email.contains('contractor')) return UserRole.contractor;
    if (email.contains('company')) return UserRole.companyAdmin;
    return UserRole.individual;
  }

  // ── Mock Data ──────────────────────────────────────────────────────────────

  final List<Worker> _workers = [
    Worker(
      id: 'w1',
      name: 'John Doe',
      email: 'john@example.com',
      skills: ['Electrician', 'Solar Panel Installation'],
      bio: 'Professional electrician with 5 years experience.',
      location: 'Mumbai, MH',
      experience: '5 years',
      isAvailable: true,
      profileImageUrl: 'https://i.pravatar.cc/150?u=w1',
    ),
    Worker(
      id: 'w2',
      name: 'Jane Smith',
      email: 'jane@example.com',
      skills: ['Plumbing', 'Pipe Fitting'],
      bio: 'Certified plumber specializing in residential systems.',
      location: 'Pune, MH',
      experience: '3 years',
      isAvailable: false,
      profileImageUrl: 'https://i.pravatar.cc/150?u=w2',
    ),
    Worker(
      id: 'w3',
      name: 'Rahul Verma',
      email: 'rahul@example.com',
      skills: ['HVAC', 'Air Conditioning'],
      bio: 'HVAC specialist with residential & commercial experience.',
      location: 'Delhi, DL',
      experience: '7 years',
      isAvailable: true,
      profileImageUrl: 'https://i.pravatar.cc/150?u=w3',
    ),
    Worker(
      id: 'w4',
      name: 'Priya Sharma',
      email: 'priya@example.com',
      skills: ['Construction', 'Masonry'],
      bio: 'Experienced mason and construction site lead.',
      location: 'Bangalore, KA',
      experience: '4 years',
      isAvailable: true,
      profileImageUrl: 'https://i.pravatar.cc/150?u=w4',
    ),
  ];

  final List<Contractor> _contractors = [
    Contractor(
      id: 'c1',
      name: 'Mike Wilson',
      companyName: 'Wilson Contracting Ltd.',
      email: 'mike@wilson.com',
      servicesProvided: ['Electrical', 'Solar Energy'],
      description:
          'Full-scale electrical solutions for residential & commercial.',
      linkedWorkerIds: ['w1', 'w3'],
      rating: 4.8,
      profileImageUrl: 'https://i.pravatar.cc/150?u=c1',
    ),
    Contractor(
      id: 'c2',
      name: 'Sarah Connor',
      companyName: 'Connor Infrastructure',
      email: 'sarah@connor.com',
      servicesProvided: ['Plumbing', 'HVAC'],
      description:
          'Specializing in major plumbing and climate control systems.',
      linkedWorkerIds: ['w2', 'w4'],
      rating: 4.5,
      profileImageUrl: 'https://i.pravatar.cc/150?u=c2',
    ),
  ];

  final List<JobListing> _jobListings = [
    JobListing(
      id: 'j1',
      postedById: 'c1',
      postedByName: 'Wilson Contracting',
      postedByType: 'Contractor',
      title: 'Senior Electrician Needed',
      description:
          'Looking for a certified electrician for a 3-month commercial project. Must have experience with industrial wiring and solar installations.',
      requiredSkills: ['Electrician', 'Solar Panel Installation'],
      location: 'Mumbai, MH',
      duration: '3 months',
      wage: '₹800/day',
      category: JobCategory.electrical,
      postedAt: DateTime(2026, 3, 1),
    ),
    JobListing(
      id: 'j2',
      postedById: 'c2',
      postedByName: 'Connor Infrastructure',
      postedByType: 'Contractor',
      title: 'Plumber for Residential Complex',
      description:
          'Need skilled plumber for new residential complex plumbing setup.',
      requiredSkills: ['Plumbing', 'Pipe Fitting'],
      location: 'Pune, MH',
      duration: '2 months',
      wage: '₹700/day',
      category: JobCategory.plumbing,
      postedAt: DateTime(2026, 3, 2),
    ),
    JobListing(
      id: 'j3',
      postedById: 'comp1',
      postedByName: 'TechBuild Corp',
      postedByType: 'Company',
      title: 'HVAC Technician — Office Block',
      description:
          'Installing HVAC systems in a new office block. Ducting and chiller experience preferred.',
      requiredSkills: ['HVAC', 'Air Conditioning'],
      location: 'Delhi, DL',
      duration: '6 weeks',
      wage: '₹900/day',
      category: JobCategory.hvac,
      postedAt: DateTime(2026, 3, 2),
    ),
    JobListing(
      id: 'j4',
      postedById: 'comp2',
      postedByName: 'BuildRight Ltd.',
      postedByType: 'Company',
      title: 'Masonry & Construction Workers',
      description: 'Require 5 masons for a warehouse construction project.',
      requiredSkills: ['Construction', 'Masonry'],
      location: 'Bangalore, KA',
      duration: '4 months',
      wage: '₹650/day',
      category: JobCategory.construction,
      postedAt: DateTime(2026, 3, 3),
    ),
  ];

  final List<JobApplication> _applications = [];

  final List<WorkforceRequest> _workforceRequests = [
    WorkforceRequest(
      id: 'wr1',
      companyId: 'comp1',
      companyName: 'TechBuild Corp',
      requiredSkills: ['Electrician', 'Solar Panel Installation'],
      workerCount: 5,
      duration: '3 months',
      budget: '₹4L',
      location: 'Mumbai, MH',
      status: RequestStatus.pending,
    ),
    WorkforceRequest(
      id: 'wr2',
      companyId: 'comp2',
      companyName: 'BuildRight Ltd.',
      requiredSkills: ['Plumbing', 'HVAC'],
      workerCount: 3,
      duration: '2 months',
      budget: '₹2.5L',
      location: 'Pune, MH',
      status: RequestStatus.pending,
    ),
  ];

  final List<JobRequest> _requests = [];
  final List<ProjectContract> _contracts = [];

  List<Worker> get workers => _workers;
  List<Contractor> get contractors => _contractors;
  List<JobListing> get jobListings => _jobListings;
  List<JobApplication> get applications => _applications;
  List<WorkforceRequest> get workforceRequests => _workforceRequests;
  List<JobRequest> get requests => _requests;
  List<ProjectContract> get contracts => _contracts;

  // ── Actions ────────────────────────────────────────────────────────────────

  bool hasApplied(String jobId) => _applications.any((a) => a.jobId == jobId);

  void applyToJob(String jobId, String workerId) {
    if (!hasApplied(jobId)) {
      _applications.add(
        JobApplication(
          id: 'app${_applications.length + 1}',
          jobId: jobId,
          workerId: workerId,
        ),
      );
      notifyListeners();
    }
  }

  JobListing? getJobById(String id) => _jobListings.firstWhere(
    (j) => j.id == id,
    orElse: () => _jobListings.first,
  );

  void updateWorkforceRequestStatus(String id, RequestStatus status) {
    final idx = _workforceRequests.indexWhere((r) => r.id == id);
    if (idx != -1) {
      _workforceRequests[idx].status = status;
      notifyListeners();
    }
  }

  void addWorkforceRequest(WorkforceRequest req) {
    _workforceRequests.add(req);
    notifyListeners();
  }

  void sendRequest(String senderId, String receiverId, String? message) {
    _requests.add(
      JobRequest(
        id: 'req${_requests.length + 1}',
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateRequestStatus(String requestId, RequestStatus status) {
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      _requests[idx] = JobRequest(
        id: _requests[idx].id,
        senderId: _requests[idx].senderId,
        receiverId: _requests[idx].receiverId,
        message: _requests[idx].message,
        createdAt: _requests[idx].createdAt,
        status: status,
      );
      notifyListeners();
    }
  }

  Future<void> loginWithEmail(String email, String password) async =>
      _authService.signInWithEmail(email, password);

  Future<void> signUpWithEmail(String email, String password) async =>
      _authService.signUpWithEmail(email, password);

  Future<void> loginWithGoogle() async => _authService.signInWithGoogle();

  Future<void> logout() async => _authService.signOut();
}
