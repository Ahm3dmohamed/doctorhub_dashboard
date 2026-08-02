import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/doctor_entity.dart';

abstract class DoctorRepository {
  Future<Either<Failure, List<DoctorEntity>>> getDoctors({
    String? query,
    String? specialtyFilter,
    bool? availabilityFilter,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, DoctorEntity>> getDoctorById(String id);

  Future<Either<Failure, DoctorEntity>> createDoctor(DoctorEntity doctor);

  Future<Either<Failure, DoctorEntity>> updateDoctor(DoctorEntity doctor);

  Future<Either<Failure, bool>> deleteDoctor(String id);
}
