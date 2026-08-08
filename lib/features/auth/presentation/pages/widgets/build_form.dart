import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/app_router.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../shared/widgets/app_error_widget.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../../../../shared/widgets/primary_button.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
import 'build_footer.dart';
import 'build_header.dart';
import 'quik_fill_chip.dart';
import 'remember_me_chckbox.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(context),
              const SizedBox(height: AppConstants.space8),
              buildQuickFillChips(l10n),

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
                label: l10n.commonEmail,
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.mail_outline_rounded,
                focusNode: _emailFocus,
                validator: (val) => Validators.email(val, l10n),
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
                validator: (val) => Validators.loginPassword(val, l10n),
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
                      l10n.authForgotPassword,
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
                label: l10n.authSignIn,
                onPressed: isLoading ? null : _onLoginPressed,
                isLoading: isLoading,
                trailingIcon: isLoading
                    ? null
                    : (isRtl
                          ? Icons.arrow_back_rounded
                          : Icons.arrow_forward_rounded),
              ),

              const SizedBox(height: AppConstants.space6),

              buildFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget buildQuickFillChips(AppLocalizations l10n) {
    final quickFills = [
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
          l10n.authSelectRole,
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
