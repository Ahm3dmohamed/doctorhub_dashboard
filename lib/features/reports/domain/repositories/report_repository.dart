import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/report_entity.dart';

abstract class ReportRepository {
  Future<Either<Failure, ReportSummaryEntity>> getReportSummary({String? period});
}
