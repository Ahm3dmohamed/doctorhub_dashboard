import 'package:equatable/equatable.dart';
import '../../domain/entities/clinic_entity.dart';

sealed class ClinicState extends Equatable {
  const ClinicState();

  @override
  List<Object?> get props => [];
}

final class ClinicInitial extends ClinicState {
  const ClinicInitial();
}

final class ClinicLoading extends ClinicState {
  const ClinicLoading();
}

final class ClinicLoaded extends ClinicState {
  final List<ClinicEntity> clinics;
  final String? selectedCity;
  final String? searchQuery;

  const ClinicLoaded({
    required this.clinics,
    this.selectedCity,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [clinics, selectedCity, searchQuery];
}

final class ClinicError extends ClinicState {
  final String message;

  const ClinicError(this.message);

  @override
  List<Object?> get props => [message];
}
