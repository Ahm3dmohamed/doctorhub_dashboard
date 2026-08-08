import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../domain/entities/patient_entity.dart';

class PatientSummaryModal extends StatelessWidget {
  final PatientEntity patient;

  const PatientSummaryModal({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return AppModalDialog(
      title: l10n.patientsMedicalSummary(patient.name),
      subtitle: '${patient.age} • ${patient.gender} • ${patient.bloodGroup}',
      cancelLabel: null,
      confirmLabel: l10n.commonClose,
      onConfirm: () => Navigator.of(context).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.patientsMedicalHistory,
            style: AppTypography.headingSm(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            patient.medicalHistory,
            style: AppTypography.bodyMd(color: primaryTextColor),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.patientsKnownAllergies,
            style: AppTypography.headingSm(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            patient.allergies,
            style: AppTypography.bodyMd(color: primaryTextColor),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.patientsEmergencyContact,
            style: AppTypography.headingSm(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            '${patient.emergencyContact.name} (${patient.emergencyContact.relation})',
            style: AppTypography.bodyMd(color: primaryTextColor),
          ),
          Text(
            '${l10n.commonPhone}: ${patient.emergencyContact.phone}',
            style: AppTypography.bodyMd(color: primaryTextColor),
          ),
        ],
      ),
    );
  }
}
