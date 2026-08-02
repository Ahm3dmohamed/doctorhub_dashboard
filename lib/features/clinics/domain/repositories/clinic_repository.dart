import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/clinic_entity.dart';

abstract class ClinicRepository {
  Future<Either<Failure, List<ClinicEntity>>> getClinics({
    String? query,
    String? cityFilter,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, ClinicEntity>> createClinic(ClinicEntity clinic);
  Future<Either<Failure, ClinicEntity>> updateClinic(ClinicEntity clinic);
  Future<Either<Failure, bool>> deleteClinic(String id);
}
