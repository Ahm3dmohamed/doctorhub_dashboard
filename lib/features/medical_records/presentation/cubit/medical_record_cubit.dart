import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/medical_record_entity.dart';
import '../../domain/repositories/medical_record_repository.dart';
import 'medical_record_state.dart';

class MedicalRecordCubit extends Cubit<MedicalRecordState> {
  final MedicalRecordRepository _repository;

  MedicalRecordCubit(this._repository) : super(const MedicalRecordInitial());

  Future<void> loadRecords({
    String? query,
    RecordType? type,
    String? patientId,
  }) async {
    emit(const MedicalRecordLoading());
    final res = await _repository.getRecords(
      query: query,
      type: type,
      patientId: patientId,
    );
    res.fold(
      (failure) => emit(MedicalRecordError(failure.message)),
      (records) => emit(MedicalRecordLoaded(
        records: records,
        selectedRecord: records.isNotEmpty ? records.first : null,
        selectedType: type,
        searchQuery: query,
      )),
    );
  }

  void selectRecord(MedicalRecordEntity record) {
    if (state is MedicalRecordLoaded) {
      final curr = state as MedicalRecordLoaded;
      emit(curr.copyWith(selectedRecord: record));
    }
  }

  void toggleViewMode() {
    if (state is MedicalRecordLoaded) {
      final curr = state as MedicalRecordLoaded;
      emit(curr.copyWith(isTimelineView: !curr.isTimelineView));
    }
  }

  Future<void> deleteRecord(String id) async {
    final res = await _repository.deleteRecord(id);
    res.fold(
      (failure) => emit(MedicalRecordError(failure.message)),
      (_) => loadRecords(),
    );
  }
}
