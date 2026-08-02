import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription_entity.dart';

abstract class PrescriptionRepository {
  Future<Either<Failure, List<PrescriptionEntity>>> getPrescriptions({
    String? query,
    PrescriptionStatus? status,
    String? patientId,
  });

  Future<Either<Failure, PrescriptionEntity>> createPrescription(
      PrescriptionEntity prescription);

  Future<Either<Failure, void>> deletePrescription(String id);
}
