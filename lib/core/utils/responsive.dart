import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// DoctorHub — Responsive Utilities
/// Breakpoints aligned with Tailwind CSS / Linear design system
enum ScreenSize { mobile, tablet, desktop, wide }

class Responsive {
  Responsive._();

  // ─── Breakpoints ──────────────────────────────────────────────────────────
  static const double _mobileMax = 767;
  static const double _tabletMin = 768;
  static const double _tabletMax = 1199;
  static const double _desktopMin = 1200;
  static const double _wideMin = 1536;

  // ─── Screen Size Helpers ──────────────────────────────────────────────────
  static ScreenSize getSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= _mobileMax) return ScreenSize.mobile;
    if (width <= _tabletMax) return ScreenSize.tablet;
    if (width < _wideMin) return ScreenSize.desktop;
    return ScreenSize.wide;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= _mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= _tabletMin && w <= _tabletMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= _desktopMin;

  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= _wideMin;

  static bool isTabletOrAbove(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= _tabletMin;

  static bool isDesktopOrAbove(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= _desktopMin;

  // ─── Value Selector ───────────────────────────────────────────────────────
  /// Returns a different value based on current screen size.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? wide,
  }) {
    final size = getSize(context);
    switch (size) {
      case ScreenSize.wide:
        return wide ?? desktop ?? tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.mobile:
        return mobile;
    }
  }

  // ─── Padding Helpers ──────────────────────────────────────────────────────
  static EdgeInsets pagePadding(BuildContext context) => value(
        context,
        mobile: const EdgeInsets.all(16),
        tablet: const EdgeInsets.all(24),
        desktop: const EdgeInsets.all(32),
      );

  static double contentMaxWidth(BuildContext context) => value(
        context,
        mobile: double.infinity,
        tablet: 720,
        desktop: 1280,
        wide: 1440,
      );

  // ─── Grid Columns ─────────────────────────────────────────────────────────
  static int gridColumns(BuildContext context) => value(
        context,
        mobile: 1,
        tablet: 2,
        desktop: 3,
        wide: 4,
      );

  // ─── Layout Helpers ───────────────────────────────────────────────────────
  static bool showSidebar(BuildContext context) => isDesktopOrAbove(context);

  static bool showBottomNav(BuildContext context) => isMobile(context);

  // ─── Web-specific ─────────────────────────────────────────────────────────
  static bool get isWeb => kIsWeb;
}

/// Responsive Builder Widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize size) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, Responsive.getSize(context));
  }
}

/// Responsive Layout that switches between layouts
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktopOrAbove(context)) return desktop ?? tablet ?? mobile;
    if (Responsive.isTabletOrAbove(context)) return tablet ?? mobile;
    return mobile;
  }
}
