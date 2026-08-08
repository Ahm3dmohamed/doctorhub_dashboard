import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import 'primary_button.dart';

class AppModalDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final String? confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isConfirmLoading;
  final bool isDestructive;
  final double maxWidth;

  const AppModalDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.content,
    this.confirmLabel,
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.isConfirmLoading = false,
    this.isDestructive = false,
    this.maxWidth = 540,
  });

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
    bool isDestructive = true,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AppModalDialog(
        title: title,
        subtitle: message,
        isDestructive: isDestructive,
        confirmLabel:
            confirmLabel ??
            (isDestructive ? l10n.commonDelete : l10n.commonConfirm),
        cancelLabel: cancelLabel ?? l10n.commonCancel,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
        content: const SizedBox.shrink(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final resolvedConfirm =
        confirmLabel ??
        (isDestructive
            ? (l10n?.commonDelete ?? 'Delete')
            : (l10n?.commonSave ?? 'Save'));
    final resolvedCancel = cancelLabel ?? (l10n?.commonCancel ?? 'Cancel');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppConstants.space4),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppConstants.radius2xl),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Dialog Header ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(AppConstants.space6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTypography.headingLg(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: AppTypography.bodySm(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onCancel ?? () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                height: 1,
              ),

              // ─── Content Body ──────────────────────────────────────────────
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.space6),
                  child: content,
                ),
              ),

              // ─── Footer Buttons ───────────────────────────────────────────
              Divider(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(AppConstants.space4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (cancelLabel != null || onCancel != null)
                      SecondaryButton(
                        label: resolvedCancel,
                        width: 100,
                        height: 40,
                        onPressed:
                            onCancel ?? () => Navigator.of(context).pop(),
                      ),
                    if (onConfirm != null) ...[
                      const SizedBox(width: AppConstants.space3),
                      PrimaryButton(
                        label: resolvedConfirm,
                        width: 120,
                        height: 40,
                        isLoading: isConfirmLoading,
                        onPressed: onConfirm,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
