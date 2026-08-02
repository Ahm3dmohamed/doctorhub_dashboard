import 'package:equatable/equatable.dart';

enum PrescriptionStatus {
  active,
  completed,
  cancelled;

  String get displayName => switch (this) {
        PrescriptionStatus.active => 'Active',
        PrescriptionStatus.completed => 'Completed',
        PrescriptionStatus.cancelled => 'Cancelled',
      };
}

class MedicineItem extends Equatable {
  final String name;
  final String dosage;
  final String frequency; // e.g. 2x Daily, Once daily, As needed
  final String duration;  // e.g. 7 days, 1 month
  final String instructions; // e.g. Take after meals

  const MedicineItem({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });

  @override
  List<Object?> get props => [name, dosage, frequency, duration, instructions];
}

class PrescriptionEntity extends Equatable {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final DateTime date;
  final PrescriptionStatus status;
  final List<MedicineItem> medicines;
  final String? notes;

  const PrescriptionEntity({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.date,
    required this.status,
    required this.medicines,
    this.notes,
  });

  @override
  List<Object?> get props => [id, patientId, doctorId, date, status];
}
