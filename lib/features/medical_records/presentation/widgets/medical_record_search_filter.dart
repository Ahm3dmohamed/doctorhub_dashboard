import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/medical_record_entity.dart';

class MedicalRecordSearchFilter extends StatelessWidget {
  final TextEditingController searchController;
  final RecordType? selectedType;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<RecordType?> onTypeChanged;

  const MedicalRecordSearchFilter({
    super.key,
    required this.searchController,
    required this.selectedType,
    required this.onSearchChanged,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: searchController,
            hint: 'Search by patient, doctor, diagnosis or ID...',
            prefixIcon: Icons.search_rounded,
            onChanged: onSearchChanged,
            label: '',
          ),
        ),
        const SizedBox(width: AppConstants.space3),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space3,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorder
                  : AppColors.lightBorder,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RecordType?>(
              value: selectedType,
              hint: Text(
                'All Record Types',
                style: AppTypography.bodySm(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              dropdownColor: isDark
                  ? AppColors.darkSurface
                  : AppColors.lightSurface,
              items: [
                DropdownMenuItem<RecordType?>(
                  value: null,
                  child: Text(
                    'All Record Types',
                    style: AppTypography.bodySm(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
                ...RecordType.values.map(
                  (t) => DropdownMenuItem<RecordType?>(
                    value: t,
                    child: Text(
                      t.displayName,
                      style: AppTypography.bodySm(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ),
              ],
              onChanged: onTypeChanged,
            ),
          ),
        ),
      ],
    );
  }
}
