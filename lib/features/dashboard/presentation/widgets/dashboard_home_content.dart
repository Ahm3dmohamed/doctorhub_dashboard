import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/domain/entities/user_entity.dart';

import 'dashboard_home_widgets.dart';
import 'dashboard_shared_widgets.dart';

class DashboardHomeContent extends StatelessWidget {
  final UserEntity user;

  const DashboardHomeContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: Responsive.pagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardWelcomeHeader(user: user),

          const SizedBox(height: AppConstants.space6),

          DashboardStatsGrid(role: user.role),

          const SizedBox(height: AppConstants.space6),

          ResponsiveLayout(
            mobile: Column(
              children: [
                DashboardQuickActionsCard(role: user.role),
                const SizedBox(height: AppConstants.space4),
                const DashboardRecentActivityCard(),
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 3, child: DashboardRecentActivityCard()),
                const SizedBox(width: AppConstants.space5),
                Expanded(
                  flex: 2,
                  child: DashboardQuickActionsCard(role: user.role),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
