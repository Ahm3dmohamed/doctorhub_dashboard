import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/injection.dart';
import '../../features/appointments/presentation/cubit/appointment_cubit.dart';
import '../../features/appointments/presentation/pages/appointments_page.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/clinics/presentation/cubit/clinic_cubit.dart';
import '../../features/clinics/presentation/pages/clinics_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/widgets/dashboard_shell.dart';
import '../../features/doctors/presentation/cubit/doctor_cubit.dart';
import '../../features/doctors/presentation/pages/doctors_page.dart';
import '../../features/patients/presentation/cubit/patient_cubit.dart';
import '../../features/patients/presentation/pages/patients_page.dart';
import '../../features/medical_records/presentation/cubit/medical_record_cubit.dart';
import '../../features/medical_records/presentation/pages/medical_records_page.dart';
import '../../features/notifications/presentation/cubit/notification_cubit.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/prescriptions/presentation/cubit/prescription_cubit.dart';
import '../../features/prescriptions/presentation/pages/prescriptions_page.dart';
import '../../features/reports/presentation/cubit/report_cubit.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/reviews/presentation/cubit/review_cubit.dart';
import '../../features/reviews/presentation/pages/reviews_page.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
  static const doctors = '/doctors';
  static const clinics = '/clinics';
  static const patients = '/patients';
  static const appointments = '/appointments';
  static const medicalRecords = '/medical-records';
  static const prescriptions = '/prescriptions';
  static const reviews = '/reviews';
  static const notifications = '/notifications';
  static const reports = '/reports';
}

class AppRouter {
  AppRouter._();

  static GoRouter createRouter(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: AppRoutes.login,
      refreshListenable: _AuthChangeNotifier(authCubit),
      redirect: (context, state) => _redirect(context, state, authCubit),
      routes: [
        // Auth Routes
        GoRoute(
          path: AppRoutes.login,
          pageBuilder: (context, state) => _fadeTransition(state, const LoginPage()),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          pageBuilder: (context, state) => _fadeTransition(state, const ForgotPasswordPage()),
        ),
        GoRoute(
          path: AppRoutes.resetPassword,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return _fadeTransition(
              state,
              ResetPasswordPage(email: extra?['email'] as String?),
            );
          },
        ),

        // Authenticated Dashboard Shell Route
        ShellRoute(
          builder: (context, state, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<NotificationCubit>(
                  create: (_) => sl<NotificationCubit>()..loadNotifications(),
                ),
                BlocProvider<PatientCubit>(
                  create: (_) => sl<PatientCubit>(),
                ),
                BlocProvider<AppointmentCubit>(
                  create: (_) => sl<AppointmentCubit>(),
                ),
                BlocProvider<ClinicCubit>(
                  create: (_) => sl<ClinicCubit>(),
                ),
                BlocProvider<DoctorCubit>(
                  create: (_) => sl<DoctorCubit>(),
                ),
                BlocProvider<MedicalRecordCubit>(
                  create: (_) => sl<MedicalRecordCubit>(),
                ),
                BlocProvider<PrescriptionCubit>(
                  create: (_) => sl<PrescriptionCubit>(),
                ),
                BlocProvider<ReviewCubit>(
                  create: (_) => sl<ReviewCubit>(),
                ),
                BlocProvider<ReportCubit>(
                  create: (_) => sl<ReportCubit>(),
                ),
              ],
              child: DashboardShell(child: child),
            );
          },
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              pageBuilder: (context, state) => _fadeTransition(state, const DashboardPage()),
            ),
            GoRoute(
              path: AppRoutes.doctors,
              pageBuilder: (context, state) => _fadeTransition(state, const DoctorsPage()),
            ),
            GoRoute(
              path: AppRoutes.clinics,
              pageBuilder: (context, state) => _fadeTransition(state, const ClinicsPage()),
            ),
            GoRoute(
              path: AppRoutes.patients,
              pageBuilder: (context, state) => _fadeTransition(state, const PatientsPage()),
            ),
            GoRoute(
              path: AppRoutes.appointments,
              pageBuilder: (context, state) => _fadeTransition(state, const AppointmentsPage()),
            ),
            GoRoute(
              path: AppRoutes.medicalRecords,
              pageBuilder: (context, state) => _fadeTransition(state, const MedicalRecordsPage()),
            ),
            GoRoute(
              path: AppRoutes.prescriptions,
              pageBuilder: (context, state) => _fadeTransition(state, const PrescriptionsPage()),
            ),
            GoRoute(
              path: AppRoutes.reviews,
              pageBuilder: (context, state) => _fadeTransition(state, const ReviewsPage()),
            ),
            GoRoute(
              path: AppRoutes.notifications,
              pageBuilder: (context, state) => _fadeTransition(state, const NotificationsPage()),
            ),
            GoRoute(
              path: AppRoutes.reports,
              pageBuilder: (context, state) => _fadeTransition(state, const ReportsPage()),
            ),
          ],
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
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }
}

class _AuthChangeNotifier extends ChangeNotifier {
  final AuthCubit _authCubit;

  _AuthChangeNotifier(this._authCubit) {
    _authCubit.stream.listen((_) => notifyListeners());
  }
}
