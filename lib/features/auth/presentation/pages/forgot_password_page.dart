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

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
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
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() => _errorMessage = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthCubit>().forgotPassword(
          email: _emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          setState(() => _errorMessage = state.message);
        } else if (state is AuthForgotPasswordSent) {
          context.go(
            AppRoutes.resetPassword,
            extra: {'email': state.email},
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutral950,
        body: Stack(
          children: [
            // Background
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
                  onTap: () => context.go(AppRoutes.login),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back_rounded,
                        size: 16,
                        color: AppColors.darkTextSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Back to login',
                        style: AppTypography.bodySm(
                            color: AppColors.darkTextSecondary),
                      ),
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
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusXl),
                  ),
                  child: const Icon(
                    Icons.mail_outline_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),

                const SizedBox(height: AppConstants.space5),

                Text(
                  'Forgot password?',
                  style: AppTypography.headingXl(color: Colors.white),
                ),

                const SizedBox(height: AppConstants.space2),

                Text(
                  'No worries! Enter your email address and we\'ll send you a reset link.',
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

                AppTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: Validators.email,
                  onFieldSubmitted: (_) => _onSubmit(),
                  enabled: !isLoading,
                ),

                const SizedBox(height: AppConstants.space6),

                PrimaryButton.large(
                  label: 'Send Reset Link',
                  onPressed: isLoading ? null : _onSubmit,
                  isLoading: isLoading,
                  trailingIcon: isLoading ? null : Icons.send_rounded,
                ),

                const SizedBox(height: AppConstants.space6),

                Center(
                  child: Text(
                    'Remember your password? ',
                    style: AppTypography.bodySm(
                        color: AppColors.darkTextSecondary),
                  ),
                ),
                const SizedBox(height: 2),
                Center(
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: Text(
                      'Sign In',
                      style: AppTypography.bodySm(
                        color: AppColors.primaryLight,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
