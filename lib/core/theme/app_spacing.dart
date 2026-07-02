// lib/core/theme/app_spacing.dart
import 'package:flutter/widgets.dart';

/// โทเคนระยะห่าง / มุมโค้ง ของ Design System
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  // มุมโค้ง (radius)
  static const double rSm = 10; // input
  static const double rMd = 14; // card / button
  static const double rLg = 20; // การ์ดใหญ่ / sheet
  static const double rPill = 999; // chip / badge

  // EdgeInsets ที่ใช้บ่อย
  static const EdgeInsets pageH = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets card = EdgeInsets.all(lg);
}
