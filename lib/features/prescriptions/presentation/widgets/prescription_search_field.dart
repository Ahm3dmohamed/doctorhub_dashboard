import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return AppTextField(
      controller: controller,
      label: l10n.rxTitle,
      hint: l10n.rxSearchHint,
      prefixIcon: Icons.search_rounded,
      onChanged: onChanged,
    );
  }
}
