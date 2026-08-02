import 'package:equatable/equatable.dart';
import '../../domain/entities/prescription_entity.dart';

sealed class PrescriptionState extends Equatable {
  const PrescriptionState();

  @override
  List<Object?> get props => [];
}

final class PrescriptionInitial extends PrescriptionState {
  const PrescriptionInitial();
}

final class PrescriptionLoading extends PrescriptionState {
  const PrescriptionLoading();
}

final class PrescriptionLoaded extends PrescriptionState {
  final List<PrescriptionEntity> prescriptions;
  final PrescriptionStatus? selectedStatus;
  final String? searchQuery;

  const PrescriptionLoaded({
    required this.prescriptions,
    this.selectedStatus,
    this.searchQuery,
  });

  PrescriptionLoaded copyWith({
    List<PrescriptionEntity>? prescriptions,
    PrescriptionStatus? selectedStatus,
    String? searchQuery,
  }) {
    return PrescriptionLoaded(
      prescriptions: prescriptions ?? this.prescriptions,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [prescriptions, selectedStatus, searchQuery];
}

final class PrescriptionError extends PrescriptionState {
  final String message;

  const PrescriptionError(this.message);

  @override
  List<Object?> get props => [message];
}
