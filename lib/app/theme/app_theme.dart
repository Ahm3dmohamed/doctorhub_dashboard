import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// DoctorHub — Material 3 Theme Configuration
/// Stripe/Linear inspired: clean surfaces, indigo primary, smooth elevations
class AppTheme {
  AppTheme._();

  // ─── Light Theme ──────────────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: _lightColorScheme,
        textTheme: _textTheme,
        scaffoldBackgroundColor: AppColors.lightBackground,
        appBarTheme: _lightAppBarTheme,
        cardTheme: _lightCardTheme,
        inputDecorationTheme: _lightInputDecorationTheme,
        elevatedButtonTheme: _lightElevatedButtonTheme,
        outlinedButtonTheme: _lightOutlinedButtonTheme,
        textButtonTheme: _lightTextButtonTheme,
        checkboxTheme: _checkboxTheme,
        dividerTheme: const DividerThemeData(
          color: AppColors.lightBorder,
          thickness: 1,
          space: 1,
        ),
        navigationRailTheme: _lightNavRailTheme,
        chipTheme: _lightChipTheme,
        snackBarTheme: _snackBarTheme,
        tooltipTheme: _tooltipTheme,
        pageTransitionsTheme: _pageTransitionsTheme,
      );

  // ─── Dark Theme ───────────────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: _darkColorScheme,
        textTheme: _textTheme,
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: _darkAppBarTheme,
        cardTheme: _darkCardTheme,
        inputDecorationTheme: _darkInputDecorationTheme,
        elevatedButtonTheme: _darkElevatedButtonTheme,
        outlinedButtonTheme: _darkOutlinedButtonTheme,
        textButtonTheme: _darkTextButtonTheme,
        checkboxTheme: _checkboxTheme,
        dividerTheme: const DividerThemeData(
          color: AppColors.darkBorder,
          thickness: 1,
          space: 1,
        ),
        navigationRailTheme: _darkNavRailTheme,
        chipTheme: _darkChipTheme,
        snackBarTheme: _snackBarTheme,
        tooltipTheme: _tooltipTheme,
        pageTransitionsTheme: _pageTransitionsTheme,
      );

  // ─── Color Schemes ────────────────────────────────────────────────────────
  static final ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.accent,
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFEDE9FE),
    onSecondaryContainer: AppColors.accentDark,
    tertiary: AppColors.info,
    onTertiary: Colors.white,
    tertiaryContainer: AppColors.infoLight,
    onTertiaryContainer: const Color(0xFF1D4ED8),
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: AppColors.errorLight,
    onErrorContainer: AppColors.errorDark,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    surfaceContainerHighest: AppColors.lightSurfaceVariant,
    onSurfaceVariant: AppColors.lightTextSecondary,
    outline: AppColors.lightBorder,
    outlineVariant: AppColors.lightDivider,
    shadow: AppColors.lightShadow,
    scrim: Colors.black54,
    inverseSurface: AppColors.neutral900,
    onInverseSurface: AppColors.neutral50,
    inversePrimary: AppColors.primaryLight,
  );

  static final ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryLight,
    onPrimary: AppColors.primaryContainerDark,
    primaryContainer: AppColors.primaryContainerDark,
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.accentLight,
    onSecondary: AppColors.accentDark,
    secondaryContainer: const Color(0xFF2E1065),
    onSecondaryContainer: AppColors.accentLight,
    tertiary: AppColors.info,
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFF1E3A5F),
    onTertiaryContainer: const Color(0xFF93C5FD),
    error: const Color(0xFFFCA5A5),
    onError: AppColors.errorDark,
    errorContainer: const Color(0xFF7F1D1D),
    onErrorContainer: const Color(0xFFFCA5A5),
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    surfaceContainerHighest: AppColors.darkSurfaceVariant,
    onSurfaceVariant: AppColors.darkTextSecondary,
    outline: AppColors.darkBorder,
    outlineVariant: AppColors.darkDivider,
    shadow: AppColors.darkShadow,
    scrim: Colors.black87,
    inverseSurface: AppColors.neutral100,
    onInverseSurface: AppColors.neutral900,
    inversePrimary: AppColors.primary,
  );

  // ─── Text Theme ───────────────────────────────────────────────────────────
  static final TextTheme _textTheme = GoogleFonts.interTextTheme();

  // ─── AppBar Themes ────────────────────────────────────────────────────────
  static final AppBarTheme _lightAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.lightSurface,
    foregroundColor: AppColors.lightTextPrimary,
    elevation: 0,
    scrolledUnderElevation: 1,
    shadowColor: AppColors.lightShadow,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
    ),
    iconTheme: const IconThemeData(color: AppColors.lightTextSecondary, size: 20),
  );

  static final AppBarTheme _darkAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.darkTextPrimary,
    elevation: 0,
    scrolledUnderElevation: 1,
    shadowColor: AppColors.darkShadow,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),
    iconTheme: const IconThemeData(color: AppColors.darkTextSecondary, size: 20),
  );

  // ─── Card Themes ──────────────────────────────────────────────────────────
  static final CardThemeData _lightCardTheme = CardThemeData(
    color: AppColors.lightSurface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: AppColors.lightBorder, width: 1),
    ),
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
  );

  static final CardThemeData _darkCardTheme = CardThemeData(
    color: AppColors.darkSurface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: AppColors.darkBorder, width: 1),
    ),
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
  );

  // ─── Input Decoration Themes ──────────────────────────────────────────────
  static InputDecorationTheme _buildInputTheme({
    required Color fillColor,
    required Color borderColor,
    required Color focusedBorderColor,
    required Color labelColor,
    required Color hintColor,
    required Color errorColor,
  }) =>
      InputDecorationTheme(
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: errorColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: labelColor, fontWeight: FontWeight.w500),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: hintColor),
        errorStyle: GoogleFonts.inter(fontSize: 12, color: errorColor),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      );

  static final InputDecorationTheme _lightInputDecorationTheme = _buildInputTheme(
    fillColor: AppColors.lightSurface,
    borderColor: AppColors.lightBorder,
    focusedBorderColor: AppColors.primary,
    labelColor: AppColors.lightTextSecondary,
    hintColor: AppColors.lightTextMuted,
    errorColor: AppColors.error,
  );

  static final InputDecorationTheme _darkInputDecorationTheme = _buildInputTheme(
    fillColor: AppColors.darkSurfaceVariant,
    borderColor: AppColors.darkBorder,
    focusedBorderColor: AppColors.primaryLight,
    labelColor: AppColors.darkTextSecondary,
    hintColor: AppColors.darkTextMuted,
    errorColor: const Color(0xFFFCA5A5),
  );

  // ─── Button Themes ────────────────────────────────────────────────────────
  static ElevatedButtonThemeData _buildElevatedButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: -0.1),
        ),
      );

  static final ElevatedButtonThemeData _lightElevatedButtonTheme =
      _buildElevatedButtonTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      );

  static final ElevatedButtonThemeData _darkElevatedButtonTheme =
      _buildElevatedButtonTheme(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.primaryContainerDark,
      );

  static final OutlinedButtonThemeData _lightOutlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.lightBorder, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );

  static final OutlinedButtonThemeData _darkOutlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );

  static final TextButtonThemeData _lightTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
    ),
  );

  static final TextButtonThemeData _darkTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
    ),
  );

  // ─── Checkbox Theme ───────────────────────────────────────────────────────
  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return AppColors.primary;
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
    side: const BorderSide(color: AppColors.neutral400, width: 1.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    visualDensity: VisualDensity.compact,
  );

  // ─── Navigation Rail Themes ───────────────────────────────────────────────
  static final NavigationRailThemeData _lightNavRailTheme =
      NavigationRailThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedIconTheme: const IconThemeData(color: AppColors.primary, size: 20),
        unselectedIconTheme: const IconThemeData(color: AppColors.lightTextSecondary, size: 20),
        selectedLabelTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
        unselectedLabelTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextSecondary,
        ),
        indicatorColor: AppColors.primaryContainer,
        elevation: 0,
        useIndicator: true,
      );

  static final NavigationRailThemeData _darkNavRailTheme =
      NavigationRailThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedIconTheme: const IconThemeData(color: AppColors.primaryLight, size: 20),
        unselectedIconTheme: const IconThemeData(color: AppColors.darkTextSecondary, size: 20),
        selectedLabelTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryLight,
        ),
        unselectedLabelTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextSecondary,
        ),
        indicatorColor: AppColors.primaryContainerDark,
        elevation: 0,
        useIndicator: true,
      );

  // ─── Chip Themes ──────────────────────────────────────────────────────────
  static final ChipThemeData _lightChipTheme = ChipThemeData(
    backgroundColor: AppColors.lightSurfaceVariant,
    labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
    side: const BorderSide(color: AppColors.lightBorder),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  );

  static final ChipThemeData _darkChipTheme = ChipThemeData(
    backgroundColor: AppColors.darkSurfaceVariant,
    labelStyle: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextSecondary,
    ),
    side: const BorderSide(color: AppColors.darkBorder),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  );

  // ─── SnackBar Theme ───────────────────────────────────────────────────────
  static final SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    backgroundColor: AppColors.neutral900,
    contentTextStyle: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: AppColors.neutral50,
    ),
    actionTextColor: AppColors.primaryLight,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 4,
  );

  // ─── Tooltip Theme ────────────────────────────────────────────────────────
  static final TooltipThemeData _tooltipTheme = TooltipThemeData(
    decoration: BoxDecoration(
      color: AppColors.neutral900,
      borderRadius: BorderRadius.circular(6),
    ),
    textStyle: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.neutral50,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  );

  // ─── Page Transitions ─────────────────────────────────────────────────────
  static const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
    builders: {
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );
}
