import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/mock_data.dart';

class WorkerProvider extends ChangeNotifier {
  List<WorkerModel> get allWorkers => MockData.workers;

  List<WorkerModel> workersUnderContractor(String contractorId) =>
      MockData.workers.where((w) => w.contractorId == contractorId).toList();

  List<WorkerModel> get independentWorkers =>
      MockData.workers.where((w) => w.contractorId == null).toList();

  List<WorkerModel> searchWorkers({
    String? skill,
    String? city,
    AvailabilityStatus? availability,
  }) {
    return MockData.workers.where((w) {
      final skillMatch = skill == null || skill.isEmpty ||
          w.skills.any((s) => s.toLowerCase().contains(skill.toLowerCase()));
      final cityMatch = city == null || city.isEmpty ||
          w.city.toLowerCase().contains(city.toLowerCase());
      final availMatch = availability == null || w.availability == availability;
      return skillMatch && cityMatch && availMatch;
    }).toList();
  }

  void addWorker(WorkerModel worker) {
    MockData.workers.add(worker);
    notifyListeners();
  }

  void updateWorkerAvailability(String workerId, AvailabilityStatus status) {
    final idx = MockData.workers.indexWhere((w) => w.id == workerId);
    if (idx != -1) {
      MockData.workers[idx] = MockData.workers[idx].copyWith(availability: status);
      notifyListeners();
    }
  }
}
