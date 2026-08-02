import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/medical_record_entity.dart';
import '../models/medical_record_model.dart';

abstract class MedicalRecordRemoteDataSource {
  Future<List<MedicalRecordModel>> getRecords({
    String? query,
    RecordType? type,
    String? patientId,
  });
  Future<MedicalRecordModel> getRecordById(String id);
  Future<MedicalRecordModel> createRecord(MedicalRecordEntity record);
  Future<MedicalRecordModel> updateRecord(MedicalRecordEntity record);
  Future<void> deleteRecord(String id);
}

class MedicalRecordRemoteDataSourceImpl implements MedicalRecordRemoteDataSource {
  final List<MedicalRecordModel> _records = [
    MedicalRecordModel(
      id: 'REC-1001',
      patientId: 'PAT-001',
      patientName: 'Sarah Jenkins',
      doctorId: 'DOC-001',
      doctorName: 'Dr. Alexander Wright',
      clinicName: 'Central Heart & Vascular Center',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: RecordType.diagnosis,
      diagnoses: ['Essential Primary Hypertension', 'Hyperlipidemia'],
      symptoms: ['Mild dizziness', 'Occasional morning headache', 'Fatigue'],
      treatments: ['Prescribed Lisinopril 10mg', 'Lifestyle & dietary modifications'],
      doctorNotes: 'Patient reports occasional dizziness. BP measured 138/88 mmHg. Advised low-sodium diet and daily BP tracking.',
      followUpDate: '2026-08-15',
      labResults: const [
        LabResult(testName: 'Total Cholesterol', value: '215', unit: 'mg/dL', referenceRange: '< 200', isAbnormal: true),
        LabResult(testName: 'LDL Cholesterol', value: '135', unit: 'mg/dL', referenceRange: '< 100', isAbnormal: true),
        LabResult(testName: 'HDL Cholesterol', value: '52', unit: 'mg/dL', referenceRange: '> 50', isAbnormal: false),
        LabResult(testName: 'Fasting Blood Sugar', value: '94', unit: 'mg/dL', referenceRange: '70 - 99', isAbnormal: false),
      ],
      radiology: const [
        RadiologyItem(type: 'ECG', bodyPart: 'Chest/Heart', findings: 'Normal sinus rhythm, HR 72 bpm. No acute ST-T changes.'),
      ],
      attachments: [
        Attachment(id: 'ATT-1', name: 'Comprehensive_Blood_Panel.pdf', fileType: 'pdf', size: '2.4 MB', uploadedAt: DateTime.now().subtract(const Duration(days: 2))),
        Attachment(id: 'ATT-2', name: 'ECG_Trace_Report.pdf', fileType: 'pdf', size: '1.1 MB', uploadedAt: DateTime.now().subtract(const Duration(days: 2))),
      ],
    ),
    MedicalRecordModel(
      id: 'REC-1002',
      patientId: 'PAT-002',
      patientName: 'Michael Chen',
      doctorId: 'DOC-002',
      doctorName: 'Dr. Elena Rostova',
      clinicName: 'NeuroCare Institute',
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: RecordType.radiology,
      diagnoses: ['Migraine without Aura', 'Cervical Spondylosis'],
      symptoms: ['Unilateral throbbing headache', 'Photophobia', 'Neck stiffness'],
      treatments: ['Sumatriptan 50mg PRN', 'Physical therapy 2x/week'],
      doctorNotes: 'Brain MRI negative for acute intracranial abnormality. Cervical spine shows mild C5-C6 degenerative disc disease.',
      followUpDate: '2026-08-20',
      radiology: const [
        RadiologyItem(type: 'Brain MRI', bodyPart: 'Head/Brain', findings: 'Unremarkable brain parenchyma. No mass effect, midline shift, or acute ischemia.'),
        RadiologyItem(type: 'C-Spine X-Ray', bodyPart: 'Neck', findings: 'Mild disc space narrowing at C5-C6 with minor osteophyte formation.'),
      ],
      attachments: [
        Attachment(id: 'ATT-3', name: 'MRI_Brain_Scan_Images.zip', fileType: 'zip', size: '45.8 MB', uploadedAt: DateTime.now().subtract(const Duration(days: 5))),
      ],
    ),
    MedicalRecordModel(
      id: 'REC-1003',
      patientId: 'PAT-003',
      patientName: 'Emma Watson',
      doctorId: 'DOC-003',
      doctorName: 'Dr. Marcus Vance',
      clinicName: 'OrthoMotion Clinic',
      date: DateTime.now().subtract(const Duration(days: 8)),
      type: RecordType.surgery,
      diagnoses: ['ACL Tear - Right Knee'],
      symptoms: ['Right knee joint instability', 'Pain on weight bearing', 'Joint effusion'],
      treatments: ['Arthroscopic ACL Reconstruction', 'Post-op knee immobilization brace'],
      doctorNotes: 'Successful arthroscopic ACL reconstruction using bone-patellar tendon-bone autograft. No immediate post-op complications.',
      followUpDate: '2026-08-10',
      attachments: [
        Attachment(id: 'ATT-4', name: 'Surgical_Report_ACL.pdf', fileType: 'pdf', size: '3.8 MB', uploadedAt: DateTime.now().subtract(const Duration(days: 8))),
      ],
    ),
    MedicalRecordModel(
      id: 'REC-1004',
      patientId: 'PAT-004',
      patientName: 'Robert Martinez',
      doctorId: 'DOC-001',
      doctorName: 'Dr. Alexander Wright',
      clinicName: 'Central Heart & Vascular Center',
      date: DateTime.now().subtract(const Duration(days: 12)),
      type: RecordType.labResult,
      diagnoses: ['Type 2 Diabetes Mellitus'],
      symptoms: ['Polyuria', 'Polydipsia', 'Unexplained fatigue'],
      treatments: ['Metformin 500mg BID', 'Diabetic education & meal plan'],
      doctorNotes: 'HbA1c levels elevated at 7.8%. Initiated low-dose oral hypoglycemic therapy and scheduled nutritionist consult.',
      followUpDate: '2026-08-30',
      labResults: const [
        LabResult(testName: 'HbA1c', value: '7.8', unit: '%', referenceRange: '< 5.7', isAbnormal: true),
        LabResult(testName: 'Fasting Plasma Glucose', value: '142', unit: 'mg/dL', referenceRange: '70 - 99', isAbnormal: true),
        LabResult(testName: 'eGFR', value: '88', unit: 'mL/min/1.73m2', referenceRange: '> 60', isAbnormal: false),
        LabResult(testName: 'Serum Creatinine', value: '0.9', unit: 'mg/dL', referenceRange: '0.7 - 1.3', isAbnormal: false),
      ],
    ),
  ];

