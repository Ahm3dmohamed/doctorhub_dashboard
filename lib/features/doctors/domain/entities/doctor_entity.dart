import 'package:equatable/equatable.dart';

class WorkingHours extends Equatable {
  final String day; // Monday, Tuesday, etc.
  final String startTime; // 09:00 AM
  final String endTime; // 05:00 PM
  final bool isAvailable;

  const WorkingHours({
    required this.day,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [day, startTime, endTime, isAvailable];
}

class DoctorEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String specialty;
  final String clinicName;
  final double rating;
  final int totalPatients;
  final int yearsOfExperience;
  final String bio;
  final bool isAvailable;
  final List<WorkingHours> workingHours;
  final String? avatarUrl;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialty,
    required this.clinicName,
    required this.rating,
    required this.totalPatients,
    required this.yearsOfExperience,
    required this.bio,
    this.isAvailable = true,
    required this.workingHours,
    this.avatarUrl,
  });

  String get initials {
    final parts = name.replaceAll('Dr. ', '').trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'D';
  }

  DoctorEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? specialty,
    String? clinicName,
    double? rating,
    int? totalPatients,
    int? yearsOfExperience,
    String? bio,
    bool? isAvailable,
    List<WorkingHours>? workingHours,
    String? avatarUrl,
  }) {
    return DoctorEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      specialty: specialty ?? this.specialty,
      clinicName: clinicName ?? this.clinicName,
      rating: rating ?? this.rating,
      totalPatients: totalPatients ?? this.totalPatients,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      bio: bio ?? this.bio,
      isAvailable: isAvailable ?? this.isAvailable,
      workingHours: workingHours ?? this.workingHours,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        specialty,
        clinicName,
        rating,
        totalPatients,
        yearsOfExperience,
        bio,
        isAvailable,
        workingHours,
        avatarUrl,
      ];
}
