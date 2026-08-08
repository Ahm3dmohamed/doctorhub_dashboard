import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../domain/entities/doctor_entity.dart';

class DoctorDetailsModal extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorDetailsModal({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return AppModalDialog(
      title: doctor.name,
      subtitle: '${doctor.specialty} • ${doctor.clinicName}',
      cancelLabel: null,
      confirmLabel: l10n.commonClose,
      onConfirm: () => Navigator.of(context).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.commonDetails,
            style: AppTypography.headingSm(color: textColor),
          ),
          const SizedBox(height: 6),
          Text(
            '${l10n.commonEmail}: ${doctor.email}',
            style: AppTypography.bodyMd(color: textColor),
          ),
          Text(
            '${l10n.commonPhone}: ${doctor.phone}',
            style: AppTypography.bodyMd(color: textColor),
          ),
          Text(
            '${l10n.doctorsExperience}: ${doctor.yearsOfExperience}',
            style: AppTypography.bodyMd(color: textColor),
          ),
          Text(
            '${l10n.navPatients}: ${doctor.totalPatients}',
            style: AppTypography.bodyMd(color: textColor),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.doctorsAvailability,
            style: AppTypography.headingSm(color: textColor),
          ),
          const SizedBox(height: 6),
          ...doctor.workingHours.map(
            (w) => Text(
              '${w.day}: ${w.startTime} - ${w.endTime}',
              style: AppTypography.bodyMd(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
