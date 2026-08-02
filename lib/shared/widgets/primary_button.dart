import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

/// Primary gradient button with loading, disabled, and icon states.
///
/// Safely handles both bounded (Column/padding) and unbounded (Row) parent
/// contexts by checking layout constraints before applying [double.infinity].
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? width;
  final double height;
  final ButtonSize size;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height = 48,
    this.size = ButtonSize.md,
  });

  const PrimaryButton.small({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height = 36,
    this.size = ButtonSize.sm,
  });

  const PrimaryButton.large({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height = 56,
    this.size = ButtonSize.lg,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isInteractable =>
      !widget.isLoading && !widget.isDisabled && widget.onPressed != null;

  void _onTapDown(TapDownDetails _) {
    if (_isInteractable) _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    if (_isInteractable) _controller.reverse();
  }

  void _onTapCancel() {
    if (_isInteractable) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double? effectiveWidth =
            widget.width ?? (constraints.hasBoundedWidth ? double.infinity : null);

        return GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SizedBox(
              width: effectiveWidth,
              height: widget.height,
              child: AnimatedOpacity(
                opacity: _isInteractable ? 1.0 : 0.6,
                duration: AppConstants.animFast,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: _isInteractable
                        ? AppColors.primaryGradient
                        : const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                    boxShadow: _isInteractable
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isInteractable ? widget.onPressed : null,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusLg,
                      ),
                      splashColor: Colors.white.withValues(alpha: 0.1),
                      highlightColor: Colors.white.withValues(alpha: 0.05),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          widthFactor: effectiveWidth == null ? 1.0 : null,
                          child: widget.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (widget.leadingIcon != null) ...[
                                      Icon(
                                        widget.leadingIcon,
                                        color: Colors.white,
                                        size: widget.size._iconSize,
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Text(
                                      widget.label,
                                      style: widget.size._textStyle,
                                    ),
                                    if (widget.trailingIcon != null) ...[
                                      const SizedBox(width: 8),
                                      Icon(
                                        widget.trailingIcon,
                                        color: Colors.white,
                                        size: widget.size._iconSize,
                                      ),
                                    ],
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum ButtonSize {
  sm,
  md,
  lg;

  double get _iconSize => switch (this) {
    ButtonSize.sm => 14,
    ButtonSize.md => 16,
    ButtonSize.lg => 18,
  };

  TextStyle get _textStyle => switch (this) {
    ButtonSize.sm => AppTypography.buttonSm(color: Colors.white),
    ButtonSize.md => AppTypography.buttonMd(color: Colors.white),
    ButtonSize.lg => AppTypography.buttonLg(color: Colors.white),
  };
}

/// Secondary (outlined) button.
///
/// Uses the same safe [LayoutBuilder] pattern as [PrimaryButton] to avoid
/// [BoxConstraints] infinite-width assertions in unbounded parent widgets.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? leadingIcon;
  final double? width;
  final double height;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double? effectiveWidth =
            width ?? (constraints.hasBoundedWidth ? double.infinity : null);

        return SizedBox(
          width: effectiveWidth,
          height: height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              ),
              foregroundColor: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            child: isLoading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (leadingIcon != null) ...[
                        Icon(leadingIcon, size: 16),
                        const SizedBox(width: 8),
                      ],
                      Text(label, style: AppTypography.buttonMd()),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
