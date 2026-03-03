enum UserRole { individual, contractor, companyAdmin, companyHR, companySecurity }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImageUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImageUrl,
  });
}

class Worker extends AppUser {
  final List<String> skills;
  final String bio;
  final bool isAvailable;
  final List<String> connectedContractorIds;

  Worker({
    required super.id,
    required super.name,
    required super.email,
    this.skills = const [],
    this.bio = '',
    this.isAvailable = true,
    this.connectedContractorIds = const [],
    super.profileImageUrl,
  }) : super(role: UserRole.individual);
}

class Contractor extends AppUser {
  final String companyName;
  final List<String> servicesProvided;
  final List<String> linkedWorkerIds;
  final String description;

  Contractor({
    required super.id,
    required super.name,
    required super.email,
    required this.companyName,
    this.servicesProvided = const [],
    this.linkedWorkerIds = const [],
    this.description = '',
    super.profileImageUrl,
  }) : super(role: UserRole.contractor);
}

class Company extends AppUser {
  final String companyName;
  final String industry;
  final List<String> activeContractIds;

  Company({
    required super.id,
    required super.name,
    required super.email,
    required this.companyName,
    required this.industry,
    required super.role,
    this.activeContractIds = const [],
    super.profileImageUrl,
  });
}

enum RequestStatus { pending, accepted, rejected, completed }

class JobRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final String? message;
  final RequestStatus status;
  final DateTime createdAt;

  JobRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.message,
    this.status = RequestStatus.pending,
    required this.createdAt,
  });
}

class ProjectContract {
  final String id;
  final String companyId;
  final String? contractorId;
  final String? individualWorkerId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isOngoing;

  ProjectContract({
    required this.id,
    required this.companyId,
    this.contractorId,
    this.individualWorkerId,
    required this.title,
    required this.description,
    required this.startDate,
    this.endDate,
    this.isOngoing = true,
  });
}
