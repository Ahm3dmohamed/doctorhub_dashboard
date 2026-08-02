import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/report_repository.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository _repository;

  ReportCubit(this._repository) : super(const ReportInitial());

  Future<void> loadReport({String period = '30D'}) async {
    emit(const ReportLoading());
    final res = await _repository.getReportSummary(period: period);
    res.fold(
      (failure) => emit(ReportError(failure.message)),
      (summary) => emit(ReportLoaded(summary: summary, selectedPeriod: period)),
    );
  }
}
