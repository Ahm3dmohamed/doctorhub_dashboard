import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../domain/entities/doctor_entity.dart';
import '../cubit/doctor_cubit.dart';
import '../cubit/doctor_state.dart';
import '../widgets/doctor_details_modal.dart';
import '../widgets/doctor_form_dialog.dart';
import '../widgets/doctor_header.dart';
import '../widgets/doctor_table_view.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String _selectedSpecialty = 'All';

  static const _specialties = [
    'All',
    'Cardiology',
    'Neurology',
    'Pediatrics',
    'Orthopedics',
    'Dermatology',
  ];

  @override
  void initState() {
    super.initState();
    context.read<DoctorCubit>().loadDoctors();
  }

  void _showDoctorFormModal({DoctorEntity? doctor}) {
    showDialog(
      context: context,
      builder: (_) => DoctorFormDialog(
        doctor: doctor,
        onSave: (newDoctor) {
          if (doctor == null) {
            context.read<DoctorCubit>().addDoctor(newDoctor);
          } else {
            context.read<DoctorCubit>().updateDoctor(newDoctor);
          }
        },
      ),
    );
  }

  void _showDoctorDetailsModal(DoctorEntity doctor) {
    showDialog(
      context: context,
      builder: (_) => DoctorDetailsModal(doctor: doctor),
    );
  }

  void _confirmDeleteDoctor(DoctorEntity doc) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppModalDialog.showConfirmation(
      context: context,
      title: l10n.doctorsDeleteConfirmTitle,
      message: l10n.doctorsDeleteConfirmMessage(doc.name),
    );
    if (confirmed == true && mounted) {
      context.read<DoctorCubit>().deleteDoctor(doc.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
                  label: l10n.navDashboard,
                  onTap: () => context.go(AppRoutes.dashboard),
                ),
                BreadcrumbItem(label: l10n.navDoctors),
              ],
            ),
            const SizedBox(height: AppConstants.space4),
            DoctorHeader(
              onAddDoctor: () => _showDoctorFormModal(),
            ),
            const SizedBox(height: AppConstants.space6),
            BlocBuilder<DoctorCubit, DoctorState>(
              builder: (context, state) {
                final isLoading = state is DoctorLoading;
                final doctors = state is DoctorLoaded
                    ? state.doctors
                    : <DoctorEntity>[];

                return DoctorTableView(
                  isLoading: isLoading,
                  doctors: doctors,
                  selectedSpecialty: _selectedSpecialty,
                  specialties: _specialties,
                  onSearchChanged: (q) {
                    context.read<DoctorCubit>().loadDoctors(
                          query: q,
                          specialty: _selectedSpecialty,
                        );
                  },
                  onSpecialtyChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedSpecialty = val);
                      context.read<DoctorCubit>().loadDoctors(specialty: val);
                    }
                  },
                  onViewDetails: _showDoctorDetailsModal,
                  onEdit: (doc) => _showDoctorFormModal(doctor: doc),
                  onDelete: _confirmDeleteDoctor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
