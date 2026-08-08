import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/app/theme/app_typography.dart';
import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/quik_action_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class QuickActionButton extends StatefulWidget {
  final QuickActionData data;

  const QuickActionButton({super.key, required this.data});

  @override
  State<QuickActionButton> createState() => QuickActionButtonState();
}

class QuickActionButtonState extends State<QuickActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.data.route),
        child: AnimatedContainer(
          duration: AppConstants.animFast,
          margin: const EdgeInsets.only(bottom: AppConstants.space2),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space3,
            vertical: AppConstants.space3,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.data.color.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.data.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Icon(
                  widget.data.icon,
                  size: 18,
                  color: widget.data.color,
                ),
              ),
              const SizedBox(width: AppConstants.space3),
              Text(
                widget.data.label,
                style: AppTypography.bodyMd(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const Spacer(),
              Icon(
                isRtl
                    ? Icons.arrow_back_ios_rounded
                    : Icons.arrow_forward_ios_rounded,
                size: 12,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
