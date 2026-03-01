import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/mock_data.dart';

class AuthProvider extends ChangeNotifier {
  UserRole? _currentRole;
  WorkerModel? _currentWorker;
  ContractorModel? _currentContractor;
  CompanyModel? _currentCompany;
  bool _isLoggedIn = false;

  UserRole? get currentRole => _currentRole;
  WorkerModel? get currentWorker => _currentWorker;
  ContractorModel? get currentContractor => _currentContractor;
  CompanyModel? get currentCompany => _currentCompany;
  bool get isLoggedIn => _isLoggedIn;

  // Simulate login with mock data
  void loginAsWorker(String email) {
    _currentRole = UserRole.worker;
    _currentWorker = MockData.workers.firstWhere(
      (w) => w.email == email,
      orElse: () => MockData.workers.first,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  void loginAsContractor(String email) {
    _currentRole = UserRole.contractor;
    _currentContractor = MockData.contractors.firstWhere(
      (c) => c.email == email,
      orElse: () => MockData.contractors.first,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  void loginAsCompany(String email) {
    _currentRole = UserRole.company;
    _currentCompany = MockData.companies.firstWhere(
      (co) => co.email == email,
      orElse: () => MockData.companies.first,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  // Demo login by role
  void demoLogin(UserRole role) {
    _currentRole = role;
    _isLoggedIn = true;
    switch (role) {
      case UserRole.worker:
        _currentWorker = MockData.workers.firstWhere((w) => w.contractorId == null);
        break;
      case UserRole.contractor:
        _currentContractor = MockData.contractors.first;
        break;
      case UserRole.company:
        _currentCompany = MockData.companies.first;
        break;
    }
    notifyListeners();
  }

  void toggleWorkerAvailability() {
    if (_currentWorker == null) return;
    _currentWorker = _currentWorker!.copyWith(
      availability: _currentWorker!.availability == AvailabilityStatus.available
          ? AvailabilityStatus.unavailable
          : AvailabilityStatus.available,
    );
    // Also update mock data
    final idx = MockData.workers.indexWhere((w) => w.id == _currentWorker!.id);
    if (idx != -1) MockData.workers[idx] = _currentWorker!;
    notifyListeners();
  }

  void toggleContractorAvailability() {
    if (_currentContractor == null) return;
    _currentContractor = _currentContractor!.copyWith(
      availability: _currentContractor!.availability == AvailabilityStatus.available
          ? AvailabilityStatus.unavailable
          : AvailabilityStatus.available,
    );
    final idx = MockData.contractors.indexWhere((c) => c.id == _currentContractor!.id);
    if (idx != -1) MockData.contractors[idx] = _currentContractor!;
    notifyListeners();
  }

  void logout() {
    _currentRole = null;
    _currentWorker = null;
    _currentContractor = null;
    _currentCompany = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
