import 'package:doctorhub_dashboard/features/auth/presentation/pages/widgets/animated_background.dart';
import 'package:doctorhub_dashboard/features/auth/presentation/pages/widgets/build_form.dart';
import 'package:doctorhub_dashboard/features/auth/presentation/pages/widgets/desktop_layout.dart';
import 'package:doctorhub_dashboard/features/auth/presentation/pages/widgets/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  String? errorMessage;

  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

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
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.dashboard);
        } else if (state is AuthError) {
          setState(() => errorMessage = state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutral950,
        body: Stack(
          children: [
            AnimatedBackground(),

            SafeArea(
              child: ResponsiveLayout(
                mobile: MobileLayout(
                  fadeAnimation: _fadeAnimation,
                  slideAnimation: _slideAnimation,
                  child: FormBuildWidget(),
                ),
                desktop: DesktopLayout(
                  fadeAnimation: _fadeAnimation,
                  slideAnimation: _slideAnimation,
                  child: FormBuildWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
