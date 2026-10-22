import '../../domain/entities/doctor_entity.dart';

class WorkingHoursModel extends WorkingHours {
  const WorkingHoursModel({
    required super.day,
    required super.startTime,
    required super.endTime,
    super.isAvailable = true,
  });

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      day: json['day'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'isAvailable': isAvailable,
    };
  }
}

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.specialty,
    required super.clinicName,
    required super.rating,
    required super.totalPatients,
    required super.yearsOfExperience,
    required super.bio,
    super.isAvailable = true,
    required super.workingHours,
    super.avatarUrl,
  });

  factory DoctorModel.fromEntity(DoctorEntity entity) {
    return DoctorModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      specialty: entity.specialty,
      clinicName: entity.clinicName,
      rating: entity.rating,
      totalPatients: entity.totalPatients,
      yearsOfExperience: entity.yearsOfExperience,
      bio: entity.bio,
      isAvailable: entity.isAvailable,
      workingHours: entity.workingHours,
      avatarUrl: entity.avatarUrl,
    );
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      specialty: json['specialty'] as String,
      clinicName: (json['clinicName'] ?? json['clinic_name']) as String? ?? '',
      rating: ((json['rating'] as num?) ?? 5.0).toDouble(),
      totalPatients:
          (json['totalPatients'] ?? json['total_patients'] as num?)?.toInt() ??
          0,
      yearsOfExperience:
          (json['yearsOfExperience'] ?? json['years_of_experience'] as num?)
              ?.toInt() ??
          0,
      bio: json['bio'] as String? ?? '',
      isAvailable:
          (json['isAvailable'] ?? json['is_available']) as bool? ?? true,
      workingHours:
          (json['workingHours'] ?? json['working_hours'] as List<dynamic>?)
              ?.map(
                (e) => WorkingHoursModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      avatarUrl: (json['avatarUrl'] ?? json['avatar_url']) as String?,
    );
  }

  Map<String, dynamic> toSupabaseMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'specialty': specialty,
      'clinic_name': clinicName,
      'rating': rating,
      'total_patients': totalPatients,
      'years_of_experience': yearsOfExperience,
      'bio': bio,
      'is_available': isAvailable,
      'working_hours': workingHours.map((e) {
        final m = e is WorkingHoursModel
            ? e
            : WorkingHoursModel(
                day: e.day,
                startTime: e.startTime,
                endTime: e.endTime,
                isAvailable: e.isAvailable,
              );
        return m.toJson();
      }).toList(),
      'avatar_url': avatarUrl,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'specialty': specialty,
      'clinicName': clinicName,
      'rating': rating,
      'totalPatients': totalPatients,
      'yearsOfExperience': yearsOfExperience,
      'bio': bio,
      'isAvailable': isAvailable,
      'workingHours': workingHours.map((e) {
        final m = e is WorkingHoursModel
            ? e
            : WorkingHoursModel(
                day: e.day,
                startTime: e.startTime,
                endTime: e.endTime,
                isAvailable: e.isAvailable,
              );
        return m.toJson();
      }).toList(),
      'avatarUrl': avatarUrl,
    };
  }
}
