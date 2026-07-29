import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';

/// DoctorHub Route Names
abstract class AppRoutes {
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
}

/// GoRouter configuration with auth guard
class AppRouter {
  AppRouter._();

  static GoRouter createRouter(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: AppRoutes.login,
      refreshListenable: _AuthChangeNotifier(authCubit),
      redirect: (context, state) => _redirect(context, state, authCubit),
      errorBuilder: (context, state) => _ErrorPage(error: state.error),
      routes: [
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const LoginPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          name: 'forgot-password',
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const ForgotPasswordPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.resetPassword,
          name: 'reset-password',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return _fadeTransition(
              state,
              ResetPasswordPage(email: extra?['email'] as String?),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const DashboardPage(),
          ),
        ),
      ],
    );
  }

  static String? _redirect(
    BuildContext context,
    GoRouterState state,
    AuthCubit authCubit,
  ) {
    final authState = authCubit.state;
    final isAuthRoute = state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.forgotPassword ||
        state.matchedLocation == AppRoutes.resetPassword;

    if (authState is AuthLoading || authState is AuthInitial) {
      return null;
    }

    if (authState is AuthAuthenticated) {
      if (isAuthRoute) return AppRoutes.dashboard;
      return null;
    }

    // Not authenticated
    if (!isAuthRoute) return AppRoutes.login;
    return null;
  }

  static CustomTransitionPage<void> _fadeTransition(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
    );
  }
}

/// Notifies GoRouter when auth state changes
class _AuthChangeNotifier extends ChangeNotifier {
  final AuthCubit _authCubit;

  _AuthChangeNotifier(this._authCubit) {
    _authCubit.stream.listen((_) => notifyListeners());
  }
}

/// 404 / Error Page
class _ErrorPage extends StatelessWidget {
  final Exception? error;

  const _ErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Page Not Found', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
