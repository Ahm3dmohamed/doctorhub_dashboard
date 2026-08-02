import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repositories/doctor_repository.dart';
import 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  final DoctorRepository _repository;

  DoctorCubit(this._repository) : super(const DoctorInitial());

  Future<void> loadDoctors({
    String? query,
    String? specialty,
    int page = 1,
  }) async {
    emit(const DoctorLoading());
    final result = await _repository.getDoctors(
      query: query,
      specialtyFilter: specialty,
      page: page,
    );

    result.fold(
      (failure) => emit(DoctorError(failure.message)),
      (doctors) => emit(DoctorLoaded(
        doctors: doctors,
        selectedSpecialty: specialty,
        searchQuery: query,
        currentPage: page,
      )),
    );
  }

  Future<void> addDoctor(DoctorEntity doctor) async {
    final result = await _repository.createDoctor(doctor);
    result.fold(
      (failure) => emit(DoctorError(failure.message)),
      (_) => loadDoctors(),
    );
  }

  Future<void> updateDoctor(DoctorEntity doctor) async {
    final result = await _repository.updateDoctor(doctor);
    result.fold(
      (failure) => emit(DoctorError(failure.message)),
      (_) => loadDoctors(),
    );
  }

  Future<void> deleteDoctor(String id) async {
    final result = await _repository.deleteDoctor(id);
    result.fold(
      (failure) => emit(DoctorError(failure.message)),
      (_) => loadDoctors(),
    );
  }
}