  @override
  Future<List<MedicalRecordModel>> getRecords({
    String? query,
    RecordType? type,
    String? patientId,
  }) async {
    await Future.delayed(AppConstants.mockApiDelay);
    return _records.where((rec) {
      if (type != null && rec.type != type) return false;
      if (patientId != null && rec.patientId != patientId) return false;
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final matchPatient = rec.patientName.toLowerCase().contains(q);
        final matchDoctor = rec.doctorName.toLowerCase().contains(q);
        final matchDiag = rec.diagnoses.any((d) => d.toLowerCase().contains(q));
        final matchId = rec.id.toLowerCase().contains(q);
        return matchPatient || matchDoctor || matchDiag || matchId;
      }
      return true;
    }).toList();
  }

  @override
  Future<MedicalRecordModel> getRecordById(String id) async {
    await Future.delayed(AppConstants.mockApiDelay);
    return _records.firstWhere((r) => r.id == id);
  }

  @override
  Future<MedicalRecordModel> createRecord(MedicalRecordEntity record) async {
    await Future.delayed(AppConstants.mockApiDelay);
    final newModel = MedicalRecordModel.fromEntity(record);
    _records.insert(0, newModel);
    return newModel;
  }

  @override
  Future<MedicalRecordModel> updateRecord(MedicalRecordEntity record) async {
    await Future.delayed(AppConstants.mockApiDelay);
    final index = _records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      final updated = MedicalRecordModel.fromEntity(record);
      _records[index] = updated;
      return updated;
    }
    throw Exception('Record not found');
  }

  @override
  Future<void> deleteRecord(String id) async {
    await Future.delayed(AppConstants.mockApiDelay);
    _records.removeWhere((r) => r.id == id);
  }
}
