import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_data_table.dart';
import '../../domain/entities/clinic_entity.dart';

class ClinicTableView extends StatelessWidget {
  final bool isLoading;
  final List<ClinicEntity> clinics;
  final ValueChanged<String> onSearchChanged;
  final Function(ClinicEntity) onShowLocation;
  final Function(ClinicEntity) onEdit;
  final Function(ClinicEntity) onDelete;

  const ClinicTableView({
    super.key,
    required this.isLoading,
    required this.clinics,
    required this.onSearchChanged,
    required this.onShowLocation,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return AppDataTable<ClinicEntity>(
      isLoading: isLoading,
      items: clinics,
      searchHint: l10n.clinicsSearchHint,
      onSearchChanged: onSearchChanged,
      columns: [
        DataTableColumn<ClinicEntity>(
          title: l10n.clinicsName,
          builder: (c) => Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    c.name,
                    style: AppTypography.bodyMd(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      weight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    c.email,
                    style: AppTypography.labelSm(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        DataTableColumn<ClinicEntity>(
          title: l10n.clinicsAddress,
          builder: (c) => Text(
            '${c.location.city}, ${c.location.governorate}',
            style: AppTypography.bodySm(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        DataTableColumn<ClinicEntity>(
          title: l10n.navDoctors,
          builder: (c) => Text(
            '${c.totalDoctors}',
            style: AppTypography.bodySm(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        DataTableColumn<ClinicEntity>(
          title: l10n.clinicsWorkingHours,
          builder: (c) => Text(
            c.workingHours,
            style: AppTypography.labelSm(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        DataTableColumn<ClinicEntity>(
          title: l10n.commonActions,
          builder: (c) => Row(
            children: [
              IconButton(
                icon: const Icon(Icons.map_outlined, size: 18),
                onPressed: () => onShowLocation(c),
                tooltip: l10n.clinicsViewLocation,
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: () => onEdit(c),
                tooltip: l10n.clinicsEdit,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: AppColors.error,
                ),
                onPressed: () => onDelete(c),
                tooltip: l10n.commonDelete,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
