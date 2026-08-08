import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_text_field.dart';

class PrescriptionSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const PrescriptionSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'Search Prescriptions',
      hint: 'Search prescription by patient, doctor, medicine or Rx ID...',
      prefixIcon: Icons.search_rounded,
      onChanged: onChanged,
    );
  }
}
