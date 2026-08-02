import 'package:equatable/equatable.dart';
import '../../domain/entities/report_entity.dart';

sealed class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

final class ReportInitial extends ReportState {
  const ReportInitial();
}

final class ReportLoading extends ReportState {
  const ReportLoading();
}

final class ReportLoaded extends ReportState {
  final ReportSummaryEntity summary;
  final String selectedPeriod;

  const ReportLoaded({
    required this.summary,
    this.selectedPeriod = '30D',
  });

  @override
  List<Object?> get props => [summary, selectedPeriod];
}

final class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object?> get props => [message];
}
