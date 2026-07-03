// lib/core/widgets/app_logo.dart
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// โลโก้ BLA แบบการ์ดสี่เหลี่ยมมุมโค้ง (ใช้ในหน้า Splash / Login / หัวข้อ)
class AppLogo extends StatelessWidget {
  final double size;
  final bool full; // true = โลโก้เต็ม (มีข้อความ), false = ไอคอนอย่างเดียว
  final double radius;

  const AppLogo({
    super.key,
    this.size = 84,
    this.full = false,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // การ์ดทรงสี่เหลี่ยมจัตุรัสทั้งแบบเต็ม (โลโก้+ข้อความซ้อนแนวตั้ง) และแบบไอคอน
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.16),
      child: Image.asset(
        full ? 'assets/images/bla_logo_full.png' : 'assets/images/bla_icon.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
