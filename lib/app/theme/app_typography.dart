import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTypography {
  static TextStyle display2xl({Color? color}) => GoogleFonts.inter(
    fontSize: 72,
    fontWeight: FontWeight.w800,
    letterSpacing: -2.0,
    height: 1.1,
    color: color,
  );

  static TextStyle displayXl({Color? color}) => GoogleFonts.inter(
    fontSize: 60,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.5,
    height: 1.1,
    color: color,
  );

  static TextStyle displayLg({Color? color}) => GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.15,
    color: color,
  );

  static TextStyle displayMd({Color? color}) => GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.75,
    height: 1.2,
    color: color,
  );

  static TextStyle displaySm({Color? color}) => GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.25,
    color: color,
  );

  // ─── Headings ─────────────────────────────────────────────────────────────
  static TextStyle headingXl({Color? color}) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
    color: color,
  );

  static TextStyle headingLg({Color? color}) => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.35,
    color: color,
  );

  static TextStyle headingMd({Color? color}) => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.4,
    color: color,
  );

  static TextStyle headingSm({Color? color}) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.45,
    color: color,
  );

  static TextStyle headingXs({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.5,
    color: color,
  );

  // ─── Body ─────────────────────────────────────────────────────────────────
  static TextStyle bodyXl({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 18,
        fontWeight: weight ?? FontWeight.w400,
        height: 1.65,
        color: color,
      );

  static TextStyle bodyLg({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: weight ?? FontWeight.w400,
        height: 1.6,
        color: color,
      );

  static TextStyle bodyMd({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: weight ?? FontWeight.w400,
        height: 1.6,
        color: color,
      );

  static TextStyle bodySm({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 13,
        fontWeight: weight ?? FontWeight.w400,
        height: 1.55,
        color: color,
      );

  static TextStyle bodyXs({Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: weight ?? FontWeight.w400,
        height: 1.5,
        color: color,
      );

  // ─── Labels ───────────────────────────────────────────────────────────────
  static TextStyle labelLg({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
    color: color,
  );

  static TextStyle labelMd({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.4,
    color: color,
  );

  static TextStyle labelSm({Color? color}) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.35,
    color: color,
  );

  // ─── Code / Mono ──────────────────────────────────────────────────────────
  static TextStyle codeMd({Color? color}) => GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: color,
  );

  // ─── App Brand ────────────────────────────────────────────────────────────
  static TextStyle brand({Color? color}) => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: color ?? AppColors.primary,
  );

  // ─── Button Text ──────────────────────────────────────────────────────────
  static TextStyle buttonLg({Color? color}) => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.0,
    color: color,
  );

  static TextStyle buttonMd({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.0,
    color: color,
  );

  static TextStyle buttonSm({Color? color}) => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.0,
    color: color,
  );
}
