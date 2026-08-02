import '../../domain/entities/medical_record_entity.dart';

class MedicalRecordModel extends MedicalRecordEntity {
  const MedicalRecordModel({
    required super.id,
    required super.patientId,
    required super.patientName,
    required super.doctorId,
    required super.doctorName,
    required super.clinicName,
    required super.date,
    required super.type,
    super.diagnoses,
    super.symptoms,
    super.treatments,
    super.labResults,
    super.radiology,
    super.doctorNotes,
    super.attachments,
    super.followUpDate,
  });

  factory MedicalRecordModel.fromEntity(MedicalRecordEntity entity) {
    return MedicalRecordModel(
      id: entity.id,
      patientId: entity.patientId,
      patientName: entity.patientName,
      doctorId: entity.doctorId,
      doctorName: entity.doctorName,
      clinicName: entity.clinicName,
      date: entity.date,
      type: entity.type,
      diagnoses: entity.diagnoses,
      symptoms: entity.symptoms,
      treatments: entity.treatments,
      labResults: entity.labResults,
      radiology: entity.radiology,
      doctorNotes: entity.doctorNotes,
      attachments: entity.attachments,
      followUpDate: entity.followUpDate,
    );
  }
}
