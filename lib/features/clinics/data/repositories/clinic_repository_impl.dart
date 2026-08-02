import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/clinic_entity.dart';
import '../../domain/repositories/clinic_repository.dart';
import '../datasources/clinic_remote_datasource.dart';
import '../models/clinic_model.dart';

class ClinicRepositoryImpl implements ClinicRepository {
  final ClinicRemoteDataSource _remoteDataSource;

  const ClinicRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ClinicEntity>>> getClinics({
    String? query,
    String? cityFilter,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final res = await _remoteDataSource.getClinics(
        query: query,
        cityFilter: cityFilter,
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
  Future<Either<Failure, ClinicEntity>> createClinic(ClinicEntity clinic) async {
    try {
      final created = await _remoteDataSource.createClinic(ClinicModel.fromEntity(clinic));
      return Right(created);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClinicEntity>> updateClinic(ClinicEntity clinic) async {
    try {
      final updated = await _remoteDataSource.updateClinic(ClinicModel.fromEntity(clinic));
      return Right(updated);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteClinic(String id) async {
    try {
      final res = await _remoteDataSource.deleteClinic(id);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
