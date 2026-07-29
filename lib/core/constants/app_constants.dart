/// DoctorHub — Application-wide Constants
abstract class AppConstants {
  // ─── App Info ─────────────────────────────────────────────────────────────
  static const String appName = 'DoctorHub';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Healthcare Management Platform';

  // ─── Storage Keys ─────────────────────────────────────────────────────────
  static const String keyAuthToken = 'auth_token';
  static const String keyUser = 'user_data';
  static const String keyRememberMe = 'remember_me';
  static const String keyThemeMode = 'theme_mode';
  static const String keyUserRole = 'user_role';

  // ─── Responsive Breakpoints (px) ─────────────────────────────────────────
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // ─── Layout ───────────────────────────────────────────────────────────────
  static const double sidebarWidth = 260.0;
  static const double sidebarCollapsedWidth = 72.0;
  static const double topBarHeight = 64.0;
  static const double maxContentWidth = 1280.0;

  // ─── Animation Durations ──────────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 250);
  static const Duration animSlow = Duration(milliseconds: 400);
  static const Duration animVerySlow = Duration(milliseconds: 600);

  // ─── Spacing Scale ────────────────────────────────────────────────────────
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  static const double space16 = 64.0;

  // ─── Border Radius ────────────────────────────────────────────────────────
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2xl = 24.0;
  static const double radiusFull = 9999.0;

  // ─── Elevation / Shadow ───────────────────────────────────────────────────
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;

  // ─── Validation ───────────────────────────────────────────────────────────
  static const int passwordMinLength = 8;
  static const int nameMinLength = 2;

  // ─── Mock API Delay ───────────────────────────────────────────────────────
  static const Duration mockApiDelay = Duration(milliseconds: 1200);
}
