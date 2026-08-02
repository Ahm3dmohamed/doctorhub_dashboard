import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_remote_datasource.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource _remoteDataSource;

  const AppointmentRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments({
    String? query,
    AppointmentStatus? statusFilter,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final res = await _remoteDataSource.getAppointments(
        query: query,
        statusFilter: statusFilter,
        page: page,
        limit: limit,
      );
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(AppointmentEntity appointment) async {
    try {
      final res = await _remoteDataSource.createAppointment(AppointmentModel.fromEntity(appointment));
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> updateStatus(String id, AppointmentStatus status) async {
    try {
      final res = await _remoteDataSource.updateStatus(id, status);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> reschedule(String id, DateTime newDateTime) async {
    try {
      final res = await _remoteDataSource.reschedule(id, newDateTime);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAppointment(String id) async {
    try {
      final res = await _remoteDataSource.deleteAppointment(id);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
