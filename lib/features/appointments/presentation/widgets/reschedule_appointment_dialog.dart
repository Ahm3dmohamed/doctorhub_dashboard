import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../domain/entities/appointment_entity.dart';

class RescheduleAppointmentDialog extends StatefulWidget {
  final AppointmentEntity appointment;
  final Function(DateTime) onReschedule;

  const RescheduleAppointmentDialog({
    super.key,
    required this.appointment,
    required this.onReschedule,
  });

  @override
  State<RescheduleAppointmentDialog> createState() =>
      _RescheduleAppointmentDialogState();
}

class _RescheduleAppointmentDialogState
    extends State<RescheduleAppointmentDialog> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.appointment.dateTime;
  }

  void _submit() {
    widget.onReschedule(_selectedDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppModalDialog(
      title: 'Reschedule Appointment',
      subtitle: 'Change consultation date for ${widget.appointment.patientName}',
      onConfirm: _submit,
      content: Column(
        children: [
          Text(
            'Current Schedule: ${DateFormat('MMM dd, yyyy • hh:mm a').format(widget.appointment.dateTime)}',
            style: AppTypography.labelMd(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
              );
              if (picked != null) {
                setState(
                  () => _selectedDate = picked.add(const Duration(hours: 10)),
                );
              }
            },
            icon: const Icon(Icons.calendar_today_rounded, size: 18),
            label: Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
          ),
        ],
      ),
    );
  }
}
