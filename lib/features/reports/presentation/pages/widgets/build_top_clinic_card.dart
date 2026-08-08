import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/app/theme/app_typography.dart';
import 'package:doctorhub_dashboard/core/constants/app_constants.dart';
import 'package:doctorhub_dashboard/features/reports/domain/entities/report_entity.dart';
import 'package:doctorhub_dashboard/shared/widgets/app_data_table.dart';
import 'package:flutter/material.dart';

Widget buildTopClinicsTable(List<ClinicPerformanceItem> clinics, bool isDark) {
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
          items: clinics,
        ),
      ],
    ),
  );
}
