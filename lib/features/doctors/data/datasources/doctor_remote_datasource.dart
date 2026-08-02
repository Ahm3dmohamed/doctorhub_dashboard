import '../../../../core/errors/exceptions.dart';
import '../models/doctor_model.dart';

abstract class DoctorRemoteDataSource {
  Future<List<DoctorModel>> getDoctors({
    String? query,
    String? specialtyFilter,
    bool? availabilityFilter,
    int page = 1,
    int limit = 10,
  });

  Future<DoctorModel> getDoctorById(String id);

  Future<DoctorModel> createDoctor(DoctorModel doctor);

  Future<DoctorModel> updateDoctor(DoctorModel doctor);

  Future<bool> deleteDoctor(String id);
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final List<DoctorModel> _doctors = [
    const DoctorModel(
      id: 'doc_1',
      name: 'Dr. Sarah Jenkins',
      email: 'sarah.jenkins@doctorhub.com',
      phone: '+1 (555) 234-5678',
      specialty: 'Cardiology',
      clinicName: 'Central Heart Institute',
      rating: 4.9,
      totalPatients: 340,
      yearsOfExperience: 12,
      bio:
          'Board-certified cardiologist specializing in preventive cardiology and heart failure management.',
      isAvailable: true,
      workingHours: [
        WorkingHoursModel(
          day: 'Monday',
          startTime: '09:00 AM',
          endTime: '05:00 PM',
        ),
        WorkingHoursModel(
          day: 'Wednesday',
          startTime: '09:00 AM',
          endTime: '05:00 PM',
        ),
        WorkingHoursModel(
          day: 'Friday',
          startTime: '09:00 AM',
          endTime: '01:00 PM',
        ),
      ],
    ),
    const DoctorModel(
      id: 'doc_2',
      name: 'Dr. Marcus Vance',
      email: 'marcus.vance@doctorhub.com',
      phone: '+1 (555) 876-5432',
      specialty: 'Neurology',
      clinicName: 'NeuroCare Health Center',
      rating: 4.8,
      totalPatients: 210,
      yearsOfExperience: 9,
      bio:
          'Expert neurologist focused on stroke recovery, migraines, and neurodegenerative disorders.',
      isAvailable: true,
      workingHours: [
        WorkingHoursModel(
          day: 'Tuesday',
          startTime: '10:00 AM',
          endTime: '06:00 PM',
        ),
        WorkingHoursModel(
          day: 'Thursday',
          startTime: '10:00 AM',
          endTime: '06:00 PM',
        ),
      ],
    ),
    const DoctorModel(
      id: 'doc_3',
      name: 'Dr. Elena Rostova',
      email: 'elena.rostova@doctorhub.com',
      phone: '+1 (555) 432-1098',
      specialty: 'Pediatrics',
      clinicName: 'Sunshine Children Clinic',
      rating: 4.95,
      totalPatients: 520,
      yearsOfExperience: 15,
      bio:
          'Dedicated pediatrician providing comprehensive child wellness care and immunization.',
      isAvailable: false,
      workingHours: [
        WorkingHoursModel(
          day: 'Monday',
          startTime: '08:30 AM',
          endTime: '04:30 PM',
        ),
        WorkingHoursModel(
          day: 'Thursday',
          startTime: '08:30 AM',
          endTime: '04:30 PM',
        ),
      ],
    ),
    const DoctorModel(
      id: 'doc_4',
      name: 'Dr. James Wilson',
      email: 'james.wilson@doctorhub.com',
      phone: '+1 (555) 678-9012',
      specialty: 'Orthopedics',
      clinicName: 'Apex Joint & Spine Hospital',
      rating: 4.7,
      totalPatients: 180,
      yearsOfExperience: 8,
      bio:
          'Orthopedic surgeon specializing in sports medicine and minimally invasive arthroscopic surgery.',
      isAvailable: true,
      workingHours: [
        WorkingHoursModel(
          day: 'Wednesday',
          startTime: '08:00 AM',
          endTime: '04:00 PM',
        ),
        WorkingHoursModel(
          day: 'Friday',
          startTime: '08:00 AM',
          endTime: '04:00 PM',
        ),
      ],
    ),
    const DoctorModel(
      id: 'doc_5',
      name: 'Dr. Amina Al-Mansoor',
      email: 'amina.almansoor@doctorhub.com',
      phone: '+1 (555) 901-2345',
      specialty: 'Dermatology',
      clinicName: 'ClearSkin Aesthetics',
      rating: 4.9,
      totalPatients: 410,
      yearsOfExperience: 11,
      bio:
          'Dermatologist expert in clinical dermatology, laser skin treatment, and cosmetic surgery.',
      isAvailable: true,
      workingHours: [
        WorkingHoursModel(
          day: 'Monday',
          startTime: '10:00 AM',
          endTime: '05:00 PM',
        ),
        WorkingHoursModel(
          day: 'Saturday',
          startTime: '10:00 AM',
          endTime: '02:00 PM',
        ),
      ],
    ),
  ];

  @override
  Future<List<DoctorModel>> getDoctors({
    String? query,
    String? specialtyFilter,
    bool? availabilityFilter,
    int page = 1,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var filtered = _doctors.toList();

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      filtered = filtered
          .where(
            (d) =>
                d.name.toLowerCase().contains(q) ||
                d.email.toLowerCase().contains(q) ||
                d.specialty.toLowerCase().contains(q) ||
                d.clinicName.toLowerCase().contains(q),
          )
          .toList();
    }

    if (specialtyFilter != null &&
        specialtyFilter.isNotEmpty &&
        specialtyFilter != 'All') {
      filtered = filtered
          .where(
            (d) => d.specialty.toLowerCase() == specialtyFilter.toLowerCase(),
          )
          .toList();
    }

    if (availabilityFilter != null) {
      filtered = filtered
          .where((d) => d.isAvailable == availabilityFilter)
          .toList();
    }

    return filtered;
  }

  @override
  Future<DoctorModel> getDoctorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final doctor = _doctors.firstWhere(
      (d) => d.id == id,
      orElse: () => throw const AppException(message: 'Patient not found'),
    );
    return doctor;
  }

  @override
  Future<DoctorModel> createDoctor(DoctorModel doctor) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newDoctor = DoctorModel(
      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
      name: doctor.name,
      email: doctor.email,
      phone: doctor.phone,
      specialty: doctor.specialty,
      clinicName: doctor.clinicName,
      rating: doctor.rating,
      totalPatients: doctor.totalPatients,
      yearsOfExperience: doctor.yearsOfExperience,
      bio: doctor.bio,
      isAvailable: doctor.isAvailable,
      workingHours: doctor.workingHours,
    );
    _doctors.insert(0, newDoctor);
    return newDoctor;
  }

  @override
  Future<DoctorModel> updateDoctor(DoctorModel doctor) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _doctors.indexWhere((d) => d.id == doctor.id);
    if (index == -1) throw const AppException(message: 'Patient not found');
    _doctors[index] = doctor;
    return doctor;
  }

  @override
  Future<bool> deleteDoctor(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _doctors.removeWhere((d) => d.id == id);
    return true;
  }
}
