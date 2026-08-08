import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/notification_entity.dart';

class CreateNotificationDialog extends StatefulWidget {
  final Function(NotificationEntity) onSend;

  const CreateNotificationDialog({
    super.key,
    required this.onSend,
  });

  @override
  State<CreateNotificationDialog> createState() =>
      _CreateNotificationDialogState();
}

class _CreateNotificationDialogState
    extends State<CreateNotificationDialog> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;
  NotificationType _selectedType = NotificationType.info;
  NotificationAudience _selectedAudience = NotificationAudience.all;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _bodyCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleCtrl.text.isNotEmpty && _bodyCtrl.text.isNotEmpty) {
      final notif = NotificationEntity(
        id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: _titleCtrl.text,
        body: _bodyCtrl.text,
        type: _selectedType,
        targetAudience: _selectedAudience,
        createdAt: DateTime.now(),
        isRead: false,
      );

      widget.onSend(notif);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return AppModalDialog(
      title: 'Send Target Notification',
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _titleCtrl,
              label: 'Notification Title',
              hint: 'e.g. System Maintenance Notice',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _bodyCtrl,
              label: 'Message Body',
              hint: 'Type the notification content...',
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Text(
              'Notification Type:',
              style: AppTypography.labelMd(color: textColor),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: NotificationType.values.map((t) {
                final isSelected = _selectedType == t;
                return ChoiceChip(
                  label: Text(t.displayName),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedType = t);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Text(
              'Target Audience:',
              style: AppTypography.labelMd(color: textColor),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: NotificationAudience.values.map((aud) {
                final isSelected = _selectedAudience == aud;
                return ChoiceChip(
                  label: Text(aud.displayName),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedAudience = aud);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Broadcast Notification',
              leadingIcon: Icons.send_rounded,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
