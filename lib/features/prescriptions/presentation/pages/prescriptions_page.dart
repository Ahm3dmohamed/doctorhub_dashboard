import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../cubit/prescription_cubit.dart';
import '../widgets/create_prescription_dialog.dart';
import '../widgets/prescription_content.dart';
import '../widgets/prescription_header.dart';
import '../widgets/prescription_search_field.dart';

class PrescriptionsPage extends StatefulWidget {
  const PrescriptionsPage({super.key});

  @override
  State<PrescriptionsPage> createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends State<PrescriptionsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PrescriptionCubit>().loadPrescriptions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (_) => CreatePrescriptionDialog(
        onSaved: (newRx) {
          context.read<PrescriptionCubit>().createPrescription(newRx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBreadcrumb(
              items: [
                BreadcrumbItem(
                  label: 'Dashboard',
                  onTap: () => context.go(AppRoutes.dashboard),
                ),
                const BreadcrumbItem(label: 'Prescriptions'),
              ],
            ),
            const SizedBox(height: AppConstants.space4),
            PrescriptionHeader(
              onNewPrescription: _showCreateDialog,
            ),
            const SizedBox(height: AppConstants.space6),
            PrescriptionSearchField(
              controller: _searchController,
              onChanged: (query) {
                context
                    .read<PrescriptionCubit>()
                    .loadPrescriptions(query: query);
              },
            ),
            const SizedBox(height: AppConstants.space6),
            const PrescriptionContent(),
          ],
        ),
      ),
    );
  }
}
