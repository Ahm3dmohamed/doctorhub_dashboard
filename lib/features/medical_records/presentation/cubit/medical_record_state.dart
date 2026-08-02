import 'package:equatable/equatable.dart';
import '../../domain/entities/medical_record_entity.dart';

sealed class MedicalRecordState extends Equatable {
  const MedicalRecordState();

  @override
  List<Object?> get props => [];
}

final class MedicalRecordInitial extends MedicalRecordState {
  const MedicalRecordInitial();
}

final class MedicalRecordLoading extends MedicalRecordState {
  const MedicalRecordLoading();
}

final class MedicalRecordLoaded extends MedicalRecordState {
  final List<MedicalRecordEntity> records;
  final MedicalRecordEntity? selectedRecord;
  final RecordType? selectedType;
  final String? searchQuery;
  final bool isTimelineView;

  const MedicalRecordLoaded({
    required this.records,
    this.selectedRecord,
    this.selectedType,
    this.searchQuery,
    this.isTimelineView = false,
  });

  MedicalRecordLoaded copyWith({
    List<MedicalRecordEntity>? records,
    MedicalRecordEntity? selectedRecord,
    RecordType? selectedType,
    String? searchQuery,
    bool? isTimelineView,
  }) {
    return MedicalRecordLoaded(
      records: records ?? this.records,
      selectedRecord: selectedRecord ?? this.selectedRecord,
      selectedType: selectedType ?? this.selectedType,
      searchQuery: searchQuery ?? this.searchQuery,
      isTimelineView: isTimelineView ?? this.isTimelineView,
    );
  }

  @override
  List<Object?> get props =>
      [records, selectedRecord, selectedType, searchQuery, isTimelineView];
}

final class MedicalRecordError extends MedicalRecordState {
  final String message;

  const MedicalRecordError(this.message);

  @override
  List<Object?> get props => [message];
}
