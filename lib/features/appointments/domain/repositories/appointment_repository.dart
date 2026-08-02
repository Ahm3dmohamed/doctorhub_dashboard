import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments({
    String? query,
    AppointmentStatus? statusFilter,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, AppointmentEntity>> createAppointment(AppointmentEntity appointment);
  Future<Either<Failure, AppointmentEntity>> updateStatus(String id, AppointmentStatus status);
  Future<Either<Failure, AppointmentEntity>> reschedule(String id, DateTime newDateTime);
  Future<Either<Failure, bool>> deleteAppointment(String id);
}
