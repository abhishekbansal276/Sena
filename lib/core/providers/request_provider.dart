import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/mock_data.dart';

// WorkerProvider is defined in worker_provider.dart

class RequestProvider extends ChangeNotifier {
  List<HiringRequest> get allRequests => MockData.hiringRequests;

  List<HiringRequest> requestsForContractor(String contractorId) =>
      MockData.hiringRequests.where((r) => r.contractorId == contractorId).toList();

  List<HiringRequest> requestsForWorker(String workerId) =>
      MockData.hiringRequests.where((r) => r.workerId == workerId).toList();

  List<HiringRequest> requestsForCompany(String companyId) =>
      MockData.hiringRequests.where((r) => r.companyId == companyId).toList();

  void updateRequestStatus(String requestId, RequestStatus status) {
    final idx = MockData.hiringRequests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      MockData.hiringRequests[idx] = MockData.hiringRequests[idx].copyWith(status: status);
      // Add notification
      final req = MockData.hiringRequests[idx];
      final title = status == RequestStatus.accepted ? 'Request Accepted' : 'Request Rejected';
      final msg = status == RequestStatus.accepted
          ? '${req.companyName}\'s request for ${req.skillRequired} was accepted.'
          : '${req.companyName}\'s request for ${req.skillRequired} was rejected.';
      MockData.notifications.insert(
        0,
        AppNotification(
          id: 'n${DateTime.now().millisecondsSinceEpoch}',
          title: title,
          message: msg,
          time: DateTime.now(),
        ),
      );
      notifyListeners();
    }
  }

  void addHiringRequest(HiringRequest request) {
    MockData.hiringRequests.insert(0, request);
    MockData.notifications.insert(
      0,
      AppNotification(
        id: 'n${DateTime.now().millisecondsSinceEpoch}',
        title: 'New Hiring Request Sent',
        message: 'You sent a hiring request for ${request.workersRequired} ${request.skillRequired}(s).',
        time: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
