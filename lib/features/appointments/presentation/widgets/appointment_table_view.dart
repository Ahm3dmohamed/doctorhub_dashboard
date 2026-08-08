import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/app_data_table.dart';
import '../../domain/entities/appointment_entity.dart';
import 'appointment_status_badge.dart';

class AppointmentTableView extends StatelessWidget {
  final bool isLoading;
  final List<AppointmentEntity> appointments;
  final ValueChanged<String> onSearchChanged;
  final Function(AppointmentEntity) onAccept;
  final Function(AppointmentEntity) onReject;
  final Function(AppointmentEntity) onReschedule;

  const AppointmentTableView({
    super.key,
    required this.isLoading,
    required this.appointments,
    required this.onSearchChanged,
    required this.onAccept,
    required this.onReject,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppDataTable<AppointmentEntity>(
      isLoading: isLoading,
      items: appointments,
      searchHint: 'Search appointments by patient, doctor...',
      onSearchChanged: onSearchChanged,
      columns: [
        DataTableColumn<AppointmentEntity>(
          title: 'Patient',
          builder: (a) => Text(
            a.patientName,
            style: AppTypography.bodyMd(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              weight: FontWeight.w600,
            ),
          ),
        ),
        DataTableColumn<AppointmentEntity>(
          title: 'Doctor & Specialty',
          builder: (a) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                a.doctorName,
                style: AppTypography.bodySm(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                a.specialty,
                style: AppTypography.labelSm(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        DataTableColumn<AppointmentEntity>(
          title: 'Date & Time',
          builder: (a) => Text(
            DateFormat('MMM dd, yyyy • hh:mm a').format(a.dateTime),
            style: AppTypography.bodySm(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        DataTableColumn<AppointmentEntity>(
          title: 'Status',
          builder: (a) => AppointmentStatusBadge(status: a.status),
        ),
        DataTableColumn<AppointmentEntity>(
          title: 'Actions',
          builder: (a) => Row(
            children: [
              if (a.status == AppointmentStatus.pending) ...[
                IconButton(
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.success,
                    size: 20,
                  ),
                  onPressed: () => onAccept(a),
                  tooltip: 'Accept Appointment',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.highlight_off_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                  onPressed: () => onReject(a),
                  tooltip: 'Reject Appointment',
                ),
              ],
              IconButton(
                icon: const Icon(
                  Icons.edit_calendar_rounded,
                  size: 18,
                ),
                onPressed: () => onReschedule(a),
                tooltip: 'Reschedule',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
