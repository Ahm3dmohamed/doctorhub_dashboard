import 'package:flutter/material.dart';
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
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return AppModalDialog(
      title: doctor.name,
      subtitle: '${doctor.specialty} • ${doctor.clinicName}',
      cancelLabel: null,
      confirmLabel: 'Close',
      onConfirm: () => Navigator.of(context).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Info',
            style: AppTypography.headingSm(color: textColor),
          ),
          const SizedBox(height: 6),
          Text(
            'Email: ${doctor.email}',
            style: AppTypography.bodyMd(color: textColor),
          ),
          Text(
            'Phone: ${doctor.phone}',
            style: AppTypography.bodyMd(color: textColor),
          ),
          Text(
            'Experience: ${doctor.yearsOfExperience} years',
            style: AppTypography.bodyMd(color: textColor),
          ),
          Text(
            'Patients Treated: ${doctor.totalPatients}',
            style: AppTypography.bodyMd(color: textColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Working Hours',
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
