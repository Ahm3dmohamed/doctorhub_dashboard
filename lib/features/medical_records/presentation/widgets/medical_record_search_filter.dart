import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: searchController,
            hint: l10n.medSearchHint,
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
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RecordType?>(
              value: selectedType,
              hint: Text(
                l10n.commonFilter,
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
                    l10n.commonFilter,
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
