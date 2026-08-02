import 'package:equatable/equatable.dart';

enum RecordType {
  diagnosis,
  labResult,
  radiology,
  prescription,
  vaccination,
  surgery,
  general;

  String get displayName => switch (this) {
        RecordType.diagnosis => 'Diagnosis',
        RecordType.labResult => 'Lab Result',
        RecordType.radiology => 'Radiology',
        RecordType.prescription => 'Prescription',
        RecordType.vaccination => 'Vaccination',
        RecordType.surgery => 'Surgery',
        RecordType.general => 'General',
      };
}

class LabResult extends Equatable {
  final String testName;
  final String value;
  final String unit;
  final String referenceRange;
  final bool isAbnormal;

  const LabResult({
    required this.testName,
    required this.value,
    required this.unit,
    required this.referenceRange,
    this.isAbnormal = false,
  });

  @override
  List<Object?> get props => [testName, value, unit, referenceRange, isAbnormal];
}

class RadiologyItem extends Equatable {
  final String type; // X-Ray, MRI, CT Scan, etc.
  final String bodyPart;
  final String findings;
  final String? imageUrl;

  const RadiologyItem({
    required this.type,
    required this.bodyPart,
    required this.findings,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [type, bodyPart, findings, imageUrl];
}

class Attachment extends Equatable {
  final String id;
  final String name;
  final String fileType; // pdf, jpg, png, etc.
  final String size;
  final DateTime uploadedAt;

  const Attachment({
    required this.id,
    required this.name,
    required this.fileType,
    required this.size,
    required this.uploadedAt,
  });

  @override
  List<Object?> get props => [id, name, fileType, size, uploadedAt];
}

class MedicalRecordEntity extends Equatable {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String clinicName;
  final DateTime date;
  final RecordType type;
  final List<String> diagnoses;
  final List<String> symptoms;
  final List<String> treatments;
  final List<LabResult> labResults;
  final List<RadiologyItem> radiology;
  final String doctorNotes;
  final List<Attachment> attachments;
  final String? followUpDate;

  const MedicalRecordEntity({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.clinicName,
    required this.date,
    required this.type,
    this.diagnoses = const [],
    this.symptoms = const [],
    this.treatments = const [],
    this.labResults = const [],
    this.radiology = const [],
    this.doctorNotes = '',
    this.attachments = const [],
    this.followUpDate,
  });

  @override
  List<Object?> get props => [id, patientId, doctorId, date, type];
}
