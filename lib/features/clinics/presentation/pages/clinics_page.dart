import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../domain/entities/clinic_entity.dart';
import '../cubit/clinic_cubit.dart';
import '../cubit/clinic_state.dart';
import '../widgets/clinic_form_dialog.dart';
import '../widgets/clinic_header.dart';
import '../widgets/clinic_location_modal.dart';
import '../widgets/clinic_table_view.dart';

class ClinicsPage extends StatefulWidget {
  const ClinicsPage({super.key});

  @override
  State<ClinicsPage> createState() => _ClinicsPageState();
}

class _ClinicsPageState extends State<ClinicsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ClinicCubit>().loadClinics();
  }

  void _showClinicFormModal({ClinicEntity? clinic}) {
    showDialog(
      context: context,
      builder: (_) => ClinicFormDialog(
        clinic: clinic,
        onSave: (newClinic) {
          if (clinic == null) {
            context.read<ClinicCubit>().addClinic(newClinic);
          } else {
            context.read<ClinicCubit>().updateClinic(newClinic);
          }
        },
      ),
    );
  }

  void _showLocationMapModal(ClinicEntity clinic) {
    showDialog(
      context: context,
      builder: (_) => ClinicLocationModal(clinic: clinic),
    );
  }

  void _confirmDeleteClinic(ClinicEntity clinic) async {
    final confirmed = await AppModalDialog.showConfirmation(
      context: context,
      title: 'Delete Clinic',
      message: 'Are you sure you want to delete ${clinic.name}?',
    );
    if (confirmed == true && mounted) {
      context.read<ClinicCubit>().deleteClinic(clinic.id);
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
                const BreadcrumbItem(label: 'Clinics'),
              ],
            ),
            const SizedBox(height: AppConstants.space4),
            ClinicHeader(
              onAddClinic: () => _showClinicFormModal(),
            ),
            const SizedBox(height: AppConstants.space6),
            BlocBuilder<ClinicCubit, ClinicState>(
              builder: (context, state) {
                final isLoading = state is ClinicLoading;
                final clinics = state is ClinicLoaded
                    ? state.clinics
                    : <ClinicEntity>[];

                return ClinicTableView(
                  isLoading: isLoading,
                  clinics: clinics,
                  onSearchChanged: (q) =>
                      context.read<ClinicCubit>().loadClinics(query: q),
                  onShowLocation: _showLocationMapModal,
                  onEdit: (c) => _showClinicFormModal(clinic: c),
                  onDelete: _confirmDeleteClinic,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
