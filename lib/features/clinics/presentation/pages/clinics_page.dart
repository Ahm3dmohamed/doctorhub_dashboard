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
import '../../domain/entities/clinic_entity.dart';
import '../cubit/clinic_cubit.dart';
import '../cubit/clinic_state.dart';

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
                const BreadcrumbItem(label: 'Clinics'),
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
                      'Clinics Directory',
                      style: AppTypography.headingXl(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage clinic branches, locations, and accepted insurance plans',
                      style: AppTypography.bodyMd(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                PrimaryButton(
                  label: 'Add Clinic',
                  leadingIcon: Icons.add_business_rounded,
                  onPressed: () => _showClinicFormModal(context),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.space6),

            BlocBuilder<ClinicCubit, ClinicState>(
              builder: (context, state) {
                final isLoading = state is ClinicLoading;
                final clinics = state is ClinicLoaded ? state.clinics : <ClinicEntity>[];

                return AppDataTable<ClinicEntity>(
                  isLoading: isLoading,
                  items: clinics,
                  searchHint: 'Search clinics by name, city...',
                  onSearchChanged: (q) => context.read<ClinicCubit>().loadClinics(query: q),
                  columns: [
                    DataTableColumn<ClinicEntity>(
                      title: 'Clinic Name',
                      builder: (c) => Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                            ),
                            child: const Icon(Icons.local_hospital_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                c.name,
                                style: AppTypography.bodyMd(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                c.email,
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
                    DataTableColumn<ClinicEntity>(
                      title: 'Location',
                      builder: (c) => Text(
                        '${c.location.city}, ${c.location.governorate}',
                        style: AppTypography.bodySm(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    DataTableColumn<ClinicEntity>(
                      title: 'Doctors',
                      builder: (c) => Text(
                        '${c.totalDoctors} Doctors',
                        style: AppTypography.bodySm(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    DataTableColumn<ClinicEntity>(
                      title: 'Working Hours',
                      builder: (c) => Text(
                        c.workingHours,
                        style: AppTypography.labelSm(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    DataTableColumn<ClinicEntity>(
                      title: 'Actions',
                      builder: (c) => Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.map_outlined, size: 18),
                            onPressed: () => _showLocationMapModal(context, c),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () => _showClinicFormModal(context, clinic: c),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                            onPressed: () async {
                              final confirmed = await AppModalDialog.showConfirmation(
                                context: context,
                                title: 'Delete Clinic',
                                message: 'Are you sure you want to delete ${c.name}?',
                              );
                              if (confirmed == true && context.mounted) {
                                context.read<ClinicCubit>().deleteClinic(c.id);
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

  void _showClinicFormModal(BuildContext context, {ClinicEntity? clinic}) {
    final nameCtrl = TextEditingController(text: clinic?.name);
    final emailCtrl = TextEditingController(text: clinic?.email);
    final phoneCtrl = TextEditingController(text: clinic?.phone);
    final addressCtrl = TextEditingController(text: clinic?.location.address);
    final cityCtrl = TextEditingController(text: clinic?.location.city ?? 'New York');
    final govCtrl = TextEditingController(text: clinic?.location.governorate ?? 'NY');

    showDialog(
      context: context,
      builder: (ctx) => AppModalDialog(
        title: clinic == null ? 'Add New Clinic' : 'Edit Clinic',
        subtitle: 'Fill in clinic address and location coordinates.',
        onConfirm: () {
          final newClinic = ClinicEntity(
            id: clinic?.id ?? '',
            name: nameCtrl.text.isEmpty ? 'New Health Clinic' : nameCtrl.text,
            email: emailCtrl.text.isEmpty ? 'clinic@doctorhub.com' : emailCtrl.text,
            phone: phoneCtrl.text.isEmpty ? '+1 (555) 000-0000' : phoneCtrl.text,
            location: LocationEntity(
              address: addressCtrl.text.isEmpty ? '123 Main St' : addressCtrl.text,
              city: cityCtrl.text,
              governorate: govCtrl.text,
              latitude: clinic?.location.latitude ?? 40.7128,
              longitude: clinic?.location.longitude ?? -74.0060,
            ),
            galleryUrls: clinic?.galleryUrls ?? const [],
            acceptedInsurance: clinic?.acceptedInsurance ?? const ['BlueCross', 'Aetna'],
            workingHours: clinic?.workingHours ?? 'Mon - Fri: 08:00 AM - 06:00 PM',
            totalDoctors: clinic?.totalDoctors ?? 5,
            rating: clinic?.rating ?? 4.8,
          );

          if (clinic == null) {
            context.read<ClinicCubit>().addClinic(newClinic);
          } else {
            context.read<ClinicCubit>().updateClinic(newClinic);
          }
          Navigator.of(ctx).pop();
        },
        content: Column(
          children: [
            AppTextField(controller: nameCtrl, label: 'Clinic Name', hint: 'Central Clinic'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: emailCtrl, label: 'Email', hint: 'contact@clinic.com'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: phoneCtrl, label: 'Phone', hint: '+1 (555) 000-0000'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: addressCtrl, label: 'Street Address', hint: '100 Medical Blvd'),
            const SizedBox(height: AppConstants.space3),
            Row(
              children: [
                Expanded(child: AppTextField(controller: cityCtrl, label: 'City', hint: 'New York')),
                const SizedBox(width: AppConstants.space3),
                Expanded(child: AppTextField(controller: govCtrl, label: 'State / Gov', hint: 'NY')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationMapModal(BuildContext context, ClinicEntity clinic) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AppModalDialog(
        title: 'Location — ${clinic.name}',
        subtitle: '${clinic.location.address}, ${clinic.location.city}',
        confirmLabel: 'Close',
        onConfirm: () => Navigator.of(ctx).pop(),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_rounded, size: 40, color: AppColors.primary),
                    const SizedBox(height: 8),
                    Text(
                      'Google Maps View',
                      style: AppTypography.headingSm(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      'Lat: ${clinic.location.latitude}, Long: ${clinic.location.longitude}',
                      style: AppTypography.labelSm(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Accepted Insurance Plans:', style: AppTypography.headingSm()),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: clinic.acceptedInsurance
                  .map((ins) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                        ),
                        child: Text(ins, style: AppTypography.labelSm(color: AppColors.successDark)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
