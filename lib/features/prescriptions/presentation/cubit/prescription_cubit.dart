import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/repositories/prescription_repository.dart';
import 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final PrescriptionRepository _repository;

  PrescriptionCubit(this._repository) : super(const PrescriptionInitial());

  Future<void> loadPrescriptions({
    String? query,
    PrescriptionStatus? status,
    String? patientId,
  }) async {
    emit(const PrescriptionLoading());
    final res = await _repository.getPrescriptions(
      query: query,
      status: status,
      patientId: patientId,
    );
    res.fold(
      (failure) => emit(PrescriptionError(failure.message)),
      (prescriptions) => emit(PrescriptionLoaded(
        prescriptions: prescriptions,
        selectedStatus: status,
        searchQuery: query,
      )),
    );
  }

  Future<void> createPrescription(PrescriptionEntity rx) async {
    final res = await _repository.createPrescription(rx);
    res.fold(
      (failure) => emit(PrescriptionError(failure.message)),
      (_) => loadPrescriptions(),
    );
  }

  Future<void> deletePrescription(String id) async {
    final res = await _repository.deletePrescription(id);
    res.fold(
      (failure) => emit(PrescriptionError(failure.message)),
      (_) => loadPrescriptions(),
    );
  }
}
