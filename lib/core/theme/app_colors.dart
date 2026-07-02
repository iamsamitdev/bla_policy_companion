// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// โทเคนสีของ BLA Design System (อ้างอิงจาก mockup)
/// แยกเป็น token กลาง: แก้ที่เดียวเปลี่ยนทั้งระบบ
abstract final class AppColors {
  // แบรนด์หลัก
  static const Color primary = Color(0xFF1855A3);
  static const Color primaryLight = Color(0xFF2D87D8);
  static const Color primaryDark = Color(0xFF0F2D6B);
  static const Color cyan = Color(0xFF00AEEF);
  static const Color lime = Color(0xFF8DC63F);

  // พื้นหลัง / พื้นผิว / เส้น
  static const Color background = Color(0xFFEFF4FB);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFD5E1F0);

  // ตัวอักษร
  static const Color textDark = Color(0xFF1A2B4A);
  static const Color textMedium = Color(0xFF4A5A78);
  static const Color textSubtle = Color(0xFF8896B0);

  // สถานะ: มีผลบังคับ / อนุมัติ (เขียว)
  static const Color successFg = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color successText = Color(0xFF166534);

  // สถานะ: รอดำเนินการ / กำลังพิจารณา (เหลือง-ส้ม)
  static const Color pendingFg = Color(0xFFD97706);
  static const Color pendingBg = Color(0xFFFEF9C3);
  static const Color pendingText = Color(0xFF92400E);

  // สถานะ: ขาดอายุ / ไม่อนุมัติ (แดง)
  static const Color dangerFg = Color(0xFFDC2626);
  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color dangerText = Color(0xFF991B1B);

  // ข้อมูล / จ่ายแล้ว (ฟ้า)
  static const Color infoBg = Color(0xFFE0F4FD);
  static const Color infoText = Color(0xFF075985);

  // Gradient หลัก (135°)
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  // Gradient เข้ม (หัวหน้าจอใหญ่)
  static const Gradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary, primaryDark],
    stops: [0.0, 0.55, 1.0],
  );
}
