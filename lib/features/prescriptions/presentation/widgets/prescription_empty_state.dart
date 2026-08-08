import 'package:flutter/material.dart';
import '../../../../shared/widgets/empty_widget.dart';

class PrescriptionEmptyState extends StatelessWidget {
  const PrescriptionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyWidget(
      title: 'No Prescriptions Found',
      message: 'There are no prescriptions matching your criteria.',
      icon: Icons.description_outlined,
    );
  }
}
