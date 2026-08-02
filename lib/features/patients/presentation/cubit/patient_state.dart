import 'package:equatable/equatable.dart';
import '../../domain/entities/patient_entity.dart';

sealed class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object?> get props => [];
}

final class PatientInitial extends PatientState {
  const PatientInitial();
}

final class PatientLoading extends PatientState {
  const PatientLoading();
}

final class PatientLoaded extends PatientState {
  final List<PatientEntity> patients;
  final String? searchQuery;

  const PatientLoaded({
    required this.patients,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [patients, searchQuery];
}

final class PatientError extends PatientState {
  final String message;

  const PatientError(this.message);

  @override
  List<Object?> get props => [message];
}
