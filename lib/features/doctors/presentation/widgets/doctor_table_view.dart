import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_data_table.dart';
import '../../domain/entities/doctor_entity.dart';

class DoctorTableView extends StatelessWidget {
  final bool isLoading;
  final List<DoctorEntity> doctors;
  final String selectedSpecialty;
  final List<String> specialties;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onSpecialtyChanged;
  final Function(DoctorEntity) onViewDetails;
  final Function(DoctorEntity) onEdit;
  final Function(DoctorEntity) onDelete;

  const DoctorTableView({
    super.key,
    required this.isLoading,
    required this.doctors,
    required this.selectedSpecialty,
    required this.specialties,
    required this.onSearchChanged,
    required this.onSpecialtyChanged,
    required this.onViewDetails,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppDataTable<DoctorEntity>(
      isLoading: isLoading,
      items: doctors,
      searchHint: 'Search doctors by name, specialty...',
      onSearchChanged: onSearchChanged,
      filterWidget: DropdownButton<String>(
        value: selectedSpecialty,
        dropdownColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        underline: const SizedBox.shrink(),
        items: specialties
            .map(
              (s) => DropdownMenuItem(
                value: s,
                child: Text(
                  s,
                  style: AppTypography.bodySm(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onSpecialtyChanged,
      ),
      columns: [
        DataTableColumn<DoctorEntity>(
          title: 'Doctor',
          builder: (doc) => Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withValues(
                  alpha: 0.15,
                ),
                child: Text(
                  doc.initials,
                  style: AppTypography.labelSm(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    doc.name,
                    style: AppTypography.bodyMd(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      weight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    doc.email,
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
        DataTableColumn<DoctorEntity>(
          title: 'Specialty',
          builder: (doc) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                AppConstants.radiusFull,
              ),
            ),
            child: Text(
              doc.specialty,
              style: AppTypography.labelSm(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        DataTableColumn<DoctorEntity>(
          title: 'Clinic',
          builder: (doc) => Text(
            doc.clinicName,
            style: AppTypography.bodySm(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        DataTableColumn<DoctorEntity>(
          title: 'Rating',
          builder: (doc) => Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 16,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              Text(
                doc.rating.toString(),
                style: AppTypography.bodySm(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        DataTableColumn<DoctorEntity>(
          title: 'Status',
          builder: (doc) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: doc.isAvailable
                  ? AppColors.successLight
                  : AppColors.errorLight,
              borderRadius: BorderRadius.circular(
                AppConstants.radiusFull,
              ),
            ),
            child: Text(
              doc.isAvailable ? 'Available' : 'Unavailable',
              style: AppTypography.labelSm(
                color: doc.isAvailable
                    ? AppColors.successDark
                    : AppColors.errorDark,
              ),
            ),
          ),
        ),
        DataTableColumn<DoctorEntity>(
          title: 'Actions',
          builder: (doc) => Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.visibility_outlined,
                  size: 18,
                ),
                onPressed: () => onViewDetails(doc),
                tooltip: 'View Details',
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: () => onEdit(doc),
                tooltip: 'Edit Doctor',
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: AppColors.error,
                ),
                onPressed: () => onDelete(doc),
                tooltip: 'Delete Doctor',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
