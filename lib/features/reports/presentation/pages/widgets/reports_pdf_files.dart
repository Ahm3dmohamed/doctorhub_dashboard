import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/app/theme/app_typography.dart';
import 'package:doctorhub_dashboard/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ReportsPdfFiles extends StatelessWidget {
  const ReportsPdfFiles({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
                    ? const Color.fromARGB(255, 235, 235, 238)
                    : Colors.white,
              ),
            ),
          ],
        ),
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
