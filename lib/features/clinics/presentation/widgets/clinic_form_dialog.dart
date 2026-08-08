import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/clinic_entity.dart';

class ClinicFormDialog extends StatefulWidget {
  final ClinicEntity? clinic;
  final Function(ClinicEntity) onSave;

  const ClinicFormDialog({
    super.key,
    this.clinic,
    required this.onSave,
  });

  @override
  State<ClinicFormDialog> createState() => _ClinicFormDialogState();
}

class _ClinicFormDialogState extends State<ClinicFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _govCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.clinic?.name);
    _emailCtrl = TextEditingController(text: widget.clinic?.email);
    _phoneCtrl = TextEditingController(text: widget.clinic?.phone);
    _addressCtrl = TextEditingController(text: widget.clinic?.location.address);
    _cityCtrl = TextEditingController(
      text: widget.clinic?.location.city ?? 'New York',
    );
    _govCtrl = TextEditingController(
      text: widget.clinic?.location.governorate ?? 'NY',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _govCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final clinic = widget.clinic;
    final newClinic = ClinicEntity(
      id: clinic?.id ?? '',
      name: _nameCtrl.text.isEmpty ? 'New Health Clinic' : _nameCtrl.text,
      email: _emailCtrl.text.isEmpty
          ? 'clinic@doctorhub.com'
          : _emailCtrl.text,
      phone: _phoneCtrl.text.isEmpty
          ? '+1 (555) 000-0000'
          : _phoneCtrl.text,
      location: LocationEntity(
        address: _addressCtrl.text.isEmpty
            ? '123 Main St'
            : _addressCtrl.text,
        city: _cityCtrl.text,
        governorate: _govCtrl.text,
        latitude: clinic?.location.latitude ?? 40.7128,
        longitude: clinic?.location.longitude ?? -74.0060,
      ),
      galleryUrls: clinic?.galleryUrls ?? const [],
      acceptedInsurance:
          clinic?.acceptedInsurance ?? const ['BlueCross', 'Aetna'],
      workingHours:
          clinic?.workingHours ?? 'Mon - Fri: 08:00 AM - 06:00 PM',
      totalDoctors: clinic?.totalDoctors ?? 5,
      rating: clinic?.rating ?? 4.8,
    );

    widget.onSave(newClinic);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.clinic != null;
    final l10n = AppLocalizations.of(context)!;

    return AppModalDialog(
      title: isEditing ? l10n.clinicsEdit : l10n.clinicsAdd,
      subtitle: l10n.clinicsSubtitle,
      onConfirm: _submit,
      content: Column(
        children: [
          AppTextField(
            controller: _nameCtrl,
            label: l10n.clinicsName,
            hint: 'Central Clinic',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _emailCtrl,
            label: l10n.commonEmail,
            hint: 'contact@clinic.com',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _phoneCtrl,
            label: l10n.commonPhone,
            hint: '+1 (555) 000-0000',
          ),
          const SizedBox(height: AppConstants.space3),
          AppTextField(
            controller: _addressCtrl,
            label: l10n.clinicsAddress,
            hint: '100 Medical Blvd',
          ),
          const SizedBox(height: AppConstants.space3),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _cityCtrl,
                  label: 'City',
                  hint: 'New York',
                ),
              ),
              const SizedBox(width: AppConstants.space3),
              Expanded(
                child: AppTextField(
                  controller: _govCtrl,
                  label: 'State / Gov',
                  hint: 'NY',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
