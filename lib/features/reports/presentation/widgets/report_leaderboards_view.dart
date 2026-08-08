import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_data_table.dart';
import '../../domain/entities/report_entity.dart';

/// Responsive side-by-side (or stacked) tables for top doctors and top clinics.
class ReportLeaderboardsView extends StatelessWidget {
  final List<DoctorPerformanceItem> topDoctors;
  final List<ClinicPerformanceItem> topClinics;

  const ReportLeaderboardsView({
    super.key,
    required this.topDoctors,
    required this.topClinics,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _TopDoctorsTable(doctors: topDoctors)),
              const SizedBox(width: AppConstants.space6),
              Expanded(child: _TopClinicsTable(clinics: topClinics)),
            ],
          );
        }
        return Column(
          children: [
            _TopDoctorsTable(doctors: topDoctors),
            const SizedBox(height: AppConstants.space6),
            _TopClinicsTable(clinics: topClinics),
          ],
        );
      },
    );
  }
}

class _TopDoctorsTable extends StatelessWidget {
  final List<DoctorPerformanceItem> doctors;
  const _TopDoctorsTable({required this.doctors});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          Text(
            'Top Performing Doctors',
            style: AppTypography.headingMd(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.space4),
          AppDataTable<DoctorPerformanceItem>(
            items: doctors,
            columns: [
              DataTableColumn<DoctorPerformanceItem>(
                title: 'Doctor',
                builder: (doc) => Text(
                  doc.name,
                  style: AppTypography.headingSm(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              DataTableColumn<DoctorPerformanceItem>(
                title: 'Specialty',
                builder: (doc) => Text(
                  doc.specialty,
                  style: AppTypography.bodySm(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              DataTableColumn<DoctorPerformanceItem>(
                title: 'Rating',
                builder: (doc) => Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.warning, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      doc.rating.toStringAsFixed(1),
                      style: AppTypography.labelMd(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              DataTableColumn<DoctorPerformanceItem>(
                title: 'Revenue',
                builder: (doc) => Text(
                  '\$${doc.totalRevenue.toStringAsFixed(0)}',
                  style: AppTypography.headingSm(color: AppColors.success),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopClinicsTable extends StatelessWidget {
  final List<ClinicPerformanceItem> clinics;
  const _TopClinicsTable({required this.clinics});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          Text(
            'Top Performing Clinics',
            style: AppTypography.headingMd(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.space4),
          AppDataTable<ClinicPerformanceItem>(
            items: clinics,
            columns: [
              DataTableColumn<ClinicPerformanceItem>(
                title: 'Clinic Name',
                builder: (clinic) => Text(
                  clinic.name,
                  style: AppTypography.headingSm(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              DataTableColumn<ClinicPerformanceItem>(
                title: 'Appointments',
                builder: (clinic) => Text(
                  '${clinic.appointmentsCount} visits',
                  style: AppTypography.bodySm(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              DataTableColumn<ClinicPerformanceItem>(
                title: 'Revenue',
                builder: (clinic) => Text(
                  '\$${clinic.revenue.toStringAsFixed(0)}',
                  style: AppTypography.headingSm(color: AppColors.primary),
                ),
              ),
              DataTableColumn<ClinicPerformanceItem>(
                title: 'Growth',
                builder: (clinic) => Text(
                  clinic.growthPercentage,
                  style: AppTypography.labelMd(color: AppColors.success),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
