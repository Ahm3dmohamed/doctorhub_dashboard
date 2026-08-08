import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// DoctorHub — AppResponsiveGrid
/// A reusable grid builder that automatically adapts its column count based on available width.
class AppResponsiveGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;

  const AppResponsiveGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.mainAxisSpacing = AppConstants.space4,
    this.crossAxisSpacing = AppConstants.space4,
    this.childAspectRatio = 1.0,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > AppConstants.tabletBreakpoint
            ? desktopColumns
            : (constraints.maxWidth > AppConstants.mobileBreakpoint
                ? tabletColumns
                : mobileColumns);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
