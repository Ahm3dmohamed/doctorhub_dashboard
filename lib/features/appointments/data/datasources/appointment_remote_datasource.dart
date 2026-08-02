import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/appointment_entity.dart';
import '../models/appointment_model.dart';

/// Contract for the appointment remote data source.
///
/// All methods return [AppointmentModel] instances (data layer) and may throw
/// [AppException] subclasses which are caught and converted by the repository.
abstract class AppointmentRemoteDataSource {
  Future<List<AppointmentModel>> getAppointments({
    String? query,
    AppointmentStatus? statusFilter,
    int page = 1,
    int limit = 10,
  });

  Future<AppointmentModel> createAppointment(AppointmentModel appointment);

  Future<AppointmentModel> updateStatus(String id, AppointmentStatus status);

  Future<AppointmentModel> reschedule(String id, DateTime newDateTime);

  Future<bool> deleteAppointment(String id);
}

/// Mock implementation of [AppointmentRemoteDataSource].
///
/// Uses an in-memory list to simulate CRUD operations. Replace with a
/// real Dio-based implementation when connecting to the backend.
class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final List<AppointmentModel> _appointments = [
    AppointmentModel(
      id: 'apt_1',
      patientName: 'Emma Thompson',
      doctorName: 'Dr. Sarah Jenkins',
      specialty: 'Cardiology',
      clinicName: 'Central Heart Institute',
      dateTime: DateTime.now().add(const Duration(hours: 2)),
      status: AppointmentStatus.upcoming,
      reason: 'Routine ECG & Blood Pressure Follow-up',
    ),
    AppointmentModel(
      id: 'apt_2',
      patientName: 'Michael Chen',
      doctorName: 'Dr. Marcus Vance',
      specialty: 'Neurology',
      clinicName: 'NeuroCare Health Center',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 4)),
      status: AppointmentStatus.upcoming,
      reason: 'Migraine Consultation',
    ),
    AppointmentModel(
      id: 'apt_3',
      patientName: 'Sarah Williams',
      doctorName: 'Dr. Elena Rostova',
      specialty: 'Pediatrics',
      clinicName: 'Sunshine Children Clinic',
      dateTime: DateTime.now().subtract(const Duration(hours: 5)),
      status: AppointmentStatus.completed,
      reason: 'Child Vaccination',
    ),
    AppointmentModel(
      id: 'apt_4',
      patientName: 'David Miller',
      doctorName: 'Dr. James Wilson',
      specialty: 'Orthopedics',
      clinicName: 'Apex Joint & Spine Hospital',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      status: AppointmentStatus.pending,
      reason: 'Knee Pain Evaluation',
    ),
    AppointmentModel(
      id: 'apt_5',
      patientName: 'Olivia Martinez',
      doctorName: 'Dr. Amina Al-Mansoor',
      specialty: 'Dermatology',
      clinicName: 'ClearSkin Aesthetics',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      status: AppointmentStatus.cancelled,
      reason: 'Skin Rash Consultation',
    ),
  ];

  @override
  Future<List<AppointmentModel>> getAppointments({
    String? query,
    AppointmentStatus? statusFilter,
    int page = 1,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var results = _appointments.toList();

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      results = results
          .where(
            (a) =>
                a.patientName.toLowerCase().contains(q) ||
                a.doctorName.toLowerCase().contains(q) ||
                a.specialty.toLowerCase().contains(q) ||
                a.clinicName.toLowerCase().contains(q),
          )
          .toList();
    }

    if (statusFilter != null) {
      results = results.where((a) => a.status == statusFilter).toList();
    }

    return results;
  }

  @override
  Future<AppointmentModel> createAppointment(
    AppointmentModel appointment,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final created = AppointmentModel(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      patientName: appointment.patientName,
      doctorName: appointment.doctorName,
      specialty: appointment.specialty,
      clinicName: appointment.clinicName,
      dateTime: appointment.dateTime,
      status: appointment.status,
      reason: appointment.reason,
      notes: appointment.notes,
    );
    _appointments.insert(0, created);
    return created;
  }

  @override
  Future<AppointmentModel> updateStatus(
    String id,
    AppointmentStatus status,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _appointments.indexWhere((a) => a.id == id);
    if (idx == -1) {
      throw AppException(message: 'Appointment not found: $id');
    }
    final updated = _appointments[idx].copyWith(status: status);
    _appointments[idx] = AppointmentModel.fromEntity(updated);
    return _appointments[idx];
  }

  @override
  Future<AppointmentModel> reschedule(String id, DateTime newDateTime) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _appointments.indexWhere((a) => a.id == id);
    if (idx == -1) {
      throw AppException(message: 'Appointment not found: $id');
    }
    final updated = _appointments[idx].copyWith(
      dateTime: newDateTime,
      status: AppointmentStatus.upcoming,
    );
    _appointments[idx] = AppointmentModel.fromEntity(updated);
    return _appointments[idx];
  }

  @override
  Future<bool> deleteAppointment(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _appointments.removeWhere((a) => a.id == id);
    return true;
  }
}
