import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? email;

  const ResetPasswordPage({super.key, this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _errorMessage;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: AppConstants.animSlow,
    )..forward();
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() => _errorMessage = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthCubit>().resetPassword(
          token: _tokenController.text.trim(),
          newPassword: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          setState(() => _errorMessage = state.message);
        } else if (state is AuthPasswordResetSuccess) {
          _showSuccessAndNavigate(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutral950,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.authBackgroundGradient,
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.space6),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: _buildCard(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space8),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(AppConstants.radius2xl),
        border: Border.all(color: AppColors.glassBorderDark),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 40,
            spreadRadius: -5,
          ),
        ],
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => context.go(AppRoutes.forgotPassword),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back_rounded,
                          size: 16, color: AppColors.darkTextSecondary),
                      const SizedBox(width: 6),
                      Text('Back',
                          style: AppTypography.bodySm(
                              color: AppColors.darkTextSecondary)),
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.space8),

                // Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                  ),
                  child: const Icon(Icons.lock_reset_rounded,
                      color: Colors.white, size: 26),
                ),

                const SizedBox(height: AppConstants.space5),

                Text('Set new password',
                    style: AppTypography.headingXl(color: Colors.white)),

                const SizedBox(height: AppConstants.space2),

                if (widget.email != null)
                  RichText(
                    text: TextSpan(
                      style: AppTypography.bodyMd(
                          color: AppColors.darkTextSecondary),
                      children: [
                        const TextSpan(text: 'Reset code was sent to '),
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    'Enter the reset code sent to your email.',
                    style: AppTypography.bodyMd(
                        color: AppColors.darkTextSecondary),
                  ),

                const SizedBox(height: AppConstants.space6),

                if (_errorMessage != null) ...[
                  ErrorBanner(
                    message: _errorMessage!,
                    onDismiss: () => setState(() => _errorMessage = null),
                  ),
                  const SizedBox(height: AppConstants.space4),
                ],

                // Token
                AppTextField(
                  controller: _tokenController,
                  label: 'Reset Code',
                  hint: 'Enter 6-character code',
                  prefixIcon: Icons.key_rounded,
                  textInputAction: TextInputAction.next,
                  validator: Validators.resetToken,
                  enabled: !isLoading,
                ),

                const SizedBox(height: AppConstants.space4),

                // New Password
                AppTextField(
                  controller: _passwordController,
                  label: 'New Password',
                  hint: '••••••••',
                  obscureText: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  textInputAction: TextInputAction.next,
                  validator: Validators.password,
                  enabled: !isLoading,
                ),

                const SizedBox(height: AppConstants.space4),

                // Confirm Password
                AppTextField(
                  controller: _confirmController,
                  label: 'Confirm Password',
                  hint: '••••••••',
                  obscureText: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  textInputAction: TextInputAction.done,
                  validator: Validators.confirmPassword(_passwordController.text),
                  onFieldSubmitted: (_) => _onSubmit(),
                  enabled: !isLoading,
                ),

                // Password strength hint
                const SizedBox(height: AppConstants.space3),
                _PasswordStrengthHint(),

                const SizedBox(height: AppConstants.space6),

                PrimaryButton.large(
                  label: 'Reset Password',
                  onPressed: isLoading ? null : _onSubmit,
                  isLoading: isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSuccessAndNavigate(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 20),
            const SizedBox(width: 10),
            Text(
              'Password reset successfully!',
              style: AppTypography.bodyMd(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.neutral900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg)),
      ),
    );
    context.go(AppRoutes.login);
  }
}

class _PasswordStrengthHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppConstants.space2,
      runSpacing: AppConstants.space1,
      children: [
        _HintChip(label: '8+ chars'),
        _HintChip(label: 'Uppercase'),
        _HintChip(label: 'Number'),
        _HintChip(label: 'Special char'),
      ],
    );
  }
}

class _HintChip extends StatelessWidget {
  final String label;
  const _HintChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Text(label, style: AppTypography.labelSm(color: AppColors.darkTextSecondary)),
    );
  }
}
