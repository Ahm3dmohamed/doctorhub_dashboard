import '../../../../core/errors/exceptions.dart';
import '../models/patient_model.dart';

abstract class PatientRemoteDataSource {
  Future<List<PatientModel>> getPatients({
    String? query,
    int page = 1,
    int limit = 10,
  });

  Future<PatientModel> createPatient(PatientModel patient);
  Future<PatientModel> updatePatient(PatientModel patient);
  Future<bool> deletePatient(String id);
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final List<PatientModel> _patients = [
    PatientModel(
      id: 'pat_1',
      name: 'Emma Thompson',
      email: 'emma.t@example.com',
      phone: '+1 (555) 987-6543',
      age: 29,
      gender: 'Female',
      bloodGroup: 'A+',
      emergencyContact: const EmergencyContactModel(
        name: 'Mark Thompson',
        relation: 'Spouse',
        phone: '+1 (555) 987-0000',
      ),
      medicalHistory: 'Mild asthma, annual flu checkups',
      allergies: 'Penicillin',
      registeredAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    PatientModel(
      id: 'pat_2',
      name: 'Michael Chen',
      email: 'm.chen@example.com',
      phone: '+1 (555) 345-6789',
      age: 42,
      gender: 'Male',
      bloodGroup: 'O+',
      emergencyContact: const EmergencyContactModel(
        name: 'Linda Chen',
        relation: 'Sister',
        phone: '+1 (555) 345-1111',
      ),
      medicalHistory: 'Hypertension, managed with medication',
      allergies: 'None',
      registeredAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
    PatientModel(
      id: 'pat_3',
      name: 'Sarah Williams',
      email: 'sarah.w@example.com',
      phone: '+1 (555) 222-3333',
      age: 35,
      gender: 'Female',
      bloodGroup: 'B-',
      emergencyContact: const EmergencyContactModel(
        name: 'David Williams',
        relation: 'Father',
        phone: '+1 (555) 222-9999',
      ),
      medicalHistory: 'Type 2 Diabetes, regular lab tracking',
      allergies: 'Sulfa drugs',
      registeredAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  @override
  Future<List<PatientModel>> getPatients({
    String? query,
    int page = 1,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var res = _patients.toList();

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      res = res
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.email.toLowerCase().contains(q) ||
                p.phone.contains(q),
          )
          .toList();
    }

    return res;
  }

  @override
  Future<PatientModel> createPatient(PatientModel patient) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final created = PatientModel(
      id: 'pat_${DateTime.now().millisecondsSinceEpoch}',
      name: patient.name,
      email: patient.email,
      phone: patient.phone,
      age: patient.age,
      gender: patient.gender,
      bloodGroup: patient.bloodGroup,
      emergencyContact: patient.emergencyContact,
      medicalHistory: patient.medicalHistory,
      allergies: patient.allergies,
      registeredAt: DateTime.now(),
    );
    _patients.insert(0, created);
    return created;
  }

  @override
  Future<PatientModel> updatePatient(PatientModel patient) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _patients.indexWhere((p) => p.id == patient.id);
    if (idx == -1) throw const AppException(message: 'Patient not found');
    _patients[idx] = patient;
    return patient;
  }

  @override
  Future<bool> deletePatient(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _patients.removeWhere((p) => p.id == id);
    return true;
  }
}
