import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/patient_entity.dart';

class PatientFormDialog extends StatefulWidget {
  final PatientEntity? patient;
  final Function(PatientEntity) onSave;

  const PatientFormDialog({
    super.key,
    this.patient,
    required this.onSave,
  });

  @override
  State<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends State<PatientFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _ageCtrl;
  late final TextEditingController _bloodCtrl;
  late final TextEditingController _historyCtrl;
  late final TextEditingController _allergiesCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.patient;
    _nameCtrl = TextEditingController(text: p?.name);
    _emailCtrl = TextEditingController(text: p?.email);
    _phoneCtrl = TextEditingController(text: p?.phone);
    _ageCtrl = TextEditingController(text: p?.age.toString());
    _bloodCtrl = TextEditingController(text: p?.bloodGroup ?? 'O+');
    _historyCtrl = TextEditingController(text: p?.medicalHistory);
    _allergiesCtrl = TextEditingController(text: p?.allergies);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _bloodCtrl.dispose();
    _historyCtrl.dispose();
    _allergiesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final p = widget.patient;
    final newPatient = PatientEntity(
      id: p?.id ?? '',
      name: _nameCtrl.text.isEmpty ? 'Jane Doe' : _nameCtrl.text,
      email: _emailCtrl.text.isEmpty
          ? 'patient@example.com'
          : _emailCtrl.text,
      phone: _phoneCtrl.text.isEmpty
          ? '+1 (555) 000-0000'
          : _phoneCtrl.text,
      age: int.tryParse(_ageCtrl.text) ?? 30,
      gender: p?.gender ?? 'Female',
      bloodGroup: _bloodCtrl.text,
      emergencyContact: p?.emergencyContact ??
          const EmergencyContact(
            name: 'Contact Person',
            relation: 'Family',
            phone: '+1 (555) 111-0000',
          ),
      medicalHistory: _historyCtrl.text.isEmpty
          ? 'No prior medical history.'
          : _historyCtrl.text,
      allergies: _allergiesCtrl.text.isEmpty ? 'None' : _allergiesCtrl.text,
      registeredAt: p?.registeredAt ?? DateTime.now(),
    );

    widget.onSave(newPatient);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.patient != null;

    return AppModalDialog(
      title: isEditing ? 'Edit Patient' : 'Add New Patient',
      subtitle: 'Enter patient bio and emergency contact details.',
      onConfirm: _submit,
      content: Column(
        children: [
          AppTextField(
            controller: _nameCtrl,
            label: 'Full Name',
            hint: 'Jane Doe',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _emailCtrl,
            label: 'Email Address',
            hint: 'patient@example.com',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _phoneCtrl,
            label: 'Phone Number',
            hint: '+1 (555) 000-0000',
          ),
          const SizedBox(height: AppConstants.space3),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _ageCtrl,
                  label: 'Age',
                  hint: '30',
                ),
              ),
              const SizedBox(width: AppConstants.space3),
              Expanded(
                child: AppTextField(
                  controller: _bloodCtrl,
                  label: 'Blood Group',
                  hint: 'O+',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _historyCtrl,
            label: 'Medical History',
            hint: 'Prior conditions...',
            maxLines: 2,
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _allergiesCtrl,
            label: 'Known Allergies',
            hint: 'Penicillin...',
          ),
        ],
      ),
    );
  }
}
