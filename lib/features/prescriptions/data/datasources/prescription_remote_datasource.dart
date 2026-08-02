import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/prescription_entity.dart';
import '../models/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<List<PrescriptionModel>> getPrescriptions({
    String? query,
    PrescriptionStatus? status,
    String? patientId,
  });

  Future<PrescriptionModel> createPrescription(PrescriptionEntity prescription);
  Future<void> deletePrescription(String id);
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  final List<PrescriptionModel> _prescriptions = [
    PrescriptionModel(
      id: 'RX-2001',
      patientId: 'PAT-001',
      patientName: 'Sarah Jenkins',
      doctorId: 'DOC-001',
      doctorName: 'Dr. Alexander Wright',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: PrescriptionStatus.active,
      notes: 'Take medications with food. Avoid high sodium meals.',
      medicines: const [
        MedicineItem(
          name: 'Lisinopril',
          dosage: '10mg',
          frequency: 'Once Daily (Morning)',
          duration: '30 Days',
          instructions: 'Take in the morning with a full glass of water.',
        ),
        MedicineItem(
          name: 'Atorvastatin',
          dosage: '20mg',
          frequency: 'Once Daily (Evening)',
          duration: '30 Days',
          instructions: 'Take before bedtime.',
        ),
      ],
    ),
    PrescriptionModel(
      id: 'RX-2002',
      patientId: 'PAT-002',
      patientName: 'Michael Chen',
      doctorId: 'DOC-002',
      doctorName: 'Dr. Elena Rostova',
      date: DateTime.now().subtract(const Duration(days: 4)),
      status: PrescriptionStatus.active,
      notes: 'Use Sumatriptan at onset of migraine aura.',
      medicines: const [
        MedicineItem(
          name: 'Sumatriptan',
          dosage: '50mg',
          frequency: 'As Needed',
          duration: '10 Tablets',
          instructions: 'Do not exceed 100mg in 24 hours.',
        ),
        MedicineItem(
          name: 'Magnesium Glycinate',
          dosage: '400mg',
          frequency: 'Once Daily',
          duration: '60 Days',
          instructions: 'Take with evening meal.',
        ),
      ],
    ),
    PrescriptionModel(
      id: 'RX-2003',
      patientId: 'PAT-003',
      patientName: 'Emma Watson',
      doctorId: 'DOC-003',
      doctorName: 'Dr. Marcus Vance',
      date: DateTime.now().subtract(const Duration(days: 10)),
      status: PrescriptionStatus.completed,
      notes: 'Post-op knee surgery pain management cycle completed.',
      medicines: const [
        MedicineItem(
          name: 'Ibuprofen',
          dosage: '600mg',
          frequency: '3x Daily PRN',
          duration: '7 Days',
          instructions: 'Take strictly after eating.',
        ),
        MedicineItem(
          name: 'Amoxicillin-Clavulanate',
          dosage: '875mg',
          frequency: '2x Daily',
          duration: '7 Days',
          instructions: 'Finish entire course of antibiotic.',
        ),
      ],
    ),
  ];

  @override
  Future<List<PrescriptionModel>> getPrescriptions({
    String? query,
    PrescriptionStatus? status,
    String? patientId,
  }) async {
    await Future.delayed(AppConstants.mockApiDelay);
    return _prescriptions.where((rx) {
      if (status != null && rx.status != status) return false;
      if (patientId != null && rx.patientId != patientId) return false;
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final matchPatient = rx.patientName.toLowerCase().contains(q);
        final matchDoctor = rx.doctorName.toLowerCase().contains(q);
        final matchId = rx.id.toLowerCase().contains(q);
        final matchMed = rx.medicines.any((m) => m.name.toLowerCase().contains(q));
        return matchPatient || matchDoctor || matchId || matchMed;
      }
      return true;
    }).toList();
  }

  @override
  Future<PrescriptionModel> createPrescription(PrescriptionEntity prescription) async {
    await Future.delayed(AppConstants.mockApiDelay);
    final model = PrescriptionModel.fromEntity(prescription);
    _prescriptions.insert(0, model);
    return model;
  }

  @override
  Future<void> deletePrescription(String id) async {
    await Future.delayed(AppConstants.mockApiDelay);
    _prescriptions.removeWhere((r) => r.id == id);
  }
}
