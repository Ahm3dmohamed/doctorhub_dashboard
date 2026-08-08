import 'package:doctorhub_dashboard/app/router/app_router.dart';
import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/app/theme/app_typography.dart';
import 'package:doctorhub_dashboard/core/constants/app_constants.dart';
import 'package:doctorhub_dashboard/core/utils/validators.dart';
import 'package:doctorhub_dashboard/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctorhub_dashboard/features/auth/presentation/cubit/auth_state.dart';
import 'package:doctorhub_dashboard/features/auth/presentation/pages/widgets/build_footer.dart';
import 'package:doctorhub_dashboard/features/auth/presentation/pages/widgets/build_header.dart';
import 'package:doctorhub_dashboard/features/auth/presentation/pages/widgets/quik_fill_chip.dart';
import 'package:doctorhub_dashboard/features/auth/presentation/pages/widgets/remember_me_chckbox.dart';
import 'package:doctorhub_dashboard/shared/widgets/app_error_widget.dart';
import 'package:doctorhub_dashboard/shared/widgets/app_text_field.dart';
import 'package:doctorhub_dashboard/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FormBuildWidget extends StatefulWidget {
  const FormBuildWidget({super.key});

  @override
  State<FormBuildWidget> createState() => _FormBuildWidgetState();
}

class _FormBuildWidgetState extends State<FormBuildWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _rememberMe = false;
  String? _errorMessage;

  void _onLoginPressed() {
    setState(() => _errorMessage = null);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );
  }

  void _quickFill(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
      _errorMessage = null;
    });
    _formKey.currentState?.reset();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(),
              const SizedBox(height: AppConstants.space8),
              buildQuickFillChips(),

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
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.mail_outline_rounded,
                focusNode: _emailFocus,
                validator: Validators.email,
                onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                enabled: !isLoading,
              ),

              const SizedBox(height: AppConstants.space4),

              AppTextField(
                controller: _passwordController,
                label: 'Password',
                hint: '••••••••',
                obscureText: true,
                textInputAction: TextInputAction.done,
                prefixIcon: Icons.lock_outline_rounded,
                focusNode: _passwordFocus,
                validator: Validators.loginPassword,
                onFieldSubmitted: (_) => _onLoginPressed(),
                enabled: !isLoading,
              ),

              const SizedBox(height: AppConstants.space4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RememberMeCheckbox(
                    value: _rememberMe,
                    onChanged: isLoading
                        ? null
                        : (v) => setState(() => _rememberMe = v ?? false),
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => context.go(AppRoutes.forgotPassword),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot password?',
                      style: AppTypography.bodySm(
                        color: AppColors.primaryLight,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.space6),

              PrimaryButton.large(
                label: 'Sign In',
                onPressed: isLoading ? null : _onLoginPressed,
                isLoading: isLoading,
                trailingIcon: isLoading ? null : Icons.arrow_forward_rounded,
              ),

              const SizedBox(height: AppConstants.space6),

              // ── Footer ─────────────────────────────────────────────────
              buildFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget buildQuickFillChips() {
    const quickFills = [
      (
        'Super Admin',
        'admin@doctorhub.com',
        'Admin123',
        AppColors.superAdminColor,
      ),
      ('Doctor', 'doctor@doctorhub.com', 'Doctor123', AppColors.doctorColor),
      (
        'Clinic Manager',
        'manager@doctorhub.com',
        'Manager123',
        AppColors.clinicManagerColor,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick sign-in (demo)',
          style: AppTypography.labelMd(color: AppColors.darkTextSecondary),
        ),
        const SizedBox(height: AppConstants.space2),
        Wrap(
          spacing: AppConstants.space2,
          runSpacing: AppConstants.space2,
          children: quickFills.map((fill) {
            return QuickFillChip(
              label: fill.$1,
              color: fill.$4,
              onTap: () => _quickFill(fill.$2, fill.$3),
            );
          }).toList(),
        ),
      ],
    );
  }
}
