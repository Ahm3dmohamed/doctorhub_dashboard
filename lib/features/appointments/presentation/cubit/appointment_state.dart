import 'package:equatable/equatable.dart';
import '../../domain/entities/appointment_entity.dart';

sealed class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

final class AppointmentInitial extends AppointmentState {
  const AppointmentInitial();
}

final class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

final class AppointmentLoaded extends AppointmentState {
  final List<AppointmentEntity> appointments;
  final AppointmentStatus? selectedStatus;
  final String? searchQuery;
  final bool isCalendarView;

  const AppointmentLoaded({
    required this.appointments,
    this.selectedStatus,
    this.searchQuery,
    this.isCalendarView = false,
  });

  AppointmentLoaded copyWith({
    List<AppointmentEntity>? appointments,
    AppointmentStatus? selectedStatus,
    String? searchQuery,
    bool? isCalendarView,
  }) {
    return AppointmentLoaded(
      appointments: appointments ?? this.appointments,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      isCalendarView: isCalendarView ?? this.isCalendarView,
    );
  }

  @override
  List<Object?> get props => [appointments, selectedStatus, searchQuery, isCalendarView];
}

final class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}
