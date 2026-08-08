import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/medical_record_entity.dart';

class MedicalRecordDetailCard extends StatelessWidget {
  final MedicalRecordEntity record;

  const MedicalRecordDetailCard({
    super.key,
    required this.record,
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

    return Container(
      padding: const EdgeInsets.all(AppConstants.space6),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.patientName,
                    style: AppTypography.headingLg(color: primaryTextColor),
                  ),
                  Text(
                    'Record ID: ${record.id} • ${record.clinicName}',
                    style: AppTypography.bodySm(color: secondaryTextColor),
                  ),
                ],
              ),
              Chip(
                label: Text(
                  record.type.displayName,
                  style: AppTypography.labelSm(color: Colors.white),
                ),
                backgroundColor: AppColors.primary,
              ),
            ],
          ),
          const Divider(height: 32),

          // Doctor & Date
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Doctor: ${record.doctorName}',
                style: AppTypography.bodyMd(color: primaryTextColor),
              ),
              const Spacer(),
              const Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: AppColors.neutral400,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMMM dd, yyyy').format(record.date),
                style: AppTypography.bodySm(color: secondaryTextColor),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space4),

          // Diagnoses
          if (record.diagnoses.isNotEmpty) ...[
            Text(
              'Diagnoses:',
              style: AppTypography.labelMd(color: primaryTextColor),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              children: record.diagnoses
                  .map(
                    (d) => Chip(
                      label: Text(
                        d,
                        style: AppTypography.labelSm(color: AppColors.errorDark),
                      ),
                      backgroundColor: AppColors.errorLight,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppConstants.space4),
          ],

          // Symptoms
          if (record.symptoms.isNotEmpty) ...[
            Text(
              'Symptoms:',
              style: AppTypography.labelMd(color: primaryTextColor),
            ),
            const SizedBox(height: 4),
            Text(
              record.symptoms.join(', '),
              style: AppTypography.bodyMd(color: secondaryTextColor),
            ),
            const SizedBox(height: AppConstants.space4),
          ],

          // Lab Results
          if (record.labResults.isNotEmpty) ...[
            Text(
              'Lab Results:',
              style: AppTypography.labelMd(color: primaryTextColor),
            ),
            const SizedBox(height: 8),
            ...record.labResults.map(
              (lab) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: lab.isAbnormal
                      ? AppColors.error.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: lab.isAbnormal
                        ? AppColors.error.withValues(alpha: 0.3)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lab.testName,
                      style: AppTypography.bodyMd(color: primaryTextColor),
                    ),
                    Text(
                      '${lab.value} ${lab.unit} (Ref: ${lab.referenceRange})',
                      style: AppTypography.bodySm(
                        color: lab.isAbnormal
                            ? AppColors.error
                            : secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.space4),
          ],

          // Doctor Notes
          if (record.doctorNotes.isNotEmpty) ...[
            Text(
              'Doctor Notes:',
              style: AppTypography.labelMd(color: primaryTextColor),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral900 : AppColors.neutral100,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Text(
                record.doctorNotes,
                style: AppTypography.bodyMd(color: primaryTextColor),
              ),
            ),
            const SizedBox(height: AppConstants.space4),
          ],

          // Attachments
          if (record.attachments.isNotEmpty) ...[
            Text(
              'Attachments:',
              style: AppTypography.labelMd(color: primaryTextColor),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: record.attachments
                  .map(
                    (att) => ActionChip(
                      avatar: const Icon(Icons.attach_file_rounded, size: 16),
                      label: Text('${att.name} (${att.size})'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading ${att.name}...')),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
