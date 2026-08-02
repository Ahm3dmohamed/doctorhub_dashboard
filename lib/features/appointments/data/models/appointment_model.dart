import '../../domain/entities/appointment_entity.dart';

/// Data model for [AppointmentEntity] with JSON serialization support.
///
/// [AppointmentModel] lives in the data layer and extends [AppointmentEntity]
/// to inherit all domain properties. It adds `fromJson`/`toJson` and
/// a `fromEntity` factory for cross-layer conversion.
class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.patientName,
    required super.doctorName,
    required super.specialty,
    required super.clinicName,
    required super.dateTime,
    required super.status,
    required super.reason,
    super.notes = '',
  });

  /// Constructs an [AppointmentModel] from a domain [AppointmentEntity].
  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      patientName: entity.patientName,
      doctorName: entity.doctorName,
      specialty: entity.specialty,
      clinicName: entity.clinicName,
      dateTime: entity.dateTime,
      status: entity.status,
      reason: entity.reason,
      notes: entity.notes,
    );
  }

  /// Constructs an [AppointmentModel] from a JSON map.
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      patientName: json['patientName'] as String,
      doctorName: json['doctorName'] as String,
      specialty: json['specialty'] as String,
      clinicName: json['clinicName'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      reason: json['reason'] as String,
      notes: json['notes'] as String? ?? '',
    );
  }

  /// Serializes this model to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'patientName': patientName,
        'doctorName': doctorName,
        'specialty': specialty,
        'clinicName': clinicName,
        'dateTime': dateTime.toIso8601String(),
        'status': status.name,
        'reason': reason,
        'notes': notes,
      };
}
