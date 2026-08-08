import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/doctor_entity.dart';

class DoctorFormDialog extends StatefulWidget {
  final DoctorEntity? doctor;
  final Function(DoctorEntity) onSave;

  const DoctorFormDialog({
    super.key,
    this.doctor,
    required this.onSave,
  });

  @override
  State<DoctorFormDialog> createState() => _DoctorFormDialogState();
}

class _DoctorFormDialogState extends State<DoctorFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _specialtyCtrl;
  late final TextEditingController _clinicCtrl;
  late final TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    final doc = widget.doctor;
    _nameCtrl = TextEditingController(text: doc?.name);
    _emailCtrl = TextEditingController(text: doc?.email);
    _phoneCtrl = TextEditingController(text: doc?.phone);
    _specialtyCtrl = TextEditingController(
      text: doc?.specialty ?? 'Cardiology',
    );
    _clinicCtrl = TextEditingController(
      text: doc?.clinicName ?? 'Central Heart Institute',
    );
    _bioCtrl = TextEditingController(text: doc?.bio);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _specialtyCtrl.dispose();
    _clinicCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final doc = widget.doctor;
    final newDoctor = DoctorEntity(
      id: doc?.id ?? '',
      name: _nameCtrl.text.isEmpty ? 'Dr. New Doctor' : _nameCtrl.text,
      email: _emailCtrl.text.isEmpty
          ? 'doctor@doctorhub.com'
          : _emailCtrl.text,
      phone: _phoneCtrl.text.isEmpty
          ? '+1 (555) 000-0000'
          : _phoneCtrl.text,
      specialty: _specialtyCtrl.text,
      clinicName: _clinicCtrl.text,
      rating: doc?.rating ?? 5.0,
      totalPatients: doc?.totalPatients ?? 0,
      yearsOfExperience: doc?.yearsOfExperience ?? 5,
      bio: _bioCtrl.text.isEmpty ? 'General practitioner.' : _bioCtrl.text,
      workingHours: doc?.workingHours ?? const [],
    );

    widget.onSave(newDoctor);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.doctor != null;

    return AppModalDialog(
      title: isEditing ? 'Edit Doctor' : 'Add New Doctor',
      subtitle: 'Enter doctor details and specialty information.',
      onConfirm: _submit,
      content: Column(
        children: [
          AppTextField(
            controller: _nameCtrl,
            label: 'Full Name',
            hint: 'Dr. John Doe',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _emailCtrl,
            label: 'Email Address',
            hint: 'doctor@example.com',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _phoneCtrl,
            label: 'Phone Number',
            hint: '+1 (555) 000-0000',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _specialtyCtrl,
            label: 'Specialty',
            hint: 'Cardiology',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _clinicCtrl,
            label: 'Clinic Name',
            hint: 'Central Hospital',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _bioCtrl,
            label: 'Bio / Profile Summary',
            hint: 'Specialist in...',
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
