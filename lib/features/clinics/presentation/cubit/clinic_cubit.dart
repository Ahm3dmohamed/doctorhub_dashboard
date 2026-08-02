import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/clinic_entity.dart';
import '../../domain/repositories/clinic_repository.dart';
import 'clinic_state.dart';

class ClinicCubit extends Cubit<ClinicState> {
  final ClinicRepository _repository;

  ClinicCubit(this._repository) : super(const ClinicInitial());

  Future<void> loadClinics({String? query, String? city}) async {
    emit(const ClinicLoading());
    final res = await _repository.getClinics(query: query, cityFilter: city);
    res.fold(
      (failure) => emit(ClinicError(failure.message)),
      (clinics) => emit(ClinicLoaded(clinics: clinics, selectedCity: city, searchQuery: query)),
    );
  }

  Future<void> addClinic(ClinicEntity clinic) async {
    final res = await _repository.createClinic(clinic);
    res.fold(
      (failure) => emit(ClinicError(failure.message)),
      (_) => loadClinics(),
    );
  }

  Future<void> updateClinic(ClinicEntity clinic) async {
    final res = await _repository.updateClinic(clinic);
    res.fold(
      (failure) => emit(ClinicError(failure.message)),
      (_) => loadClinics(),
    );
  }

  Future<void> deleteClinic(String id) async {
    final res = await _repository.deleteClinic(id);
    res.fold(
      (failure) => emit(ClinicError(failure.message)),
      (_) => loadClinics(),
    );
  }
}
