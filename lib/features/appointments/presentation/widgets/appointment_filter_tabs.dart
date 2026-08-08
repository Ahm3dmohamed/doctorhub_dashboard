import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentFilterTabs extends StatelessWidget {
  final AppointmentStatus? selectedStatus;
  final ValueChanged<AppointmentStatus?> onStatusSelected;

  const AppointmentFilterTabs({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterTabPill(
            label: 'All',
            isSelected: selectedStatus == null,
            onTap: () => onStatusSelected(null),
          ),
          ...AppointmentStatus.values.map(
            (s) => _FilterTabPill(
              label: s.displayName,
              isSelected: selectedStatus == s,
              onTap: () => onStatusSelected(s),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTabPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTabPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMd(
            color: isSelected
                ? Colors.white
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }
}
