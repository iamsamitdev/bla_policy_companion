// lib/core/icons/app_icons.dart
library;

import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart' as hi;

// ส่งออกรายชื่อไอคอน (HugeIcons.strokeRounded*) ให้ทั้งแอปใช้ได้
// แต่ซ่อน HugeIcon ตัวจริงของแพ็กเกจ เพื่อใช้ wrapper ของเราแทน
export 'package:hugeicons/hugeicons.dart' hide HugeIcon;

/// ชนิดข้อมูลไอคอน Hugeicons (ใช้แทน IconData เดิม)
typedef AppIconData = List<List<dynamic>>;

/// ค่าชดเชยเชิงทัศนภาพ ให้ hugeicon ดูสมดุลเทียบเท่า Material icon ขนาดเดียวกัน
const double kIconOpticalScale = 0.84;

/// ไอคอนของแอป — ห่อ `HugeIcon` ของแพ็กเกจ พร้อมชดเชยขนาดให้สมดุล
class HugeIcon extends StatelessWidget {
  final AppIconData icon;
  final Color? color;
  final Color? secondaryColor;
  final double? size;
  final double? strokeWidth;

  const HugeIcon({
    super.key,
    required this.icon,
    this.color,
    this.secondaryColor,
    this.size,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final base = size ?? IconTheme.of(context).size ?? 24.0;
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: hi.HugeIcon(
        icon: icon,
        color: color,
        secondaryColor: secondaryColor,
        size: base * kIconOpticalScale,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
