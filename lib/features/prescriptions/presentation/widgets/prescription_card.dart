import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/prescription_entity.dart';
import 'prescription_status_chip.dart';

class PrescriptionCard extends StatelessWidget {
  final PrescriptionEntity prescription;
  final VoidCallback onDelete;
  final VoidCallback onExportPdf;

  const PrescriptionCard({
    super.key,
    required this.prescription,
    required this.onDelete,
    required this.onExportPdf,
  });

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Text(
                  prescription.id,
                  style: AppTypography.labelSm(color: AppColors.primary),
                ),
              ),
              PrescriptionStatusChip(status: prescription.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            prescription.patientName,
            style: AppTypography.headingMd(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Prescribed by ${prescription.doctorName}',
            style: AppTypography.bodySm(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            DateFormat('MMM dd, yyyy').format(prescription.date),
            style: AppTypography.bodySm(
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
          const Divider(height: 20),
          Text(
            '${prescription.medicines.length} Medicines Prescribed:',
            style: AppTypography.labelMd(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: prescription.medicines.length,
              itemBuilder: (context, idx) {
                final med = prescription.medicines[idx];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.medication_rounded,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${med.name} (${med.dosage}) - ${med.frequency}',
                          style: AppTypography.bodySm(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SecondaryButton(
                label: 'PDF Export',
                leadingIcon: Icons.picture_as_pdf_rounded,
                height: 36,
                onPressed: onExportPdf,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                ),
                onPressed: onDelete,
                tooltip: 'Delete Prescription',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
