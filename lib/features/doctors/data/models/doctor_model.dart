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
      phone: json['phone'] as String,
      specialty: json['specialty'] as String,
      clinicName: json['clinicName'] as String,
      rating: (json['rating'] as num).toDouble(),
      totalPatients: json['totalPatients'] as int,
      yearsOfExperience: json['yearsOfExperience'] as int,
      bio: json['bio'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      workingHours: (json['workingHours'] as List<dynamic>?)
              ?.map((e) => WorkingHoursModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      avatarUrl: json['avatarUrl'] as String?,
    );
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
