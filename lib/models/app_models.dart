enum UserRole {
  individual,
  contractor,
  companyAdmin,
  companyHR,
  companySecurity,
}

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
  final String location;
  final String experience;
  final List<String> connectedContractorIds;

  Worker({
    required super.id,
    required super.name,
    required super.email,
    this.skills = const [],
    this.bio = '',
    this.isAvailable = true,
    this.location = 'Not specified',
    this.experience = '0 years',
    this.connectedContractorIds = const [],
    super.profileImageUrl,
  }) : super(role: UserRole.individual);
}

class Contractor extends AppUser {
  final String companyName;
  final List<String> servicesProvided;
  final List<String> linkedWorkerIds;
  final String description;
  final double rating;

  Contractor({
    required super.id,
    required super.name,
    required super.email,
    required this.companyName,
    this.servicesProvided = const [],
    this.linkedWorkerIds = const [],
    this.description = '',
    this.rating = 4.5,
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

// ── New Models ─────────────────────────────────────────────────────────────────

enum JobCategory {
  electrical,
  plumbing,
  hvac,
  construction,
  security,
  cleaning,
  general,
}

enum ApplicationStatus { applied, shortlisted, accepted, rejected }

class JobListing {
  final String id;
  final String postedById; // contractor or company id
  final String postedByName;
  final String postedByType; // 'Contractor' | 'Company'
  final String title;
  final String description;
  final List<String> requiredSkills;
  final String location;
  final String duration;
  final String wage;
  final JobCategory category;
  final DateTime postedAt;

  JobListing({
    required this.id,
    required this.postedById,
    required this.postedByName,
    required this.postedByType,
    required this.title,
    required this.description,
    required this.requiredSkills,
    required this.location,
    required this.duration,
    required this.wage,
    required this.category,
    required this.postedAt,
  });
}

class JobApplication {
  final String id;
  final String jobId;
  final String workerId;
  ApplicationStatus status;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.workerId,
    this.status = ApplicationStatus.applied,
  });
}

class WorkforceRequest {
  final String id;
  final String companyId;
  final String companyName;
  final String? assignedContractorId;
  final List<String> requiredSkills;
  final int workerCount;
  final String duration;
  final String budget;
  final String location;
  RequestStatus status;

  WorkforceRequest({
    required this.id,
    required this.companyId,
    required this.companyName,
    this.assignedContractorId,
    required this.requiredSkills,
    required this.workerCount,
    required this.duration,
    required this.budget,
    required this.location,
    this.status = RequestStatus.pending,
  });
}

class WorkerAllocation {
  final String workerId;
  final String workerName;
  final String? assignedRequestId;
  bool isAssigned;

  WorkerAllocation({
    required this.workerId,
    required this.workerName,
    this.assignedRequestId,
    this.isAssigned = false,
  });
}
