import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_responsive_grid.dart';
import '../../domain/entities/prescription_entity.dart';
import 'prescription_card.dart';

class PrescriptionGrid extends StatelessWidget {
  final List<PrescriptionEntity> prescriptions;
  final Function(PrescriptionEntity) onDelete;
  final Function(PrescriptionEntity) onExportPdf;

  const PrescriptionGrid({
    super.key,
    required this.prescriptions,
    required this.onDelete,
    required this.onExportPdf,
  });

  @override
  Widget build(BuildContext context) {
    return AppResponsiveGrid(
      itemCount: prescriptions.length,
      childAspectRatio: 1.1,
      mainAxisSpacing: AppConstants.space4,
      crossAxisSpacing: AppConstants.space4,
      itemBuilder: (context, index) {
        final rx = prescriptions[index];
        return PrescriptionCard(
          prescription: rx,
          onDelete: () => onDelete(rx),
          onExportPdf: () => onExportPdf(rx),
        );
      },
    );
  }
}
