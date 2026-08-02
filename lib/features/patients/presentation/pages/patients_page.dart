import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_data_table.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/patient_entity.dart';
import '../cubit/patient_cubit.dart';
import '../cubit/patient_state.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PatientCubit>().loadPatients();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
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
                const BreadcrumbItem(label: 'Patients'),
              ],
            ),
            const SizedBox(height: AppConstants.space4),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient Directory',
                      style: AppTypography.headingXl(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage patient medical records, allergies, and emergency contacts',
                      style: AppTypography.bodyMd(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                PrimaryButton(
                  label: 'Add Patient',
                  leadingIcon: Icons.person_add_rounded,
                  onPressed: () => _showPatientFormModal(context),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.space6),

            BlocBuilder<PatientCubit, PatientState>(
              builder: (context, state) {
                final isLoading = state is PatientLoading;
                final patients = state is PatientLoaded ? state.patients : <PatientEntity>[];

                return AppDataTable<PatientEntity>(
                  isLoading: isLoading,
                  items: patients,
                  searchHint: 'Search patients by name, email, phone...',
                  onSearchChanged: (q) => context.read<PatientCubit>().loadPatients(query: q),
                  columns: [
                    DataTableColumn<PatientEntity>(
                      title: 'Patient',
                      builder: (p) => Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.info.withValues(alpha: 0.15),
                            child: Text(
                              p.initials,
                              style: AppTypography.labelSm(color: AppColors.info),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                p.name,
                                style: AppTypography.bodyMd(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                p.email,
                                style: AppTypography.labelSm(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DataTableColumn<PatientEntity>(
                      title: 'Age / Gender',
                      builder: (p) => Text(
                        '${p.age} yrs • ${p.gender}',
                        style: AppTypography.bodySm(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    DataTableColumn<PatientEntity>(
                      title: 'Blood Group',
                      builder: (p) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                        ),
                        child: Text(
                          p.bloodGroup,
                          style: AppTypography.labelSm(color: AppColors.error),
                        ),
                      ),
                    ),
                    DataTableColumn<PatientEntity>(
                      title: 'Emergency Contact',
                      builder: (p) => Text(
                        '${p.emergencyContact.name} (${p.emergencyContact.relation})',
                        style: AppTypography.labelSm(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    DataTableColumn<PatientEntity>(
                      title: 'Actions',
                      builder: (p) => Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.medical_information_outlined, size: 18),
                            onPressed: () => _showMedicalSummaryModal(context, p),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () => _showPatientFormModal(context, patient: p),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                            onPressed: () async {
                              final confirmed = await AppModalDialog.showConfirmation(
                                context: context,
                                title: 'Delete Patient Record',
                                message: 'Are you sure you want to remove ${p.name}?',
                              );
                              if (confirmed == true && context.mounted) {
                                context.read<PatientCubit>().deletePatient(p.id);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPatientFormModal(BuildContext context, {PatientEntity? patient}) {
    final nameCtrl = TextEditingController(text: patient?.name);
    final emailCtrl = TextEditingController(text: patient?.email);
    final phoneCtrl = TextEditingController(text: patient?.phone);
    final ageCtrl = TextEditingController(text: patient?.age.toString());
    final bloodCtrl = TextEditingController(text: patient?.bloodGroup ?? 'O+');
    final historyCtrl = TextEditingController(text: patient?.medicalHistory);
    final allergiesCtrl = TextEditingController(text: patient?.allergies);

    showDialog(
      context: context,
      builder: (ctx) => AppModalDialog(
        title: patient == null ? 'Add New Patient' : 'Edit Patient',
        subtitle: 'Enter patient bio and emergency contact details.',
        onConfirm: () {
          final newPatient = PatientEntity(
            id: patient?.id ?? '',
            name: nameCtrl.text.isEmpty ? 'Jane Doe' : nameCtrl.text,
            email: emailCtrl.text.isEmpty ? 'patient@example.com' : emailCtrl.text,
            phone: phoneCtrl.text.isEmpty ? '+1 (555) 000-0000' : phoneCtrl.text,
            age: int.tryParse(ageCtrl.text) ?? 30,
            gender: patient?.gender ?? 'Female',
            bloodGroup: bloodCtrl.text,
            emergencyContact: patient?.emergencyContact ??
                const EmergencyContact(name: 'Contact Person', relation: 'Family', phone: '+1 (555) 111-0000'),
            medicalHistory: historyCtrl.text.isEmpty ? 'No prior medical history.' : historyCtrl.text,
            allergies: allergiesCtrl.text.isEmpty ? 'None' : allergiesCtrl.text,
            registeredAt: patient?.registeredAt ?? DateTime.now(),
          );

          if (patient == null) {
            context.read<PatientCubit>().addPatient(newPatient);
          } else {
            context.read<PatientCubit>().updatePatient(newPatient);
          }
          Navigator.of(ctx).pop();
        },
        content: Column(
          children: [
            AppTextField(controller: nameCtrl, label: 'Full Name', hint: 'Jane Doe'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: emailCtrl, label: 'Email Address', hint: 'patient@example.com'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: phoneCtrl, label: 'Phone Number', hint: '+1 (555) 000-0000'),
            const SizedBox(height: AppConstants.space3),
            Row(
              children: [
                Expanded(child: AppTextField(controller: ageCtrl, label: 'Age', hint: '30')),
                const SizedBox(width: AppConstants.space3),
                Expanded(child: AppTextField(controller: bloodCtrl, label: 'Blood Group', hint: 'O+')),
              ],
            ),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: historyCtrl, label: 'Medical History', hint: 'Prior conditions...', maxLines: 2),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: allergiesCtrl, label: 'Known Allergies', hint: 'Penicillin...'),
          ],
        ),
      ),
    );
  }

  void _showMedicalSummaryModal(BuildContext context, PatientEntity p) {
    showDialog(
      context: context,
      builder: (ctx) => AppModalDialog(
        title: 'Medical Summary — ${p.name}',
        subtitle: '${p.age} yrs • ${p.gender} • Blood Type ${p.bloodGroup}',
        cancelLabel: null,
        confirmLabel: 'Close',
        onConfirm: () => Navigator.of(ctx).pop(),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Medical History', style: AppTypography.headingSm()),
            const SizedBox(height: 4),
            Text(p.medicalHistory),
            const SizedBox(height: 16),
            Text('Known Allergies', style: AppTypography.headingSm()),
            const SizedBox(height: 4),
            Text(p.allergies, style: const TextStyle(color: AppColors.error)),
            const SizedBox(height: 16),
            Text('Emergency Contact', style: AppTypography.headingSm()),
            const SizedBox(height: 4),
            Text('${p.emergencyContact.name} (${p.emergencyContact.relation})'),
            Text('Phone: ${p.emergencyContact.phone}'),
          ],
        ),
      ),
    );
  }
}
