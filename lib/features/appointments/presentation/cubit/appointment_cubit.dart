import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointment_repository.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository _repository;

  AppointmentCubit(this._repository) : super(const AppointmentInitial());

  Future<void> loadAppointments({
    String? query,
    AppointmentStatus? status,
    bool? isCalendarView,
  }) async {
    emit(const AppointmentLoading());
    final res = await _repository.getAppointments(query: query, statusFilter: status);
    res.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (appointments) => emit(AppointmentLoaded(
        appointments: appointments,
        selectedStatus: status,
        searchQuery: query,
        isCalendarView: isCalendarView ?? false,
      )),
    );
  }

  void toggleViewMode() {
    if (state is AppointmentLoaded) {
      final current = state as AppointmentLoaded;
      emit(current.copyWith(isCalendarView: !current.isCalendarView));
    }
  }

  Future<void> acceptAppointment(String id) async {
    final res = await _repository.updateStatus(id, AppointmentStatus.upcoming);
    res.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (_) => loadAppointments(),
    );
  }

  Future<void> rejectAppointment(String id) async {
    final res = await _repository.updateStatus(id, AppointmentStatus.cancelled);
    res.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (_) => loadAppointments(),
    );
  }

  Future<void> rescheduleAppointment(String id, DateTime newDateTime) async {
    final res = await _repository.reschedule(id, newDateTime);
    res.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (_) => loadAppointments(),
    );
  }

  Future<void> addAppointment(AppointmentEntity appointment) async {
    final res = await _repository.createAppointment(appointment);
    res.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (_) => loadAppointments(),
    );
  }
}
