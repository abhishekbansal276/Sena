enum UserRole { worker, contractor, company }

enum AvailabilityStatus { available, unavailable }

enum RequestStatus { pending, accepted, rejected }

enum WorkDuration { daily, monthly, yearly }

// ─────────────────────────────────────────────
// Worker
// ─────────────────────────────────────────────
class WorkerModel {
  final String id;
  final String fullName;
  final int age;
  final String aadhaarNumber;
  final String? profilePhoto;
  final List<String> skills;
  final int? yearsOfExperience;
  final String city;
  final String state;
  final String phone;
  final String email;
  AvailabilityStatus availability;
  final List<String> languages;
  final String? contractorId; // null if independent

  WorkerModel({
    required this.id,
    required this.fullName,
    required this.age,
    required this.aadhaarNumber,
    this.profilePhoto,
    required this.skills,
    this.yearsOfExperience,
    required this.city,
    required this.state,
    required this.phone,
    required this.email,
    this.availability = AvailabilityStatus.available,
    this.languages = const [],
    this.contractorId,
  });

  WorkerModel copyWith({AvailabilityStatus? availability}) {
    return WorkerModel(
      id: id,
      fullName: fullName,
      age: age,
      aadhaarNumber: aadhaarNumber,
      profilePhoto: profilePhoto,
      skills: skills,
      yearsOfExperience: yearsOfExperience,
      city: city,
      state: state,
      phone: phone,
      email: email,
      availability: availability ?? this.availability,
      languages: languages,
      contractorId: contractorId,
    );
  }
}

// ─────────────────────────────────────────────
// Contractor
// ─────────────────────────────────────────────
class ContractorModel {
  final String id;
  final String fullName;
  final int age;
  final String aadhaarNumber;
  final String? profilePhoto;
  final String phone;
  final String email;
  final String? businessName;
  final String city;
  final String state;
  AvailabilityStatus availability;

  ContractorModel({
    required this.id,
    required this.fullName,
    required this.age,
    required this.aadhaarNumber,
    this.profilePhoto,
    required this.phone,
    required this.email,
    this.businessName,
    required this.city,
    required this.state,
    this.availability = AvailabilityStatus.available,
  });

  ContractorModel copyWith({AvailabilityStatus? availability}) {
    return ContractorModel(
      id: id,
      fullName: fullName,
      age: age,
      aadhaarNumber: aadhaarNumber,
      profilePhoto: profilePhoto,
      phone: phone,
      email: email,
      businessName: businessName,
      city: city,
      state: state,
      availability: availability ?? this.availability,
    );
  }
}

// ─────────────────────────────────────────────
// Company
// ─────────────────────────────────────────────
class CompanyModel {
  final String id;
  final String companyName;
  final String gstNumber;
  final String address;
  final String authorizedPersonName;
  final String designation;
  final String email;
  final String phone;
  final String? logoUrl;
  final String? description;
  final String? industryType;

  CompanyModel({
    required this.id,
    required this.companyName,
    required this.gstNumber,
    required this.address,
    required this.authorizedPersonName,
    required this.designation,
    required this.email,
    required this.phone,
    this.logoUrl,
    this.description,
    this.industryType,
  });
}

// ─────────────────────────────────────────────
// Hiring Request
// ─────────────────────────────────────────────
class HiringRequest {
  final String id;
  final String companyId;
  final String companyName;
  final String? contractorId;
  final String? workerId;
  final int workersRequired;
  final String skillRequired;
  final double standardWage;
  final double offeredWage;
  final WorkDuration duration;
  final String workLocation;
  final DateTime startDate;
  final String? additionalRequirements;
  RequestStatus status;
  final DateTime createdAt;

  HiringRequest({
    required this.id,
    required this.companyId,
    required this.companyName,
    this.contractorId,
    this.workerId,
    required this.workersRequired,
    required this.skillRequired,
    required this.standardWage,
    required this.offeredWage,
    required this.duration,
    required this.workLocation,
    required this.startDate,
    this.additionalRequirements,
    this.status = RequestStatus.pending,
    required this.createdAt,
  });

  HiringRequest copyWith({RequestStatus? status}) {
    return HiringRequest(
      id: id,
      companyId: companyId,
      companyName: companyName,
      contractorId: contractorId,
      workerId: workerId,
      workersRequired: workersRequired,
      skillRequired: skillRequired,
      standardWage: standardWage,
      offeredWage: offeredWage,
      duration: duration,
      workLocation: workLocation,
      startDate: startDate,
      additionalRequirements: additionalRequirements,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}

// ─────────────────────────────────────────────
// Notification
// ─────────────────────────────────────────────
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}
