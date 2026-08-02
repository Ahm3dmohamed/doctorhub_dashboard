import 'package:equatable/equatable.dart';

/// Represents an appointment booking between a patient and a doctor.
///
/// [AppointmentEntity] is the domain-level model. It is immutable and extends
/// [Equatable] for value-based equality comparisons in Cubit state updates.
class AppointmentEntity extends Equatable {
  final String id;
  final String patientName;
  final String doctorName;
  final String specialty;
  final String clinicName;
  final DateTime dateTime;
  final AppointmentStatus status;
  final String reason;
  final String notes;

  const AppointmentEntity({
    required this.id,
    required this.patientName,
    required this.doctorName,
    required this.specialty,
    required this.clinicName,
    required this.dateTime,
    required this.status,
    required this.reason,
    this.notes = '',
  });

  /// Returns a new [AppointmentEntity] with the provided fields overridden.
  AppointmentEntity copyWith({
    String? id,
    String? patientName,
    String? doctorName,
    String? specialty,
    String? clinicName,
    DateTime? dateTime,
    AppointmentStatus? status,
    String? reason,
    String? notes,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      clinicName: clinicName ?? this.clinicName,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientName,
        doctorName,
        specialty,
        clinicName,
        dateTime,
        status,
        reason,
        notes,
      ];
}

// ─── Appointment Status ────────────────────────────────────────────────────────

/// Represents the lifecycle state of an appointment booking.
enum AppointmentStatus {
  /// Confirmed and scheduled for a future time.
  upcoming,

  /// The consultation has taken place successfully.
  completed,

  /// Cancelled by the patient, doctor, or administrator.
  cancelled,

  /// Awaiting approval from the doctor or clinic manager.
  pending,
}

/// Convenience extension on [AppointmentStatus] for UI display labels.
extension AppointmentStatusX on AppointmentStatus {
  /// Returns a human-readable label suitable for display in the UI.
  String get displayName => switch (this) {
        AppointmentStatus.upcoming => 'Upcoming',
        AppointmentStatus.completed => 'Completed',
        AppointmentStatus.cancelled => 'Cancelled',
        AppointmentStatus.pending => 'Pending',
      };
}
