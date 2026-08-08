import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/medical_record_entity.dart';

class MedicalRecordTimelineView extends StatelessWidget {
  final List<MedicalRecordEntity> records;

  const MedicalRecordTimelineView({
    super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Column(
      children: records.map((rec) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppConstants.space4),
          padding: const EdgeInsets.all(AppConstants.space4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_information_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppConstants.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          rec.patientName,
                          style: AppTypography.headingSm(color: primaryTextColor),
                        ),
                        Text(
                          DateFormat('MMM dd, yyyy').format(rec.date),
                          style: AppTypography.bodySm(color: secondaryTextColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${rec.type.displayName} • ${rec.doctorName}',
                      style: AppTypography.labelMd(color: secondaryTextColor),
                    ),
                    const SizedBox(height: 8),
                    if (rec.diagnoses.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        children: rec.diagnoses
                            .map(
                              (d) => Chip(
                                label: Text(
                                  d,
                                  style: AppTypography.labelSm(
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                                backgroundColor: AppColors.primaryContainer,
                              ),
                            )
                            .toList(),
                      ),
                    if (rec.doctorNotes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        rec.doctorNotes,
                        style: AppTypography.bodyMd(color: primaryTextColor),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
