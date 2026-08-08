import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_text_field.dart';

class MedicineFormData {
  final TextEditingController name = TextEditingController();
  final TextEditingController dosage = TextEditingController();
  final TextEditingController frequency = TextEditingController();
  final TextEditingController duration = TextEditingController();
  final TextEditingController instructions = TextEditingController();

  void dispose() {
    name.dispose();
    dosage.dispose();
    frequency.dispose();
    duration.dispose();
    instructions.dispose();
  }
}

class MedicineFormItem extends StatelessWidget {
  final int index;
  final MedicineFormData data;
  final bool showRemove;
  final VoidCallback onRemove;

  const MedicineFormItem({
    super.key,
    required this.index,
    required this.data,
    required this.showRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral900 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${l10n.rxMedicineName} #${index + 1}',
                style: AppTypography.labelMd(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const Spacer(),
              if (showRemove)
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.error,
                  ),
                  onPressed: onRemove,
                ),
            ],
          ),
          AppTextField(
            controller: data.name,
            label: l10n.rxMedicineName,
            hint: 'e.g. Amoxicillin',
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: data.dosage,
                  label: l10n.rxDosage,
                  hint: '500mg',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppTextField(
                  controller: data.frequency,
                  label: l10n.rxFrequency,
                  hint: '3x Daily',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: data.duration,
                  label: l10n.rxDuration,
                  hint: '7 Days',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppTextField(
                  controller: data.instructions,
                  label: l10n.rxInstructions,
                  hint: 'After meals',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
