import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/domain/entities/user_entity.dart';

/// Displays a role-filtered grid of statistic cards on the dashboard home.
class DashboardStatsGrid extends StatelessWidget {
  final UserRole role;

  const DashboardStatsGrid({super.key, required this.role});

  List<_StatCardData> _buildStats(UserRole role, AppLocalizations l10n) => [
    _StatCardData(
      label: l10n.dashTotalPatients,
      value: '1,248',
      change: '+12%',
      isPositive: true,
      icon: Icons.people_rounded,
      gradient: AppColors.primaryGradient,
      route: AppRoutes.patients,
    ),
    _StatCardData(
      label: l10n.dashTodayAppointments,
      value: '24',
      change: '+3',
      isPositive: true,
      icon: Icons.calendar_today_rounded,
      gradient: AppColors.successGradient,
      route: AppRoutes.appointments,
    ),
    _StatCardData(
      label: l10n.dashPendingReviews,
      value: '7',
      change: '-2',
      isPositive: true,
      icon: Icons.rate_review_rounded,
      gradient: AppColors.warningGradient,
      route: AppRoutes.reviews,
    ),
    if (role == UserRole.superAdmin || role == UserRole.clinicManager)
      _StatCardData(
        label: l10n.dashActiveDoctors,
        value: '18',
        change: '+1',
        isPositive: true,
        icon: Icons.medical_services_rounded,
        gradient: AppColors.infoGradient,
        route: AppRoutes.doctors,
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stats = _buildStats(role, l10n);
    final columns = _gridColumns(context).clamp(1, 4);

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

  int _gridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 800) return 2;
    return 1;
  }
}

/// Immutable data class for a single statistic card.
class _StatCardData {
  final String label;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final LinearGradient gradient;
  final String route;

  const _StatCardData({
    required this.label,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.gradient,
    required this.route,
  });
}

class _StatCardWidget extends StatefulWidget {
  final _StatCardData stat;

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
      child: GestureDetector(
        onTap: () => context.go(widget.stat.route),
        child: AnimatedContainer(
          duration: AppConstants.animFast,
          padding: const EdgeInsets.all(AppConstants.space5),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 20,
                      spreadRadius: -2,
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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: widget.stat.gradient,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusLg,
                      ),
                    ),
                    child: Icon(
                      widget.stat.icon,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
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
                    style: AppTypography.headingXl(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
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
      ),
    );
  }
}

// ─── Recent Activity ──────────────────────────────────────────────────────────

/// Card listing recent clinic activity items.
class DashboardRecentActivityCard extends StatelessWidget {
  const DashboardRecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final activities = [
      _ActivityData(
        icon: Icons.person_add_rounded,
        title: 'New patient registered',
        subtitle: 'Emma Thompson',
        time: '2 min ago',
        color: AppColors.primary,
        route: AppRoutes.patients,
      ),
      _ActivityData(
        icon: Icons.check_circle_rounded,
        title: 'Appointment completed',
        subtitle: 'Dr. Johnson — Room 4',
        time: '18 min ago',
        color: AppColors.success,
        route: AppRoutes.appointments,
      ),
      _ActivityData(
        icon: Icons.schedule_rounded,
        title: 'Appointment rescheduled',
        subtitle: 'Michael Chen → 3:00 PM',
        time: '1 hr ago',
        color: AppColors.warning,
        route: AppRoutes.appointments,
      ),
      _ActivityData(
        icon: Icons.medical_services_rounded,
        title: 'Lab results uploaded',
        subtitle: 'Sarah Williams',
        time: '2 hrs ago',
        color: AppColors.info,
        route: AppRoutes.medicalRecords,
      ),
      _ActivityData(
        icon: Icons.notifications_rounded,
        title: 'System alert',
        subtitle: 'Scheduled maintenance tonight',
        time: '3 hrs ago',
        color: AppColors.accent,
        route: AppRoutes.notifications,
      ),
    ];

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
                l10n.dashRecentActivity,
                style: AppTypography.headingSm(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.notifications),
                child: Text(
                  l10n.commonViewAll,
                  style: AppTypography.bodySm(
                    color: AppColors.primary,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space3),
          ...activities.asMap().entries.map(
            (e) => _ActivityItem(
              data: e.value,
              isLast: e.key == activities.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;
  final String route;

  const _ActivityData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.route,
  });
}

class _ActivityItem extends StatelessWidget {
  final _ActivityData data;
  final bool isLast;

  const _ActivityItem({required this.data, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        InkWell(
          onTap: () => context.go(data.route),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.space3,
              horizontal: 4,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: Icon(data.icon, size: 18, color: data.color),
                ),
                const SizedBox(width: AppConstants.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: AppTypography.bodyMd(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          weight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        data.subtitle,
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
                  data.time,
                  style: AppTypography.labelSm(
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
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

// ─── Quick Actions ────────────────────────────────────────────────────────────

/// Card listing role-filtered quick action buttons.
class DashboardQuickActionsCard extends StatelessWidget {
  final UserRole role;

  const DashboardQuickActionsCard({super.key, required this.role});

  List<_QuickActionData> _buildActions(UserRole role, AppLocalizations l10n) =>
      [
        _QuickActionData(
          icon: Icons.person_add_rounded,
          label: l10n.dashAddPatient,
          color: AppColors.primary,
          route: AppRoutes.patients,
        ),
        _QuickActionData(
          icon: Icons.event_available_rounded,
          label: l10n.dashBookAppointment,
          color: AppColors.success,
          route: AppRoutes.appointments,
        ),
        if (role == UserRole.doctor || role == UserRole.superAdmin)
          _QuickActionData(
            icon: Icons.note_add_rounded,
            label: l10n.dashNewPrescription,
            color: AppColors.info,
            route: AppRoutes.prescriptions,
          ),
        if (role == UserRole.superAdmin || role == UserRole.clinicManager)
          _QuickActionData(
            icon: Icons.person_search_rounded,
            label: l10n.navDoctors,
            color: AppColors.warning,
            route: AppRoutes.doctors,
          ),
        _QuickActionData(
          icon: Icons.download_rounded,
          label: l10n.dashViewAnalytics,
          color: AppColors.accent,
          route: AppRoutes.reports,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final actions = _buildActions(role, l10n);

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
            l10n.dashQuickActions,
            style: AppTypography.headingSm(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.space4),
          ...actions.map((a) => _QuickActionButton(data: a)),
        ],
      ),
    );
  }
}

class _QuickActionData {
  final IconData icon;
  final String label;
  final Color color;
  final String route;

  const _QuickActionData({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  });
}

class _QuickActionButton extends StatefulWidget {
  final _QuickActionData data;

  const _QuickActionButton({required this.data});

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.data.route),
        child: AnimatedContainer(
          duration: AppConstants.animFast,
          margin: const EdgeInsets.only(bottom: AppConstants.space2),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space3,
            vertical: AppConstants.space3,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.data.color.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.data.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Icon(
                  widget.data.icon,
                  size: 18,
                  color: widget.data.color,
                ),
              ),
              const SizedBox(width: AppConstants.space3),
              Text(
                widget.data.label,
                style: AppTypography.bodyMd(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const Spacer(),
              Icon(
                isRtl
                    ? Icons.arrow_back_ios_rounded
                    : Icons.arrow_forward_ios_rounded,
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
