import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/repositories/patient_repository.dart';
import '../datasources/patient_remote_datasource.dart';
import '../models/patient_model.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource _remoteDataSource;

  const PatientRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<PatientEntity>>> getPatients({
    String? query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final res = await _remoteDataSource.getPatients(query: query, page: page, limit: limit);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PatientEntity>> createPatient(PatientEntity patient) async {
    try {
      final res = await _remoteDataSource.createPatient(PatientModel.fromEntity(patient));
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PatientEntity>> updatePatient(PatientEntity patient) async {
    try {
      final res = await _remoteDataSource.updatePatient(PatientModel.fromEntity(patient));
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePatient(String id) async {
    try {
      final res = await _remoteDataSource.deletePatient(id);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
