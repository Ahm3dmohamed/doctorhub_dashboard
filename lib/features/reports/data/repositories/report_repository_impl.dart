import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource _remoteDataSource;

  ReportRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ReportSummaryEntity>> getReportSummary(
      {String? period}) async {
    try {
      final res = await _remoteDataSource.getReportSummary(period: period);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
