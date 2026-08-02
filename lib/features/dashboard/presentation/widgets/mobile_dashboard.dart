import 'package:doctorhub_dashboard/features/auth/domain/entities/user_entity.dart';
import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/dashboard_home_content.dart';
import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/dashboard_shared_widgets.dart';
import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/dashboard_sidebar.dart';
import 'package:doctorhub_dashboard/features/dashboard/presentation/widgets/mobile_appbar_title.dart';
import 'package:flutter/material.dart';

class MobileDashboard extends StatelessWidget {
  final UserEntity user;
  final int selectedIndex;
  final ValueChanged<int> onNavTap;
  final Animation<double> fadeAnimation;

  const MobileDashboard({
    super.key,
    required this.user,
    required this.selectedIndex,
    required this.onNavTap,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MobileAppBarTitle(),
        actions: [
          const DashboardNotificationBell(),
          const SizedBox(width: 8),
          DashboardUserAvatar(user: user),
          const SizedBox(width: 12),
        ],
      ),
      body: FadeTransition(
        opacity: fadeAnimation,
        child: DashboardHomeContent(user: user),
      ),
      bottomNavigationBar: const DashboardBottomNavBar(),
    );
  }
}
