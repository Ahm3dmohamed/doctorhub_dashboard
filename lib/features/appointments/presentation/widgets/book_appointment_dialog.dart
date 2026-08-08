import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/appointment_entity.dart';

class BookAppointmentDialog extends StatefulWidget {
  final Function(AppointmentEntity) onBook;

  const BookAppointmentDialog({
    super.key,
    required this.onBook,
  });

  @override
  State<BookAppointmentDialog> createState() => _BookAppointmentDialogState();
}

class _BookAppointmentDialogState extends State<BookAppointmentDialog> {
  late final TextEditingController _patientCtrl;
  late final TextEditingController _doctorCtrl;
  late final TextEditingController _specialtyCtrl;
  late final TextEditingController _clinicCtrl;
  late final TextEditingController _reasonCtrl;

  @override
  void initState() {
    super.initState();
    _patientCtrl = TextEditingController();
    _doctorCtrl = TextEditingController();
    _specialtyCtrl = TextEditingController();
    _clinicCtrl = TextEditingController();
    _reasonCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _patientCtrl.dispose();
    _doctorCtrl.dispose();
    _specialtyCtrl.dispose();
    _clinicCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final newApt = AppointmentEntity(
      id: '',
      patientName:
          _patientCtrl.text.isEmpty ? 'John Smith' : _patientCtrl.text,
      doctorName:
          _doctorCtrl.text.isEmpty ? 'Dr. Sarah Jenkins' : _doctorCtrl.text,
      specialty:
          _specialtyCtrl.text.isEmpty ? 'Cardiology' : _specialtyCtrl.text,
      clinicName: _clinicCtrl.text.isEmpty
          ? 'Central Heart Institute'
          : _clinicCtrl.text,
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
      status: AppointmentStatus.upcoming,
      reason: _reasonCtrl.text.isEmpty
          ? 'General Health Checkup'
          : _reasonCtrl.text,
    );

    widget.onBook(newApt);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppModalDialog(
      title: l10n.apptsBook,
      subtitle: l10n.apptsSubtitle,
      onConfirm: _submit,
      content: Column(
        children: [
          AppTextField(
            controller: _patientCtrl,
            label: l10n.apptsPatient,
            hint: 'John Smith',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _doctorCtrl,
            label: l10n.apptsDoctor,
            hint: 'Dr. Sarah Jenkins',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _specialtyCtrl,
            label: l10n.doctorsSpecialty,
            hint: 'Cardiology',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _clinicCtrl,
            label: l10n.clinicsName,
            hint: 'Central Heart Institute',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _reasonCtrl,
            label: l10n.apptsReason,
            hint: '...',
          ),
        ],
      ),
    );
  }
}
