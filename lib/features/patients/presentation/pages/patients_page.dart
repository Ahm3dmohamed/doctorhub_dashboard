import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../domain/entities/patient_entity.dart';
import '../cubit/patient_cubit.dart';
import '../cubit/patient_state.dart';
import '../widgets/patient_form_dialog.dart';
import '../widgets/patient_header.dart';
import '../widgets/patient_summary_modal.dart';
import '../widgets/patient_table_view.dart';

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

  void _showPatientFormModal({PatientEntity? patient}) {
    showDialog(
      context: context,
      builder: (_) => PatientFormDialog(
        patient: patient,
        onSave: (newPatient) {
          if (patient == null) {
            context.read<PatientCubit>().addPatient(newPatient);
          } else {
            context.read<PatientCubit>().updatePatient(newPatient);
          }
        },
      ),
    );
  }

  void _showMedicalSummaryModal(PatientEntity patient) {
    showDialog(
      context: context,
      builder: (_) => PatientSummaryModal(patient: patient),
    );
  }

  void _confirmDeletePatient(PatientEntity p) async {
    final confirmed = await AppModalDialog.showConfirmation(
      context: context,
      title: 'Delete Patient Record',
      message: 'Are you sure you want to remove ${p.name}?',
    );
    if (confirmed == true && mounted) {
      context.read<PatientCubit>().deletePatient(p.id);
    }
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
                const BreadcrumbItem(label: 'Patients'),
              ],
            ),
            const SizedBox(height: AppConstants.space4),
            PatientHeader(
              onAddPatient: () => _showPatientFormModal(),
            ),
            const SizedBox(height: AppConstants.space6),
            BlocBuilder<PatientCubit, PatientState>(
              builder: (context, state) {
                final isLoading = state is PatientLoading;
                final patients = state is PatientLoaded
                    ? state.patients
                    : <PatientEntity>[];

                return PatientTableView(
                  isLoading: isLoading,
                  patients: patients,
                  onSearchChanged: (q) =>
                      context.read<PatientCubit>().loadPatients(query: q),
                  onViewSummary: _showMedicalSummaryModal,
                  onEdit: (p) => _showPatientFormModal(patient: p),
                  onDelete: _confirmDeletePatient,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
