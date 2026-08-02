import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/medical_record_entity.dart';

abstract class MedicalRecordRepository {
  Future<Either<Failure, List<MedicalRecordEntity>>> getRecords({
    String? query,
    RecordType? type,
    String? patientId,
  });

  Future<Either<Failure, MedicalRecordEntity>> getRecordById(String id);

  Future<Either<Failure, MedicalRecordEntity>> createRecord(
      MedicalRecordEntity record);

  Future<Either<Failure, MedicalRecordEntity>> updateRecord(
      MedicalRecordEntity record);

  Future<Either<Failure, void>> deleteRecord(String id);
}
