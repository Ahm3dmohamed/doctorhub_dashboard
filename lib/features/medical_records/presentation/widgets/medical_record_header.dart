import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/primary_button.dart';

class MedicalRecordHeader extends StatelessWidget {
  final bool isTimelineView;
  final VoidCallback onToggleView;

  const MedicalRecordHeader({
    super.key,
    required this.isTimelineView,
    required this.onToggleView,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Medical Records & EHR',
                style: AppTypography.headingXl(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Electronic Health Records, Diagnoses, Lab Results, Radiology & Doctor Notes',
                style: AppTypography.bodyMd(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SecondaryButton(
          label: isTimelineView ? 'Table View' : 'Timeline View',
          leadingIcon: isTimelineView
              ? Icons.table_chart_rounded
              : Icons.timeline_rounded,
          onPressed: onToggleView,
        ),
      ],
    );
  }
}
