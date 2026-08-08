import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/app/theme/app_typography.dart';
import 'package:doctorhub_dashboard/core/constants/app_constants.dart';
import 'package:doctorhub_dashboard/features/reports/domain/entities/report_entity.dart';
import 'package:doctorhub_dashboard/shared/widgets/app_data_table.dart';
import 'package:flutter/material.dart';

Widget buildTopDoctorsTable(List<DoctorPerformanceItem> doctors, bool isDark) {
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
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.warning,
                    size: 16,
                  ),
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
          items: doctors,
        ),
      ],
    ),
  );
}
