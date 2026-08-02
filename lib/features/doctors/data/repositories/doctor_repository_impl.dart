import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../datasources/doctor_remote_datasource.dart';
import '../models/doctor_model.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource _remoteDataSource;

  const DoctorRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctors({
    String? query,
    String? specialtyFilter,
    bool? availabilityFilter,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final doctors = await _remoteDataSource.getDoctors(
        query: query,
        specialtyFilter: specialtyFilter,
        availabilityFilter: availabilityFilter,
        page: page,
        limit: limit,
      );
      return Right(doctors);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorById(String id) async {
    try {
      final doctor = await _remoteDataSource.getDoctorById(id);
      return Right(doctor);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DoctorEntity>> createDoctor(DoctorEntity doctor) async {
    try {
      final model = DoctorModel.fromEntity(doctor);
      final created = await _remoteDataSource.createDoctor(model);
      return Right(created);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DoctorEntity>> updateDoctor(DoctorEntity doctor) async {
    try {
      final model = DoctorModel.fromEntity(doctor);
      final updated = await _remoteDataSource.updateDoctor(model);
      return Right(updated);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteDoctor(String id) async {
    try {
      final res = await _remoteDataSource.deleteDoctor(id);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
