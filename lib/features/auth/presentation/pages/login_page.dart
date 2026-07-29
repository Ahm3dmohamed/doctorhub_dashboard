import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _rememberMe = false;
  String? _errorMessage;

  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  // Mock credential quick-fill
  static const _quickFills = [
    ('Super Admin', 'admin@doctorhub.com', 'Admin@123', AppColors.superAdminColor),
    ('Doctor', 'doctor@doctorhub.com', 'Doctor@123', AppColors.doctorColor),
    ('Clinic Manager', 'manager@doctorhub.com', 'Manager@123', AppColors.clinicManagerColor),
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: AppConstants.animVerySlow,
    );
    _slideController = AnimationController(
      vsync: this,
      duration: AppConstants.animSlow,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.dashboard);
        } else if (state is AuthError) {
          setState(() => _errorMessage = state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutral950,
        body: Stack(
          children: [
            // ── Animated Background ──────────────────────────────────────────
            _AnimatedBackground(),

            // ── Main Content ─────────────────────────────────────────────────
            SafeArea(
              child: ResponsiveLayout(
                mobile: _MobileLayout(
                  fadeAnimation: _fadeAnimation,
                  slideAnimation: _slideAnimation,
                  child: _buildForm(context),
                ),
                desktop: _DesktopLayout(
                  fadeAnimation: _fadeAnimation,
                  slideAnimation: _slideAnimation,
                  child: _buildForm(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Logo & Welcome ─────────────────────────────────────────
              _buildHeader(),

              const SizedBox(height: AppConstants.space8),

              // ── Quick Fill Chips (Dev Helper) ──────────────────────────
              _buildQuickFillChips(),

              const SizedBox(height: AppConstants.space6),

              // ── Error Banner ───────────────────────────────────────────
              if (_errorMessage != null) ...[
                ErrorBanner(
                  message: _errorMessage!,
                  onDismiss: () => setState(() => _errorMessage = null),
                ),
                const SizedBox(height: AppConstants.space4),
              ],

              // ── Email Field ────────────────────────────────────────────
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

              // ── Password Field ─────────────────────────────────────────
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

              // ── Remember Me + Forgot Password ──────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _RememberMeCheckbox(
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

              // ── Login Button ───────────────────────────────────────────
              PrimaryButton.large(
                label: 'Sign In',
                onPressed: isLoading ? null : _onLoginPressed,
                isLoading: isLoading,
                trailingIcon: isLoading ? null : Icons.arrow_forward_rounded,
              ),

              const SizedBox(height: AppConstants.space6),

              // ── Footer ─────────────────────────────────────────────────
              _buildFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              ),
              child: const Icon(
                Icons.local_hospital_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: AppConstants.space3),
            Text(
              'DoctorHub',
              style: AppTypography.brand(color: Colors.white),
            ),
          ],
        ),

        const SizedBox(height: AppConstants.space8),

        Text(
          'Welcome back',
          style: AppTypography.displaySm(color: Colors.white),
        ),

        const SizedBox(height: AppConstants.space2),

        Text(
          'Sign in to your healthcare dashboard',
          style: AppTypography.bodyLg(color: AppColors.darkTextSecondary),
        ),
      ],
    );
  }

  Widget _buildQuickFillChips() {
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
          children: _quickFills.map((fill) {
            return _QuickFillChip(
              label: fill.$1,
              color: fill.$4,
              onTap: () => _quickFill(fill.$2, fill.$3),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.darkBorder,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.space3),
              child: Text(
                'Secure login',
                style: AppTypography.labelSm(color: AppColors.darkTextMuted),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppColors.darkBorder,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.space4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_rounded,
              size: 12,
              color: AppColors.darkTextMuted,
            ),
            const SizedBox(width: 6),
            Text(
              'Protected by DoctorHub Security',
              style: AppTypography.labelSm(color: AppColors.darkTextMuted),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Supporting Widgets ───────────────────────────────────────────────────────

class _AnimatedBackground extends StatefulWidget {
  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          decoration: const BoxDecoration(
            gradient: AppColors.authBackgroundGradient,
          ),
          child: Stack(
            children: [
              // Glowing orb top-right
              Positioned(
                top: -100,
                right: -100,
                child: Opacity(
                  opacity: 0.15 + (_controller.value * 0.1),
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Glowing orb bottom-left
              Positioned(
                bottom: -150,
                left: -150,
                child: Opacity(
                  opacity: 0.1 + (_controller.value * 0.08),
                  child: Container(
                    width: 600,
                    height: 600,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent,
                          AppColors.accent.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Grid pattern
              Opacity(
                opacity: 0.03,
                child: CustomPaint(
                  size: Size(MediaQuery.sizeOf(context).width,
                      MediaQuery.sizeOf(context).height),
                  painter: _GridPainter(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;
    const step = 48.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MobileLayout extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Widget child;

  const _MobileLayout({
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.space6),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Widget child;

  const _DesktopLayout({
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left branding panel
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.space16),
            child: _LeftBrandingPanel(),
          ),
        ),

        // Right form panel
        Expanded(
          flex: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: _GlassCard(child: child),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
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
      child: child,
    );
  }
}

class _LeftBrandingPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space4,
            vertical: AppConstants.space2,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Healthcare Platform',
                style: AppTypography.labelSm(color: AppColors.primaryLight),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.space6),

        RichText(
          text: TextSpan(
            style: AppTypography.displayMd(color: Colors.white),
            children: [
              const TextSpan(text: 'The modern way to\nmanage '),
              TextSpan(
                text: 'healthcare',
                style: AppTypography.displayMd().copyWith(
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [AppColors.primaryLight, AppColors.accentLight],
                    ).createShader(
                      const Rect.fromLTWH(0, 0, 300, 60),
                    ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.space5),

        Text(
          'DoctorHub centralizes patient records, appointments,\nand analytics for doctors, clinics, and administrators.',
          style: AppTypography.bodyLg(color: AppColors.darkTextSecondary),
        ),

        const SizedBox(height: AppConstants.space10),

        // Feature list
        ...[
          (Icons.analytics_rounded, 'Real-time analytics & insights'),
          (Icons.people_rounded, 'Patient management simplified'),
          (Icons.calendar_month_rounded, 'Smart appointment scheduling'),
          (Icons.security_rounded, 'HIPAA-compliant & secure'),
        ].map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.space4),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: Icon(item.$1, size: 18, color: Colors.white),
                ),
                const SizedBox(width: AppConstants.space3),
                Text(
                  item.$2,
                  style: AppTypography.bodyMd(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const _RememberMeCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Remember me',
            style: AppTypography.bodySm(color: AppColors.darkTextSecondary),
          ),
        ],
      ),
    );
  }
}

class _QuickFillChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickFillChip({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelSm(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
