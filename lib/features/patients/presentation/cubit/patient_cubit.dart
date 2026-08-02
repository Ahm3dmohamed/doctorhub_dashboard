import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/repositories/patient_repository.dart';
import 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  final PatientRepository _repository;

  PatientCubit(this._repository) : super(const PatientInitial());

  Future<void> loadPatients({String? query}) async {
    emit(const PatientLoading());
    final res = await _repository.getPatients(query: query);
    res.fold(
      (failure) => emit(PatientError(failure.message)),
      (patients) => emit(PatientLoaded(patients: patients, searchQuery: query)),
    );
  }

  Future<void> addPatient(PatientEntity patient) async {
    final res = await _repository.createPatient(patient);
    res.fold(
      (failure) => emit(PatientError(failure.message)),
      (_) => loadPatients(),
    );
  }

  Future<void> updatePatient(PatientEntity patient) async {
    final res = await _repository.updatePatient(patient);
    res.fold(
      (failure) => emit(PatientError(failure.message)),
      (_) => loadPatients(),
    );
  }

  Future<void> deletePatient(String id) async {
    final res = await _repository.deletePatient(id);
    res.fold(
      (failure) => emit(PatientError(failure.message)),
      (_) => loadPatients(),
    );
  }
}
