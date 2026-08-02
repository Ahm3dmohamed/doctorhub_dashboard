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
import '../../domain/entities/doctor_entity.dart';
import '../cubit/doctor_cubit.dart';
import '../cubit/doctor_state.dart';

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
            // Breadcrumb
            AppBreadcrumb(
              items: [
                BreadcrumbItem(
                  label: 'Dashboard',
                  onTap: () => context.go(AppRoutes.dashboard),
                ),
                const BreadcrumbItem(label: 'Doctors'),
              ],
            ),

            const SizedBox(height: AppConstants.space4),

            // Header Title + Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doctors Management',
                      style: AppTypography.headingXl(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage doctor profiles, specialties, and working hours',
                      style: AppTypography.bodyMd(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                PrimaryButton(
                  label: 'Add Doctor',
                  leadingIcon: Icons.add_rounded,
                  onPressed: () => _showDoctorFormModal(context),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.space6),

            // Main Content Area with DataTable
            BlocBuilder<DoctorCubit, DoctorState>(
              builder: (context, state) {
                final isLoading = state is DoctorLoading;
                final doctors = state is DoctorLoaded ? state.doctors : <DoctorEntity>[];

                return AppDataTable<DoctorEntity>(
                  isLoading: isLoading,
                  items: doctors,
                  searchHint: 'Search doctors by name, specialty...',
                  onSearchChanged: (q) =>
                      context.read<DoctorCubit>().loadDoctors(query: q, specialty: _selectedSpecialty),
                  filterWidget: DropdownButton<String>(
                    value: _selectedSpecialty,
                    dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    underline: const SizedBox.shrink(),
                    items: _specialties
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(
                                s,
                                style: AppTypography.bodySm(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedSpecialty = val);
                        context.read<DoctorCubit>().loadDoctors(specialty: val);
                      }
                    },
                  ),
                  columns: [
                    DataTableColumn<DoctorEntity>(
                      title: 'Doctor',
                      builder: (doc) => Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                            child: Text(
                              doc.initials,
                              style: AppTypography.labelSm(color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                doc.name,
                                style: AppTypography.bodyMd(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                doc.email,
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
                    DataTableColumn<DoctorEntity>(
                      title: 'Specialty',
                      builder: (doc) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                        ),
                        child: Text(
                          doc.specialty,
                          style: AppTypography.labelSm(color: AppColors.primary),
                        ),
                      ),
                    ),
                    DataTableColumn<DoctorEntity>(
                      title: 'Clinic',
                      builder: (doc) => Text(
                        doc.clinicName,
                        style: AppTypography.bodySm(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    DataTableColumn<DoctorEntity>(
                      title: 'Rating',
                      builder: (doc) => Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            doc.rating.toString(),
                            style: AppTypography.bodySm(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataTableColumn<DoctorEntity>(
                      title: 'Status',
                      builder: (doc) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: doc.isAvailable ? AppColors.successLight : AppColors.errorLight,
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                        ),
                        child: Text(
                          doc.isAvailable ? 'Available' : 'Unavailable',
                          style: AppTypography.labelSm(
                            color: doc.isAvailable ? AppColors.successDark : AppColors.errorDark,
                          ),
                        ),
                      ),
                    ),
                    DataTableColumn<DoctorEntity>(
                      title: 'Actions',
                      builder: (doc) => Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined, size: 18),
                            onPressed: () => _showDoctorDetailsModal(context, doc),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () => _showDoctorFormModal(context, doctor: doc),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                            onPressed: () async {
                              final confirmed = await AppModalDialog.showConfirmation(
                                context: context,
                                title: 'Delete Doctor',
                                message: 'Are you sure you want to remove ${doc.name}?',
                              );
                              if (confirmed == true && context.mounted) {
                                context.read<DoctorCubit>().deleteDoctor(doc.id);
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

  void _showDoctorFormModal(BuildContext context, {DoctorEntity? doctor}) {
    final nameCtrl = TextEditingController(text: doctor?.name);
    final emailCtrl = TextEditingController(text: doctor?.email);
    final phoneCtrl = TextEditingController(text: doctor?.phone);
    final specialtyCtrl = TextEditingController(text: doctor?.specialty ?? 'Cardiology');
    final clinicCtrl = TextEditingController(text: doctor?.clinicName ?? 'Central Heart Institute');
    final bioCtrl = TextEditingController(text: doctor?.bio);

    showDialog(
      context: context,
      builder: (ctx) => AppModalDialog(
        title: doctor == null ? 'Add New Doctor' : 'Edit Doctor',
        subtitle: 'Enter doctor details and specialty information.',
        onConfirm: () {
          final newDoctor = DoctorEntity(
            id: doctor?.id ?? '',
            name: nameCtrl.text.isEmpty ? 'Dr. New Doctor' : nameCtrl.text,
            email: emailCtrl.text.isEmpty ? 'doctor@doctorhub.com' : emailCtrl.text,
            phone: phoneCtrl.text.isEmpty ? '+1 (555) 000-0000' : phoneCtrl.text,
            specialty: specialtyCtrl.text,
            clinicName: clinicCtrl.text,
            rating: doctor?.rating ?? 5.0,
            totalPatients: doctor?.totalPatients ?? 0,
            yearsOfExperience: doctor?.yearsOfExperience ?? 5,
            bio: bioCtrl.text.isEmpty ? 'General practitioner.' : bioCtrl.text,
            workingHours: doctor?.workingHours ?? const [],
          );

          if (doctor == null) {
            context.read<DoctorCubit>().addDoctor(newDoctor);
          } else {
            context.read<DoctorCubit>().updateDoctor(newDoctor);
          }
          Navigator.of(ctx).pop();
        },
        content: Column(
          children: [
            AppTextField(controller: nameCtrl, label: 'Full Name', hint: 'Dr. John Doe'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: emailCtrl, label: 'Email Address', hint: 'doctor@example.com'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: phoneCtrl, label: 'Phone Number', hint: '+1 (555) 000-0000'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: specialtyCtrl, label: 'Specialty', hint: 'Cardiology'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: clinicCtrl, label: 'Clinic Name', hint: 'Central Hospital'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: bioCtrl, label: 'Bio / Profile Summary', hint: 'Specialist in...', maxLines: 3),
          ],
        ),
      ),
    );
  }

  void _showDoctorDetailsModal(BuildContext context, DoctorEntity doc) {
    showDialog(
      context: context,
      builder: (ctx) => AppModalDialog(
        title: doc.name,
        subtitle: '${doc.specialty} • ${doc.clinicName}',
        cancelLabel: null,
        confirmLabel: 'Close',
        onConfirm: () => Navigator.of(ctx).pop(),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact Info', style: AppTypography.headingSm()),
            const SizedBox(height: 6),
            Text('Email: ${doc.email}'),
            Text('Phone: ${doc.phone}'),
            Text('Experience: ${doc.yearsOfExperience} years'),
            Text('Patients Treated: ${doc.totalPatients}'),
            const SizedBox(height: 16),
            Text('Working Hours', style: AppTypography.headingSm()),
            const SizedBox(height: 6),
            ...doc.workingHours.map((w) => Text('${w.day}: ${w.startTime} - ${w.endTime}')),
          ],
        ),
      ),
    );
  }
}
