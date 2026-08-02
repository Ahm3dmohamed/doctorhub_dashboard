import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/medical_record_entity.dart';
import '../../domain/repositories/medical_record_repository.dart';
import '../datasources/medical_record_remote_datasource.dart';

class MedicalRecordRepositoryImpl implements MedicalRecordRepository {
  final MedicalRecordRemoteDataSource _remoteDataSource;

  MedicalRecordRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<MedicalRecordEntity>>> getRecords({
    String? query,
    RecordType? type,
    String? patientId,
  }) async {
    try {
      final records = await _remoteDataSource.getRecords(
        query: query,
        type: type,
        patientId: patientId,
      );
      return Right(records);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MedicalRecordEntity>> getRecordById(String id) async {
    try {
      final record = await _remoteDataSource.getRecordById(id);
      return Right(record);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MedicalRecordEntity>> createRecord(
    MedicalRecordEntity record,
  ) async {
    try {
      final res = await _remoteDataSource.createRecord(record);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MedicalRecordEntity>> updateRecord(
    MedicalRecordEntity record,
  ) async {
    try {
      final res = await _remoteDataSource.updateRecord(record);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecord(String id) async {
    try {
      await _remoteDataSource.deleteRecord(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
