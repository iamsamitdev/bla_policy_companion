// lib/core/widgets/section_label.dart
import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

/// หัวข้อย่อยของ section (เช่น "บัญชีของฉัน", "การตั้งค่า", "ประวัติการชำระ")
class SectionLabel extends StatelessWidget {
  final String text;
  final Widget? trailing;

  const SectionLabel(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppType.h3),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
