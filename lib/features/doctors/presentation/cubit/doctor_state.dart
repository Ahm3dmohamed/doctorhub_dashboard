import 'package:equatable/equatable.dart';
import '../../domain/entities/doctor_entity.dart';

sealed class DoctorState extends Equatable {
  const DoctorState();

  @override
  List<Object?> get props => [];
}

final class DoctorInitial extends DoctorState {
  const DoctorInitial();
}

final class DoctorLoading extends DoctorState {
  const DoctorLoading();
}

final class DoctorLoaded extends DoctorState {
  final List<DoctorEntity> doctors;
  final String? selectedSpecialty;
  final String? searchQuery;
  final int currentPage;

  const DoctorLoaded({
    required this.doctors,
    this.selectedSpecialty,
    this.searchQuery,
    this.currentPage = 1,
  });

  DoctorLoaded copyWith({
    List<DoctorEntity>? doctors,
    String? selectedSpecialty,
    String? searchQuery,
    int? currentPage,
  }) {
    return DoctorLoaded(
      doctors: doctors ?? this.doctors,
      selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [doctors, selectedSpecialty, searchQuery, currentPage];
}

final class DoctorError extends DoctorState {
  final String message;

  const DoctorError(this.message);

  @override
  List<Object?> get props => [message];
}
