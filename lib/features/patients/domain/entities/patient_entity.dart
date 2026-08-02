import 'package:equatable/equatable.dart';

class EmergencyContact extends Equatable {
  final String name;
  final String relation;
  final String phone;

  const EmergencyContact({
    required this.name,
    required this.relation,
    required this.phone,
  });

  @override
  List<Object?> get props => [name, relation, phone];
}

class PatientEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String gender;
  final String bloodGroup;
  final EmergencyContact emergencyContact;
  final String medicalHistory;
  final String allergies;
  final DateTime registeredAt;

  const PatientEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.emergencyContact,
    required this.medicalHistory,
    required this.allergies,
    required this.registeredAt,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'P';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        age,
        gender,
        bloodGroup,
        emergencyContact,
        medicalHistory,
        allergies,
        registeredAt,
      ];
}
