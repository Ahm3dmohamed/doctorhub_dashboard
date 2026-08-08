import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_data_table.dart';
import '../../domain/entities/patient_entity.dart';

class PatientTableView extends StatelessWidget {
  final bool isLoading;
  final List<PatientEntity> patients;
  final ValueChanged<String> onSearchChanged;
  final Function(PatientEntity) onViewSummary;
  final Function(PatientEntity) onEdit;
  final Function(PatientEntity) onDelete;

  const PatientTableView({
    super.key,
    required this.isLoading,
    required this.patients,
    required this.onSearchChanged,
    required this.onViewSummary,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppDataTable<PatientEntity>(
      isLoading: isLoading,
      items: patients,
      searchHint: 'Search patients by name, email, phone...',
      onSearchChanged: onSearchChanged,
      columns: [
        DataTableColumn<PatientEntity>(
          title: 'Patient',
          builder: (p) => Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.info.withValues(
                  alpha: 0.15,
                ),
                child: Text(
                  p.initials,
                  style: AppTypography.labelSm(
                    color: AppColors.info,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    p.name,
                    style: AppTypography.bodyMd(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      weight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    p.email,
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
        DataTableColumn<PatientEntity>(
          title: 'Age / Gender',
          builder: (p) => Text(
            '${p.age} yrs • ${p.gender}',
            style: AppTypography.bodySm(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        DataTableColumn<PatientEntity>(
          title: 'Blood Group',
          builder: (p) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                AppConstants.radiusFull,
              ),
            ),
            child: Text(
              p.bloodGroup,
              style: AppTypography.labelSm(color: AppColors.error),
            ),
          ),
        ),
        DataTableColumn<PatientEntity>(
          title: 'Emergency Contact',
          builder: (p) => Text(
            '${p.emergencyContact.name} (${p.emergencyContact.relation})',
            style: AppTypography.labelSm(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        DataTableColumn<PatientEntity>(
          title: 'Actions',
          builder: (p) => Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.medical_information_outlined,
                  size: 18,
                ),
                onPressed: () => onViewSummary(p),
                tooltip: 'Medical Summary',
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: () => onEdit(p),
                tooltip: 'Edit Patient',
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: AppColors.error,
                ),
                onPressed: () => onDelete(p),
                tooltip: 'Delete Patient',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
