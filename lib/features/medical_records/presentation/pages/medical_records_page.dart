import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/medical_record_entity.dart';
import '../cubit/medical_record_cubit.dart';
import '../cubit/medical_record_state.dart';

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

            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medical Records & EHR',
                      style: AppTypography.headingXl(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Electronic Health Records, Diagnoses, Lab Results, Radiology & Doctor Notes',
                      style: AppTypography.bodyMd(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
                  builder: (context, state) {
                    final isTimeline =
                        state is MedicalRecordLoaded && state.isTimelineView;
                    return SecondaryButton(
                      label: isTimeline ? 'Table View' : 'Timeline View',
                      leadingIcon: isTimeline
                          ? Icons.table_chart_rounded
                          : Icons.timeline_rounded,
                      onPressed: () =>
                          context.read<MedicalRecordCubit>().toggleViewMode(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space6),

            // Filters & Search
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _searchController,
                    hint: 'Search by patient, doctor, diagnosis or ID...',
                    prefixIcon: Icons.search_rounded,
                    onChanged: (val) {
                      context.read<MedicalRecordCubit>().loadRecords(
                        query: val,
                        type: _selectedTypeFilter,
                      );
                    },
                    label: '',
                  ),
                ),
                const SizedBox(width: AppConstants.space3),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.space3,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<RecordType?>(
                      value: _selectedTypeFilter,
                      hint: Text(
                        'All Record Types',
                        style: AppTypography.bodySm(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      dropdownColor: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      items: [
                        DropdownMenuItem<RecordType?>(
                          value: null,
                          child: Text(
                            'All Record Types',
                            style: AppTypography.bodySm(),
                          ),
                        ),
                        ...RecordType.values.map(
                          (t) => DropdownMenuItem<RecordType?>(
                            value: t,
                            child: Text(
                              t.displayName,
                              style: AppTypography.bodySm(),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => _selectedTypeFilter = val);
                        context.read<MedicalRecordCubit>().loadRecords(
                          query: _searchController.text,
                          type: val,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space6),

            // Content
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
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.space10),
                        child: Column(
                          children: [
                            Icon(
                              Icons.folder_open_rounded,
                              size: 64,
                              color: AppColors.neutral500,
                            ),
                            const SizedBox(height: AppConstants.space3),
                            Text(
                              'No medical records found',
                              style: AppTypography.headingMd(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state.isTimelineView) {
                    return _buildTimelineView(context, state.records, isDark);
                  }

                  return _buildMasterDetailView(context, state, isDark);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineView(
    BuildContext context,
    List<MedicalRecordEntity> records,
    bool isDark,
  ) {
    return Column(
      children: records.map((rec) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppConstants.space4),
          padding: const EdgeInsets.all(AppConstants.space4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_information_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppConstants.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(rec.patientName, style: AppTypography.headingSm()),
                        Text(
                          DateFormat('MMM dd, yyyy').format(rec.date),
                          style: AppTypography.bodySm(
                            color: AppColors.neutral400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${rec.type.displayName} • ${rec.doctorName}',
                      style: AppTypography.labelMd(
                        color: AppColors.primaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (rec.diagnoses.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        children: rec.diagnoses
                            .map(
                              (d) => Chip(
                                label: Text(d, style: AppTypography.labelSm()),
                                backgroundColor: AppColors.primaryContainer,
                              ),
                            )
                            .toList(),
                      ),
                    if (rec.doctorNotes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(rec.doctorNotes, style: AppTypography.bodyMd()),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMasterDetailView(
    BuildContext context,
    MedicalRecordLoaded state,
    bool isDark,
  ) {
    final selected = state.selectedRecord ?? state.records.first;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left list
              Expanded(
                flex: 4,
                child: Column(
                  children: state.records.map((rec) {
                    final isSel = selected.id == rec.id;
                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: AppConstants.space3,
                      ),
                      decoration: BoxDecoration(
                        color: isSel
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : (isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusLg,
                        ),
                        border: Border.all(
                          color: isSel
                              ? AppColors.primary
                              : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                          width: isSel ? 1.5 : 1,
                        ),
                      ),
                      child: ListTile(
                        onTap: () => context
                            .read<MedicalRecordCubit>()
                            .selectRecord(rec),
                        title: Text(
                          rec.patientName,
                          style: AppTypography.headingSm(),
                        ),
                        subtitle: Text(
                          '${rec.type.displayName} • ${DateFormat('MMM dd, yyyy').format(rec.date)}',
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: AppConstants.space6),
              // Right detail card
              Expanded(flex: 6, child: _buildDetailCard(selected, isDark)),
            ],
          );
        }

        // Mobile list view with dialog on tap
        return Column(
          children: state.records.map((rec) {
            return Card(
              margin: const EdgeInsets.only(bottom: AppConstants.space3),
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              child: ListTile(
                title: Text(rec.patientName, style: AppTypography.headingSm()),
                subtitle: Text(
                  '${rec.type.displayName} • ${DateFormat('MMM dd').format(rec.date)}',
                ),
                onTap: () => _showDetailModal(context, rec, isDark),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildDetailCard(MedicalRecordEntity record, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.patientName, style: AppTypography.headingLg()),
                  Text(
                    'Record ID: ${record.id} • ${record.clinicName}',
                    style: AppTypography.bodySm(color: AppColors.neutral400),
                  ),
                ],
              ),
              Chip(
                label: Text(
                  record.type.displayName,
                  style: AppTypography.labelSm(color: Colors.white),
                ),
                backgroundColor: AppColors.primary,
              ),
            ],
          ),
          const Divider(height: 32),

          // Doctor & Date
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Doctor: ${record.doctorName}',
                style: AppTypography.bodyMd(),
              ),
              const Spacer(),
              const Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: AppColors.neutral400,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMMM dd, yyyy').format(record.date),
                style: AppTypography.bodySm(color: AppColors.neutral400),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space4),

          // Diagnoses & Symptoms
          if (record.diagnoses.isNotEmpty) ...[
            Text('Diagnoses:', style: AppTypography.labelMd()),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              children: record.diagnoses
                  .map(
                    (d) => Chip(
                      label: Text(d),
                      backgroundColor: AppColors.errorLight,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppConstants.space4),
          ],

          if (record.symptoms.isNotEmpty) ...[
            Text('Symptoms:', style: AppTypography.labelMd()),
            const SizedBox(height: 4),
            Text(record.symptoms.join(', '), style: AppTypography.bodyMd()),
            const SizedBox(height: AppConstants.space4),
          ],

          // Lab Results if any
          if (record.labResults.isNotEmpty) ...[
            Text('Lab Results:', style: AppTypography.labelMd()),
            const SizedBox(height: 8),
            ...record.labResults.map(
              (lab) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: lab.isAbnormal
                      ? AppColors.errorLight.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: lab.isAbnormal
                        ? AppColors.error
                        : AppColors.neutral300,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(lab.testName, style: AppTypography.bodyMd()),
                    Text(
                      '${lab.value} ${lab.unit} (Ref: ${lab.referenceRange})',
                      style: AppTypography.bodySm(
                        color: lab.isAbnormal
                            ? AppColors.error
                            : AppColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.space4),
          ],

          // Doctor Notes
          if (record.doctorNotes.isNotEmpty) ...[
            Text('Doctor Notes:', style: AppTypography.labelMd()),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral900 : AppColors.neutral100,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Text(record.doctorNotes, style: AppTypography.bodyMd()),
            ),
            const SizedBox(height: AppConstants.space4),
          ],

          // Attachments
          if (record.attachments.isNotEmpty) ...[
            Text('Attachments:', style: AppTypography.labelMd()),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: record.attachments
                  .map(
                    (att) => ActionChip(
                      avatar: const Icon(Icons.attach_file_rounded, size: 16),
                      label: Text('${att.name} (${att.size})'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading ${att.name}...')),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  void _showDetailModal(
    BuildContext context,
    MedicalRecordEntity record,
    bool isDark,
  ) {
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
        child: SingleChildScrollView(child: _buildDetailCard(record, isDark)),
      ),
    );
  }
}
