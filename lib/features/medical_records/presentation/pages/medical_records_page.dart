import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/medical_record_entity.dart';
import '../cubit/medical_record_cubit.dart';
import '../cubit/medical_record_state.dart';
import '../widgets/medical_record_detail_card.dart';
import '../widgets/medical_record_header.dart';
import '../widgets/medical_record_master_detail_view.dart';
import '../widgets/medical_record_search_filter.dart';
import '../widgets/medical_record_timeline_view.dart';

class MedicalRecordsPage extends StatefulWidget {
  const MedicalRecordsPage({super.key});

  @override
  State<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  final TextEditingController _searchController = TextEditingController();
  RecordType? _selectedTypeFilter;

  @override
  void initState() {
    super.initState();
    context.read<MedicalRecordCubit>().loadRecords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDetailModal(BuildContext context, MedicalRecordEntity record) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppConstants.radius2xl),
          ),
        ),
        padding: const EdgeInsets.all(AppConstants.space6),
        child: SingleChildScrollView(
          child: MedicalRecordDetailCard(record: record),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBreadcrumb(
              items: [
                BreadcrumbItem(
                  label: 'Dashboard',
                  onTap: () => context.go(AppRoutes.dashboard),
                ),
                const BreadcrumbItem(label: 'Medical Records'),
              ],
            ),
            const SizedBox(height: AppConstants.space4),
            BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
              builder: (context, state) {
                final isTimeline =
                    state is MedicalRecordLoaded && state.isTimelineView;
                return MedicalRecordHeader(
                  isTimelineView: isTimeline,
                  onToggleView: () =>
                      context.read<MedicalRecordCubit>().toggleViewMode(),
                );
              },
            ),
            const SizedBox(height: AppConstants.space6),
            MedicalRecordSearchFilter(
              searchController: _searchController,
              selectedType: _selectedTypeFilter,
              onSearchChanged: (val) {
                context.read<MedicalRecordCubit>().loadRecords(
                      query: val,
                      type: _selectedTypeFilter,
                    );
              },
              onTypeChanged: (val) {
                setState(() => _selectedTypeFilter = val);
                context.read<MedicalRecordCubit>().loadRecords(
                      query: _searchController.text,
                      type: val,
                    );
              },
            ),
            const SizedBox(height: AppConstants.space6),
            BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
              builder: (context, state) {
                if (state is MedicalRecordLoading) {
                  return const LoadingWidget(message: 'Loading EMR Records...');
                }

                if (state is MedicalRecordError) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () =>
                        context.read<MedicalRecordCubit>().loadRecords(),
                  );
                }

                if (state is MedicalRecordLoaded) {
                  if (state.records.isEmpty) {
                    return const EmptyWidget(
                      title: 'No Medical Records Found',
                      message: 'There are no EMR records matching your criteria.',
                      icon: Icons.folder_open_rounded,
                    );
                  }

                  if (state.isTimelineView) {
                    return MedicalRecordTimelineView(records: state.records);
                  }

                  return MedicalRecordMasterDetailView(
                    state: state,
                    onSelectRecord: (rec) {
                      context.read<MedicalRecordCubit>().selectRecord(rec);
                    },
                    onShowMobileDetail: (rec) => _showDetailModal(context, rec),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
