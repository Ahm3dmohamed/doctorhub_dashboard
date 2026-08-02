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
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/prescription_entity.dart';
import '../cubit/prescription_cubit.dart';
import '../cubit/prescription_state.dart';

class PrescriptionsPage extends StatefulWidget {
  const PrescriptionsPage({super.key});

  @override
  State<PrescriptionsPage> createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends State<PrescriptionsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PrescriptionCubit>().loadPrescriptions();
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
                const BreadcrumbItem(label: 'Prescriptions'),
              ],
            ),
            const SizedBox(height: AppConstants.space4),

            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prescriptions & Medications',
                      style: AppTypography.headingXl(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage digital e-prescriptions, medicine dosages, frequency & PDF exports',
                      style: AppTypography.bodyMd(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                PrimaryButton(
                  label: 'New Prescription',
                  leadingIcon: Icons.add_rounded,
                  onPressed: () =>
                      _showCreatePrescriptionDialog(context, isDark),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space6),

            // Search bar
            AppTextField(
              controller: _searchController,
              label: 'Search Prescriptions',
              hint:
                  'Search prescription by patient, doctor, medicine or Rx ID...',
              prefixIcon: Icons.search_rounded,
              onChanged: (val) {
                context.read<PrescriptionCubit>().loadPrescriptions(query: val);
              },
            ),
            const SizedBox(height: AppConstants.space6),

            // Content
            BlocBuilder<PrescriptionCubit, PrescriptionState>(
              builder: (context, state) {
                if (state is PrescriptionLoading) {
                  return const LoadingWidget(
                    message: 'Loading Prescriptions...',
                  );
                }
                if (state is PrescriptionError) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () =>
                        context.read<PrescriptionCubit>().loadPrescriptions(),
                  );
                }
                if (state is PrescriptionLoaded) {
                  if (state.prescriptions.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.space10),
                        child: Text(
                          'No prescriptions found.',
                          style: AppTypography.headingMd(),
                        ),
                      ),
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth > 1100
                          ? 3
                          : (constraints.maxWidth > 700 ? 2 : 1);
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: AppConstants.space4,
                          mainAxisSpacing: AppConstants.space4,
                        ),
                        itemCount: state.prescriptions.length,
                        itemBuilder: (context, index) {
                          final rx = state.prescriptions[index];
                          return _buildPrescriptionCard(context, rx, isDark);
                        },
                      );
                    },
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

  Widget _buildPrescriptionCard(
    BuildContext context,
    PrescriptionEntity rx,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space5),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Text(
                  rx.id,
                  style: AppTypography.labelSm(color: AppColors.primary),
                ),
              ),
              Chip(
                label: Text(
                  rx.status.displayName,
                  style: AppTypography.labelSm(),
                ),
                backgroundColor: rx.status == PrescriptionStatus.active
                    ? AppColors.successLight
                    : AppColors.neutral200,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(rx.patientName, style: AppTypography.headingMd()),
          Text(
            'Prescribed by ${rx.doctorName}',
            style: AppTypography.bodySm(color: AppColors.neutral400),
          ),
          Text(
            DateFormat('MMM dd, yyyy').format(rx.date),
            style: AppTypography.bodySm(color: AppColors.neutral400),
          ),
          const Divider(height: 20),

          Text(
            '${rx.medicines.length} Medicines Prescribed:',
            style: AppTypography.labelMd(),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: rx.medicines.length,
              itemBuilder: (context, idx) {
                final med = rx.medicines[idx];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.medication_rounded,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${med.name} (${med.dosage}) - ${med.frequency}',
                          style: AppTypography.bodySm(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SecondaryButton(
                label: 'PDF Export',
                leadingIcon: Icons.picture_as_pdf_rounded,
                height: 36,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Generating PDF for ${rx.id}... (Placeholder)',
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                ),
                onPressed: () {
                  context.read<PrescriptionCubit>().deletePrescription(rx.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreatePrescriptionDialog(BuildContext context, bool isDark) {
    final patientNameCtrl = TextEditingController();
    final doctorNameCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final List<Map<String, TextEditingController>> medicineCtrls = [
      {
        'name': TextEditingController(),
        'dosage': TextEditingController(),
        'frequency': TextEditingController(),
        'duration': TextEditingController(),
        'instructions': TextEditingController(),
      },
    ];

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AppModalDialog(
            title: 'Create New Prescription',
            content: SizedBox(
              width: 600,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextField(
                      controller: patientNameCtrl,
                      label: 'Patient Name',
                      hint: 'e.g. Sarah Jenkins',
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: doctorNameCtrl,
                      label: 'Doctor Name',
                      hint: 'e.g. Dr. Alexander Wright',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Medicines List',
                          style: AppTypography.headingSm(),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Medicine'),
                          onPressed: () {
                            setModalState(() {
                              medicineCtrls.add({
                                'name': TextEditingController(),
                                'dosage': TextEditingController(),
                                'frequency': TextEditingController(),
                                'duration': TextEditingController(),
                                'instructions': TextEditingController(),
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    ...medicineCtrls.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final map = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.neutral900
                              : AppColors.neutral100,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMd,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Medicine #${idx + 1}',
                                  style: AppTypography.labelMd(),
                                ),
                                const Spacer(),
                                if (medicineCtrls.length > 1)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: AppColors.error,
                                    ),
                                    onPressed: () {
                                      setModalState(
                                        () => medicineCtrls.removeAt(idx),
                                      );
                                    },
                                  ),
                              ],
                            ),
                            AppTextField(
                              controller: map['name']!,
                              label: 'Medicine Name',
                              hint: 'e.g. Amoxicillin',
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: map['dosage']!,
                                    label: 'Dosage',
                                    hint: '500mg',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AppTextField(
                                    controller: map['frequency']!,
                                    label: 'Frequency',
                                    hint: '3x Daily',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: map['duration']!,
                                    label: 'Duration',
                                    hint: '7 Days',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AppTextField(
                                    controller: map['instructions']!,
                                    label: 'Instructions',
                                    hint: 'After meals',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    AppTextField(
                      controller: notesCtrl,
                      label: 'Prescription Notes',
                      hint: 'Special advice/precautions',
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Save Prescription',
                      onPressed: () {
                        final newRx = PrescriptionEntity(
                          id: 'RX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                          patientId: 'PAT-001',
                          patientName: patientNameCtrl.text.isEmpty
                              ? 'Patient'
                              : patientNameCtrl.text,
                          doctorId: 'DOC-001',
                          doctorName: doctorNameCtrl.text.isEmpty
                              ? 'Doctor'
                              : doctorNameCtrl.text,
                          date: DateTime.now(),
                          status: PrescriptionStatus.active,
                          notes: notesCtrl.text,
                          medicines: medicineCtrls.map((m) {
                            return MedicineItem(
                              name: m['name']!.text.isEmpty
                                  ? 'Medicine'
                                  : m['name']!.text,
                              dosage: m['dosage']!.text.isEmpty
                                  ? '10mg'
                                  : m['dosage']!.text,
                              frequency: m['frequency']!.text.isEmpty
                                  ? 'Daily'
                                  : m['frequency']!.text,
                              duration: m['duration']!.text.isEmpty
                                  ? '7 Days'
                                  : m['duration']!.text,
                              instructions: m['instructions']!.text.isEmpty
                                  ? 'With water'
                                  : m['instructions']!.text,
                            );
                          }).toList(),
                        );
                        context.read<PrescriptionCubit>().createPrescription(
                          newRx,
                        );
                        Navigator.of(dialogCtx).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
