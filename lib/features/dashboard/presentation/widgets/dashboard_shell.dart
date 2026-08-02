import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'dashboard_shared_widgets.dart';
import 'dashboard_sidebar.dart';

/// Outer shell layout containing sidebar, topbar, mobile drawer and navbar.
class DashboardShell extends StatefulWidget {
  final Widget child;

  const DashboardShell({super.key, required this.child});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  bool _sidebarCollapsed = false;

  void _toggleSidebar() {
    setState(() {
      _sidebarCollapsed = !_sidebarCollapsed;
    });
  }

  String _getPageTitle(String location) {
    if (location.startsWith(AppRoutes.patients)) return 'Patients';
    if (location.startsWith(AppRoutes.appointments)) return 'Appointments';
    if (location.startsWith(AppRoutes.clinics)) return 'Clinics';
    if (location.startsWith(AppRoutes.doctors)) return 'Doctors';
    if (location.startsWith(AppRoutes.medicalRecords)) return 'Medical Records';
    if (location.startsWith(AppRoutes.prescriptions)) return 'Prescriptions';
    if (location.startsWith(AppRoutes.reviews)) return 'Reviews';
    if (location.startsWith(AppRoutes.notifications)) return 'Notifications';
    if (location.startsWith(AppRoutes.reports)) return 'Reports & Analytics';
    return 'Dashboard';
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.go(AppRoutes.login);
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          drawer: Responsive.isMobile(context)
              ? Drawer(
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  child: DashboardSidebar(
                    user: user,
                    isCollapsed: false,
                    onToggle: () => Navigator.of(context).pop(),
                  ),
                )
              : null,
          appBar: Responsive.isMobile(context)
              ? AppBar(
                  title: Text(
                    _getPageTitle(location),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    const DashboardNotificationBell(),
                    const SizedBox(width: 8),
                    DashboardUserAvatar(user: user),
                    const SizedBox(width: 12),
                  ],
                )
              : null,
          body: ResponsiveLayout(
            mobile: widget.child,
            desktop: Row(
              children: [
                AnimatedContainer(
                  duration: AppConstants.animNormal,
                  width: _sidebarCollapsed
                      ? AppConstants.sidebarCollapsedWidth
                      : AppConstants.sidebarWidth,
                  child: DashboardSidebar(
                    user: user,
                    isCollapsed: _sidebarCollapsed,
                    onToggle: _toggleSidebar,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      DashboardTopBar(
                        user: user,
                        onToggleSidebar: _toggleSidebar,
                      ),
                      Expanded(child: widget.child),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Responsive.isMobile(context)
              ? const DashboardBottomNavBar()
              : null,
        );
      },
    );
  }
}
