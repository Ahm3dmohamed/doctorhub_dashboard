import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../cubit/prescription_cubit.dart';
import '../cubit/prescription_state.dart';
import 'prescription_empty_state.dart';
import 'prescription_grid.dart';

class PrescriptionContent extends StatelessWidget {
  const PrescriptionContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionCubit, PrescriptionState>(
      builder: (context, state) {
        if (state is PrescriptionLoading) {
          return const LoadingWidget(
            message: 'Loading Prescriptions...',
          );
        }

        if (state is PrescriptionError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () =>
                context.read<PrescriptionCubit>().loadPrescriptions(),
          );
        }

        if (state is PrescriptionLoaded) {
          if (state.prescriptions.isEmpty) {
            return const PrescriptionEmptyState();
          }

          return PrescriptionGrid(
            prescriptions: state.prescriptions,
            onDelete: (rx) {
              context.read<PrescriptionCubit>().deletePrescription(rx.id);
            },
            onExportPdf: (rx) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Generating PDF for ${rx.id}...'),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
