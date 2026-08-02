import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/repositories/prescription_repository.dart';
import '../datasources/prescription_remote_datasource.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionRemoteDataSource _remoteDataSource;

  PrescriptionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<PrescriptionEntity>>> getPrescriptions({
    String? query,
    PrescriptionStatus? status,
    String? patientId,
  }) async {
    try {
      final res = await _remoteDataSource.getPrescriptions(
        query: query,
        status: status,
        patientId: patientId,
      );
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PrescriptionEntity>> createPrescription(
    PrescriptionEntity prescription,
  ) async {
    try {
      final res = await _remoteDataSource.createPrescription(prescription);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePrescription(String id) async {
    try {
      await _remoteDataSource.deletePrescription(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
