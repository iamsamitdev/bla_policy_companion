// lib/core/theme/app_typography.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// ตัวอักษรของ Design System
/// ใช้ Inter (อังกฤษ/ตัวเลข) ผสม Anuphan (ไทย) — Anuphan เป็น fallback ที่รองรับไทยสวย
abstract final class AppType {
  static final List<String> _thaiFallback = [GoogleFonts.anuphan().fontFamily!];

  static TextStyle _base(
    double size,
    FontWeight weight, {
    Color? color,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color ?? AppColors.textDark,
      height: height,
    ).copyWith(fontFamilyFallback: _thaiFallback);
  }

  static TextStyle get display => _base(28, FontWeight.w700);
  static TextStyle get h1 => _base(22, FontWeight.w700);
  static TextStyle get h2 => _base(18, FontWeight.w700);
  static TextStyle get h3 => _base(16, FontWeight.w600);
  static TextStyle get title => _base(15, FontWeight.w600);
  static TextStyle get body =>
      _base(14, FontWeight.w400, color: AppColors.textMedium, height: 1.4);
  static TextStyle get bodyStrong => _base(14, FontWeight.w600);
  static TextStyle get label =>
      _base(13, FontWeight.w500, color: AppColors.textMedium);
  static TextStyle get caption =>
      _base(12, FontWeight.w400, color: AppColors.textSubtle);
  static TextStyle get tiny =>
      _base(11, FontWeight.w500, color: AppColors.textSubtle);
}
