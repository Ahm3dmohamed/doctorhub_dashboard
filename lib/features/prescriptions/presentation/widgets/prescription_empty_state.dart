import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_widget.dart';

class PrescriptionEmptyState extends StatelessWidget {
  const PrescriptionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return EmptyWidget(
      title: l10n.rxNoFound,
      message: l10n.commonNoData,
      icon: Icons.description_outlined,
    );
  }
}
