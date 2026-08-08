import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../domain/entities/patient_entity.dart';

class PatientSummaryModal extends StatelessWidget {
  final PatientEntity patient;

  const PatientSummaryModal({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return AppModalDialog(
      title: 'Medical Summary — ${patient.name}',
      subtitle: '${patient.age} yrs • ${patient.gender} • Blood Type ${patient.bloodGroup}',
      cancelLabel: null,
      confirmLabel: 'Close',
      onConfirm: () => Navigator.of(context).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical History',
            style: AppTypography.headingSm(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            patient.medicalHistory,
            style: AppTypography.bodyMd(color: primaryTextColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Known Allergies',
            style: AppTypography.headingSm(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            patient.allergies,
            style: AppTypography.bodyMd(color: primaryTextColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Emergency Contact',
            style: AppTypography.headingSm(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            '${patient.emergencyContact.name} (${patient.emergencyContact.relation})',
            style: AppTypography.bodyMd(color: primaryTextColor),
          ),
          Text(
            'Phone: ${patient.emergencyContact.phone}',
            style: AppTypography.bodyMd(color: primaryTextColor),
          ),
        ],
      ),
    );
  }
}
