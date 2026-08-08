import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/primary_button.dart';

/// Header for Reports page with title, subtitle, and export actions.
class ReportHeader extends StatelessWidget {
  const ReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reports & Executive Analytics',
                style: AppTypography.headingXl(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track platform revenue, doctor/clinic performance KPIs and patient growth metrics',
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
        Row(
          children: [
            SecondaryButton(
              label: 'Export Excel',
              leadingIcon: Icons.table_view_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Exporting report as Excel spreadsheet...'),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            PrimaryButton(
              label: 'Export PDF Report',
              leadingIcon: Icons.picture_as_pdf_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Generating executive PDF report...'),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
