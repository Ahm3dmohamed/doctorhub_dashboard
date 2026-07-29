import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _sidebarCollapsed = false;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: AppConstants.animSlow,
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(AppRoutes.login);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          body: ResponsiveLayout(
            mobile: _MobileDashboard(
              user: user,
              selectedIndex: _selectedIndex,
              onNavTap: (i) => setState(() => _selectedIndex = i),
              fadeAnimation: _fadeAnimation,
            ),
            desktop: _DesktopDashboard(
              user: user,
              selectedIndex: _selectedIndex,
              sidebarCollapsed: _sidebarCollapsed,
              onNavTap: (i) => setState(() => _selectedIndex = i),
              onToggleSidebar: () =>
                  setState(() => _sidebarCollapsed = !_sidebarCollapsed),
              fadeAnimation: _fadeAnimation,
            ),
          ),
        );
      },
    );
  }
}

// ─── Desktop Dashboard ─────────────────────────────────────────────────────────

class _DesktopDashboard extends StatelessWidget {
  final UserEntity user;
  final int selectedIndex;
  final bool sidebarCollapsed;
  final ValueChanged<int> onNavTap;
  final VoidCallback onToggleSidebar;
  final Animation<double> fadeAnimation;

  const _DesktopDashboard({
    required this.user,
    required this.selectedIndex,
    required this.sidebarCollapsed,
    required this.onNavTap,
    required this.onToggleSidebar,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sidebar
        AnimatedContainer(
          duration: AppConstants.animNormal,
          width: sidebarCollapsed
              ? AppConstants.sidebarCollapsedWidth
              : AppConstants.sidebarWidth,
          child: _Sidebar(
            user: user,
            selectedIndex: selectedIndex,
            onNavTap: onNavTap,
            isCollapsed: sidebarCollapsed,
            onToggle: onToggleSidebar,
          ),
        ),

        // Main Content
        Expanded(
          child: Column(
            children: [
              // Top Bar
              _TopBar(user: user, onToggleSidebar: onToggleSidebar),

              // Content
              Expanded(
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: _DashboardContent(user: user),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Mobile Dashboard ──────────────────────────────────────────────────────────

class _MobileDashboard extends StatelessWidget {
  final UserEntity user;
  final int selectedIndex;
  final ValueChanged<int> onNavTap;
  final Animation<double> fadeAnimation;

  const _MobileDashboard({
    required this.user,
    required this.selectedIndex,
    required this.onNavTap,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_hospital_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Text('DoctorHub', style: AppTypography.headingSm()),
          ],
        ),
        actions: [
          _NotificationBell(),
          const SizedBox(width: 8),
          _AvatarButton(user: user),
          const SizedBox(width: 12),
        ],
      ),
      body: FadeTransition(
        opacity: fadeAnimation,
        child: _DashboardContent(user: user),
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: selectedIndex,
        onTap: onNavTap,
        user: user,
      ),
    );
  }
}

// ─── Sidebar ───────────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final UserEntity user;
  final int selectedIndex;
  final ValueChanged<int> onNavTap;
  final bool isCollapsed;
  final VoidCallback onToggle;

  const _Sidebar({
    required this.user,
    required this.selectedIndex,
    required this.onNavTap,
    required this.isCollapsed,
    required this.onToggle,
  });

  List<_NavItem> _getNavItems(UserRole role) => [
    const _NavItem(icon: Icons.grid_view_rounded, label: 'Dashboard'),
    if (role == UserRole.superAdmin || role == UserRole.doctor)
      const _NavItem(icon: Icons.people_rounded, label: 'Patients'),
    if (role == UserRole.superAdmin || role == UserRole.doctor)
      const _NavItem(icon: Icons.calendar_month_rounded, label: 'Appointments'),
    if (role == UserRole.superAdmin || role == UserRole.clinicManager)
      const _NavItem(icon: Icons.local_hospital_rounded, label: 'Clinics'),
    if (role == UserRole.superAdmin)
      const _NavItem(icon: Icons.people_outline_rounded, label: 'Doctors'),
    const _NavItem(icon: Icons.analytics_rounded, label: 'Analytics'),
    const _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navItems = _getNavItems(user.role);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            height: AppConstants.topBarHeight,
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 16 : AppConstants.space5,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: AppConstants.space3),
                  Expanded(
                    child: Text(
                      'DoctorHub',
                      style: AppTypography.brand(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
                IconButton(
                  onPressed: onToggle,
                  icon: Icon(
                    isCollapsed
                        ? Icons.chevron_right_rounded
                        : Icons.chevron_left_rounded,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Nav Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.space3,
                horizontal: AppConstants.space3,
              ),
              itemCount: navItems.length,
              itemBuilder: (context, i) => _SidebarNavItem(
                item: navItems[i],
                isSelected: selectedIndex == i,
                isCollapsed: isCollapsed,
                onTap: () => onNavTap(i),
              ),
            ),
          ),

          // User Profile
          Container(
            padding: EdgeInsets.all(isCollapsed ? 12 : AppConstants.space4),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: isCollapsed
                ? _UserAvatar(user: user, size: 36)
                : _UserProfileTile(user: user),
          ),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  final _NavItem item;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.item,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: widget.isCollapsed ? widget.item.label : '',
      preferBelow: false,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: AppConstants.animFast,
            margin: const EdgeInsets.only(bottom: 2),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isCollapsed ? 12 : AppConstants.space3,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : _isHovered
                  ? (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.04))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Row(
              children: [
                Icon(
                  widget.item.icon,
                  size: 18,
                  color: widget.isSelected
                      ? AppColors.primary
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                ),
                if (!widget.isCollapsed) ...[
                  const SizedBox(width: AppConstants.space3),
                  Text(
                    widget.item.label,
                    style: AppTypography.bodyMd(
                      color: widget.isSelected
                          ? AppColors.primary
                          : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
                      weight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Top Bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final UserEntity user;
  final VoidCallback? onToggleSidebar;

  const _TopBar({required this.user, this.onToggleSidebar});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: AppConstants.topBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.space5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          // Search (placeholder)
          Expanded(
            child: Container(
              height: 36,
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 16,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Search patients, appointments...',
                    style: AppTypography.bodyMd(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          _NotificationBell(),

          const SizedBox(width: AppConstants.space4),

          _AvatarButton(user: user),
        ],
      ),
    );
  }
}

// ─── Dashboard Content ─────────────────────────────────────────────────────────

class _DashboardContent extends StatelessWidget {
  final UserEntity user;

  const _DashboardContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: Responsive.pagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          _WelcomeHeader(user: user),

          const SizedBox(height: AppConstants.space6),

          // Stats Grid
          _StatsGrid(role: user.role),

          const SizedBox(height: AppConstants.space6),

          // Recent Activity + Quick Actions
          ResponsiveLayout(
            mobile: Column(
              children: [
                _QuickActionsCard(role: user.role),
                const SizedBox(height: AppConstants.space4),
                _RecentActivityCard(),
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _RecentActivityCard()),
                const SizedBox(width: AppConstants.space5),
                Expanded(flex: 2, child: _QuickActionsCard(role: user.role)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  final UserEntity user;

  const _WelcomeHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$greeting, ',
                      style: AppTypography.headingXl(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    TextSpan(
                      text: user.name.split(' ').first,
                      style: AppTypography.headingXl(color: AppColors.primary),
                    ),
                    TextSpan(text: ' 👋', style: AppTypography.headingXl()),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Here\'s what\'s happening at your clinic today',
                style: AppTypography.bodyMd(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        // Role badge
        _RoleBadge(role: user.role),
      ],
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final UserRole role;

  const _RoleBadge({required this.role});

  Color get _color => switch (role) {
    UserRole.superAdmin => AppColors.superAdminColor,
    UserRole.doctor => AppColors.doctorColor,
    UserRole.clinicManager => AppColors.clinicManagerColor,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(role.emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(role.displayName, style: AppTypography.labelMd(color: _color)),
        ],
      ),
    );
  }
}

// ─── Stats Grid ────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final UserRole role;

  const _StatsGrid({required this.role});

  List<_StatCard> _getStats(UserRole role) => [
    _StatCard(
      label: 'Total Patients',
      value: '1,248',
      change: '+12%',
      isPositive: true,
      icon: Icons.people_rounded,
      gradient: AppColors.primaryGradient,
    ),
    _StatCard(
      label: 'Today\'s Appointments',
      value: '24',
      change: '+3 from yesterday',
      isPositive: true,
      icon: Icons.calendar_today_rounded,
      gradient: AppColors.successGradient,
    ),
    _StatCard(
      label: 'Pending Reviews',
      value: '7',
      change: '-2 from last week',
      isPositive: true,
      icon: Icons.rate_review_rounded,
      gradient: AppColors.warningGradient,
    ),
    if (role == UserRole.superAdmin || role == UserRole.clinicManager)
      _StatCard(
        label: 'Active Doctors',
        value: '18',
        change: '+1 this month',
        isPositive: true,
        icon: Icons.medical_services_rounded,
        gradient: AppColors.infoGradient,
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final stats = _getStats(role);
    final columns = Responsive.gridColumns(context).clamp(1, 4);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: AppConstants.space4,
        mainAxisSpacing: AppConstants.space4,
        childAspectRatio: 1.8,
      ),
      itemCount: stats.length,
      itemBuilder: (context, i) => _StatCardWidget(stat: stats[i]),
    );
  }
}

class _StatCard {
  final String label;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final LinearGradient gradient;

  const _StatCard({
    required this.label,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.gradient,
  });
}

class _StatCardWidget extends StatefulWidget {
  final _StatCard stat;

  const _StatCardWidget({required this.stat});

  @override
  State<_StatCardWidget> createState() => _StatCardWidgetState();
}

class _StatCardWidgetState extends State<_StatCardWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        transform: _isHovered
            ? Matrix4.translationValues(0.0, -2.0, 0.0)
            : Matrix4.identity(),
        padding: const EdgeInsets.all(AppConstants.space5),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: -4,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: widget.stat.gradient,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: Icon(widget.stat.icon, color: Colors.white, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: widget.stat.isPositive
                        ? AppColors.successLight
                        : AppColors.errorLight,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusFull,
                    ),
                  ),
                  child: Text(
                    widget.stat.change,
                    style: AppTypography.labelSm(
                      color: widget.stat.isPositive
                          ? AppColors.successDark
                          : AppColors.errorDark,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.stat.value,
                  style: AppTypography.displaySm(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  widget.stat.label,
                  style: AppTypography.bodySm(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Recent Activity ───────────────────────────────────────────────────────────

class _RecentActivityCard extends StatelessWidget {
  static const _activities = [
    (
      Icons.person_add_rounded,
      'New patient registered',
      'Emma Thompson',
      '2 min ago',
      AppColors.primary,
    ),
    (
      Icons.check_circle_rounded,
      'Appointment completed',
      'Dr. Johnson — Room 4',
      '18 min ago',
      AppColors.success,
    ),
    (
      Icons.schedule_rounded,
      'Appointment rescheduled',
      'Michael Chen → 3:00 PM',
      '1 hr ago',
      AppColors.warning,
    ),
    (
      Icons.medical_services_rounded,
      'Lab results uploaded',
      'Sarah Williams',
      '2 hrs ago',
      AppColors.info,
    ),
    (
      Icons.notifications_rounded,
      'System alert',
      'Scheduled maintenance tonight',
      '3 hrs ago',
      AppColors.accent,
    ),
  ];

  const _RecentActivityCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppConstants.space5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: AppTypography.headingSm(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View all',
                  style: AppTypography.bodySm(
                    color: AppColors.primary,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space3),
          ..._activities.asMap().entries.map(
            (e) => _ActivityItem(
              icon: e.value.$1,
              title: e.value.$2,
              subtitle: e.value.$3,
              time: e.value.$4,
              color: e.value.$5,
              isLast: e.key == _activities.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;
  final bool isLast;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.space3),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: AppConstants.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyMd(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        weight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.bodySm(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: AppTypography.labelSm(
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            height: 1,
          ),
      ],
    );
  }
}

// ─── Quick Actions ─────────────────────────────────────────────────────────────

class _QuickActionsCard extends StatelessWidget {
  final UserRole role;

  const _QuickActionsCard({required this.role});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actions = _getActions(role);

    return Container(
      padding: const EdgeInsets.all(AppConstants.space5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTypography.headingSm(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.space4),
          ...actions.map(
            (action) => _QuickActionButton(
              icon: action.$1,
              label: action.$2,
              color: action.$3,
            ),
          ),
        ],
      ),
    );
  }

  List<(IconData, String, Color)> _getActions(UserRole role) => [
    (Icons.person_add_rounded, 'Add New Patient', AppColors.primary),
    (Icons.event_available_rounded, 'Schedule Appointment', AppColors.success),
    if (role == UserRole.doctor || role == UserRole.superAdmin)
      (Icons.note_add_rounded, 'Create Medical Note', AppColors.info),
    if (role == UserRole.superAdmin || role == UserRole.clinicManager)
      (Icons.person_search_rounded, 'Find Doctor', AppColors.warning),
    (Icons.download_rounded, 'Export Reports', AppColors.accent),
  ];
}

class _QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: AppConstants.animFast,
          margin: const EdgeInsets.only(bottom: AppConstants.space2),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space3,
            vertical: AppConstants.space3,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.color.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Icon(widget.icon, size: 18, color: widget.color),
              ),
              const SizedBox(width: AppConstants.space3),
              Text(
                widget.label,
                style: AppTypography.bodyMd(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Nav (Mobile) ───────────────────────────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final UserEntity user;

  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
      selectedLabelStyle: AppTypography.labelSm(),
      unselectedLabelStyle: AppTypography.labelSm(),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_rounded),
          label: 'Patients',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_rounded),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_rounded),
          label: 'Analytics',
        ),
      ],
    );
  }
}

// ─── Shared Supporting Widgets ────────────────────────────────────────────────

class _UserAvatar extends StatelessWidget {
  final UserEntity user;
  final double size;

  const _UserAvatar({required this.user, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          user.initials,
          style: AppTypography.labelMd(color: Colors.white),
        ),
      ),
    );
  }
}

class _UserProfileTile extends StatelessWidget {
  final UserEntity user;

  const _UserProfileTile({required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Builder(
      builder: (context) {
        return PopupMenuButton(
          child: Row(
            children: [
              _UserAvatar(user: user),
              const SizedBox(width: AppConstants.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.name,
                      style: AppTypography.bodyMd(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        weight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.role.displayName,
                      style: AppTypography.labelSm(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          itemBuilder: (_) => [
            PopupMenuItem(
              onTap: () => context.read<AuthCubit>().logout(),
              child: Row(
                children: [
                  const Icon(
                    Icons.logout_rounded,
                    size: 16,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Sign Out',
                    style: AppTypography.bodyMd(color: AppColors.error),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 20),
          onPressed: () {},
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarButton extends StatelessWidget {
  final UserEntity user;

  const _AvatarButton({required this.user});

  @override
  Widget build(BuildContext context) {
    return _UserAvatar(user: user);
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
