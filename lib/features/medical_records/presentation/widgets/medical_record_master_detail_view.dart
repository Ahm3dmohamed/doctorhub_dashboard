import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/medical_record_entity.dart';
import '../cubit/medical_record_state.dart';
import 'medical_record_detail_card.dart';

class MedicalRecordMasterDetailView extends StatelessWidget {
  final MedicalRecordLoaded state;
  final Function(MedicalRecordEntity) onSelectRecord;
  final Function(MedicalRecordEntity) onShowMobileDetail;

  const MedicalRecordMasterDetailView({
    super.key,
    required this.state,
    required this.onSelectRecord,
    required this.onShowMobileDetail,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final selected = state.selectedRecord ?? state.records.first;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > AppConstants.tabletBreakpoint;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left list
              Expanded(
                flex: 4,
                child: Column(
                  children: state.records.map((rec) {
                    final isSel = selected.id == rec.id;
                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: AppConstants.space3,
                      ),
                      decoration: BoxDecoration(
                        color: isSel
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : (isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusLg,
                        ),
                        border: Border.all(
                          color: isSel
                              ? AppColors.primary
                              : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                          width: isSel ? 1.5 : 1,
                        ),
                      ),
                      child: ListTile(
                        onTap: () => onSelectRecord(rec),
                        title: Text(
                          rec.patientName,
                          style: AppTypography.headingSm(color: primaryTextColor),
                        ),
                        subtitle: Text(
                          '${rec.type.displayName} • ${DateFormat('MMM dd, yyyy').format(rec.date)}',
                          style: AppTypography.bodySm(color: secondaryTextColor),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: AppConstants.space6),
              // Right detail card
              Expanded(
                flex: 6,
                child: MedicalRecordDetailCard(record: selected),
              ),
            ],
          );
        }

        // Mobile list view with bottom sheet / modal on tap
        return Column(
          children: state.records.map((rec) {
            return Card(
              margin: const EdgeInsets.only(bottom: AppConstants.space3),
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              child: ListTile(
                title: Text(
                  rec.patientName,
                  style: AppTypography.headingSm(color: primaryTextColor),
                ),
                subtitle: Text(
                  '${rec.type.displayName} • ${DateFormat('MMM dd').format(rec.date)}',
                  style: AppTypography.bodySm(color: secondaryTextColor),
                ),
                onTap: () => onShowMobileDetail(rec),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
