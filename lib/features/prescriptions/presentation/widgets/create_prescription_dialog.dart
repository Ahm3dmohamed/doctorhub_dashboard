import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/prescription_entity.dart';
import 'medicine_form_item.dart';

class CreatePrescriptionDialog extends StatefulWidget {
  final Function(PrescriptionEntity) onSaved;

  const CreatePrescriptionDialog({
    super.key,
    required this.onSaved,
  });

  @override
  State<CreatePrescriptionDialog> createState() =>
      _CreatePrescriptionDialogState();
}

class _CreatePrescriptionDialogState extends State<CreatePrescriptionDialog> {
  late final TextEditingController _patientNameCtrl;
  late final TextEditingController _doctorNameCtrl;
  late final TextEditingController _notesCtrl;
  final List<MedicineFormData> _medicines = [];

  @override
  void initState() {
    super.initState();
    _patientNameCtrl = TextEditingController();
    _doctorNameCtrl = TextEditingController();
    _notesCtrl = TextEditingController();
    _medicines.add(MedicineFormData());
  }

  @override
  void dispose() {
    _patientNameCtrl.dispose();
    _doctorNameCtrl.dispose();
    _notesCtrl.dispose();
    for (final med in _medicines) {
      med.dispose();
    }
    super.dispose();
  }

  void _addMedicine() {
    setState(() {
      _medicines.add(MedicineFormData());
    });
  }

  void _removeMedicine(int index) {
    setState(() {
      final removed = _medicines.removeAt(index);
      removed.dispose();
    });
  }

  void _submit() {
    final newRx = PrescriptionEntity(
      id: 'RX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      patientId: 'PAT-001',
      patientName: _patientNameCtrl.text.isEmpty
          ? 'Patient'
          : _patientNameCtrl.text,
      doctorId: 'DOC-001',
      doctorName: _doctorNameCtrl.text.isEmpty
          ? 'Doctor'
          : _doctorNameCtrl.text,
      date: DateTime.now(),
      status: PrescriptionStatus.active,
      notes: _notesCtrl.text,
      medicines: _medicines.map((m) {
        return MedicineItem(
          name: m.name.text.isEmpty ? 'Medicine' : m.name.text,
          dosage: m.dosage.text.isEmpty ? '10mg' : m.dosage.text,
          frequency: m.frequency.text.isEmpty ? 'Daily' : m.frequency.text,
          duration: m.duration.text.isEmpty ? '7 Days' : m.duration.text,
          instructions: m.instructions.text.isEmpty
              ? 'With water'
              : m.instructions.text,
        );
      }).toList(),
    );

    widget.onSaved(newRx);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppModalDialog(
      title: l10n.rxCreate,
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _patientNameCtrl,
                label: l10n.apptsPatient,
                hint: 'e.g. Sarah Jenkins',
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _doctorNameCtrl,
                label: l10n.apptsDoctor,
                hint: 'e.g. Dr. Alexander Wright',
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.rxMedicineName,
                    style: AppTypography.headingSm(),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.rxAddMedicine),
                    onPressed: _addMedicine,
                  ),
                ],
              ),
              ..._medicines.asMap().entries.map((entry) {
                final idx = entry.key;
                final data = entry.value;
                return MedicineFormItem(
                  index: idx,
                  data: data,
                  showRemove: _medicines.length > 1,
                  onRemove: () => _removeMedicine(idx),
                );
              }),
              AppTextField(
                controller: _notesCtrl,
                label: l10n.rxInstructions,
                hint: '...',
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: l10n.commonSave,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
